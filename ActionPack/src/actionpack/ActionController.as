package actionpack {
    
    import actionpack.Configurable;
    import actionpack.errors.ActionControllerError;
    import actionpack.errors.RenderError;
    import capitalize;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import reflect.Reflection;
    import reflect.ReflectionMethod;
    
    public class ActionController extends Configurable {
        private static const DEFAULT_ACTION_NAME:String = 'index';
        
        private var _actionName:String;
        private var _controllerName:String;
        private var _controllerPath:String;
        private var _defaultActionName:String;
        private var _defaultTemplateName:String;
        private var _environment:Environment;
        private var _flash:Object;
        private var _params:Object;
        private var _redirected:Boolean;
        private var _reflection:Reflection;
        private var _response:Response;
        private var _request:Request;
        private var _session:Object;
        
        public function ActionController(config:Function=null) {
            super(config);
        }
        
        public function set actionName(name:String):void {
            _actionName = name;
        }

        public function get actionName():String {
            return _actionName;
        }

        public function set environment(environment:Environment):void {
            _environment = environment;
        }

        public function get environment():Environment {
            return _environment ||= new Environment();
        }
        
        /**
         * Holds a hash of all the GET, POST, and Url parameters passed to the action. 
         * Accessed like <tt>params["post_id"]</tt> to get the post_id. 
         * No type casts are made, so all values are returned as strings.
         **/
        public function set params(params:Object):void {
            _params = params;
        }

        public function get params():Object {
            return _params;
        }
        
        public function set response(response:Response):void {
            _response = response;
        }

        public function get response():Response {
            return _response;
        }
        
        public function set request(request:Request):void {
            _request = request;
        }
        
        public function get request():Request {
            return _request;
        }
        
        public function set session(session:Object):void {
            _session = session;
        }

        public function get session():Object {
            return _session ||= {};
        }
        
        public function set flash(flash:Object):void {
            _flash = flash;
        }
        
        public function get flash():Object {
            return _flash ||= {};
        }
        
        public function get controllerPath():String {
            return _controllerPath ||= getControllerPath();
        }
        
        private function getControllerPath():String {
            return controllerName;
        }
        
        public function get controllerName():String {
            return _controllerName ||= getControllerName();
        }
        
        private function getControllerName():String {
            return underscore(getQualifiedClassName(this).split('::').pop().replace(/Controller$/, ''));
        }
        
        public function set defaultActionName(name:String):void {
            _defaultActionName = name;
        }
        
        public function get defaultActionName():String {
            return _defaultActionName ||= DEFAULT_ACTION_NAME;
        }
        
        public function defaultTemplateName(actionName:String=null):String {
            actionName ||= defaultActionName;
            return _defaultTemplateName = getDefaultTemplateName(actionName);
        }
        
        private function getDefaultTemplateName(actionName:String):String {
            return controllerPath + '/' + actionName;
        }

        // Controller entry point to convert paths into actions and views:
        public function getAction(requestOrActionName:*):Response {
            if(requestOrActionName is String) {
                request = new Request(requestOrActionName);
            }
            else {
                request = requestOrActionName;
            }
            if(reflection.hasMethod(request.action)) {
                this[request.action].call();
            }
            return render(request);
        }
        
        public function redirectTo(template:String, options:Object=null):void {
            _redirected = true;
            throw new ActionControllerError('ActionController.redirectTo has not yet been implemented');
        }
        
        /**
        *   render method can be called from getAction or from within a 
        *   controller action method body.
        *   
        *   Generally, when this method is called from a controller action
        *   the @requestOrOptions parameter will be a hash of render options,
        *   when it is called from the getAction a prepared Request object
        *   will be sent.
        **/
        public function render(requestOrOptions:*):Response {
            if(requestOrOptions is Request) {
                request = requestOrOptions;
            }
            else {
                for(var key:String in requestOrOptions) {
                    request[key] = requestOrOptions[key];
                }
            }
            
            var lastResponse:Response = (response) ? response : new Response();

            var clazz:Class = actionToViewClass(request.action);
            var view:* = new clazz();
            var layout:* = renderLayout(request);
            // TODO: allow for custom layout directives in the request...
            response = request.response = new Response({
                                                        'request': request,
                                                        'controller' : this,
                                                        'view' : view,
                                                        'layout' : layout
                                                        });
            configureView(response.view);
            layout.contentContainer.addChild(response.view);
            
            lastResponse.removeView();
            return response;
        }
        
        private function renderLayout(request:Request):* {
            var clazz:Class = attemptToLoadClass(pathToClassName(request.layoutPath));
            var layout:* = new clazz();
            configureView(layout);
            environment.displayRoot.addChild(layout);
            return layout;
        }
        
        // Create a Reflection for the concrete controller,
        // and the specific view.
        // Loop over all of the readable members on the controller,
        // and if the view is either dynamic, or has a matching
        // writable member, transfer the value.
        private function configureView(view:*):void {
            var viewReflection:Reflection = Reflection.create(view);
            var self:* = this;
            reflection.readMembers.forEach(function(item:*, index:int, items:Array):void {
                if(viewReflection.isDynamic || viewReflection.hasWriteMember(item.name, item.type)) {
                    view[item.name] = self[item.name];
                }
            });
            
            // TODO: Should we patch methods onto the view too? Probably for helpers at least...
            // We can use something like the following to instantiate and inspect appropriate
            // helper class(es), and then patch their methods onto the view, but execute them
            // in the scope of the controller...
            //
            //reflection.methods.forEach(function(method:ReflectionMethod, index:int, items:Array):void {
            //    if(method.declaredBy == "actionpack::ActionController") {
            //        trace(">> setting method: " + method.name + " with: " + method.declaredBy);
            //        view[method.name] = function(...args):* {
            //            trace(">> VIEW CALLED " + method.name + " METHOD ON " + self + " with: " + args);
            //            self[method.name].apply(self, args);
            //        }
            //    }
            //});
        }
        
        private function actionToViewClass(actionName:String=null):Class {
            var qualifiedClassName:String = pathToClassName(defaultTemplateName(actionName));
            var clazz:Class = attemptToLoadClass(qualifiedClassName);
            if(clazz == null) {
                throw new ActionControllerError('ActionController was unable to load a view for ' + actionName + ' with: ' + qualifiedClassName);
            }
            return clazz;
        }
        
        private function attemptToLoadClass(qualifiedClassName:String):Class {
            return getDefinitionByName(qualifiedClassName) as Class;
        }
        
        private function pathToClassName(path:String):String {
            var parts:Array = path.split('/');
            var name:String = camelcase(parts.pop());
            var resolved:String = parts.join('/');
            return resolved += '::' + name;
        }
        
        protected function get reflection():Reflection {
            return _reflection ||= Reflection.create(this);
        }

        /**
        *  Helper methods that delegate back up to the Environment
        **/

        public function get(path:String=null):* {
            return environment.get(path);
        }
        
        public function pathFor(options:*):String {
            return environment.pathFor(options);
        }

    }
}
