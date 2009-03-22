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
        private var _afterFilters:Array;
        private var _beforeFilters:Array;
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
            _beforeFilters = [];
            _afterFilters = [];
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
            return _params ||= {};
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
            
            buildParams();
            
            executeBeforeFiltersFor(request.action);
            if(reflection.hasMethod(request.action)) {
                this[request.action].call();
            }
            var response:Response = render(request);
            executeAfterFiltersFor(request.action);
            return response;
        }
        
        private function buildParams():void {
            var key:String;
            for(key in request.route) {
                params[key] = request.route[key];
            }
            for(key in request.options) {
                params[key] = request.options[key];
            }
            request.params = params;
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
            var layout:* = renderLayout(request);
            var view:* = renderView(request);
            // TODO: allow for custom layout directives in the request...
            var options:Object = {
                'request': request,
                'controller' : this,
                'view' : view,
                'layout' : layout
            };
            return response = request.response = new Response(options);
        }
        
        protected function beforeFilter(handler:Function, options:*=null):void {
            addBeforeFilterFor(handler, options);
        }
        
        private function addBeforeFilterFor(handler:Function, options:*):void {
            options = options || {'all' : true};
            if(options['all']) {
                addFilterForAll(_beforeFilters, handler);
            }
            else if(options['except']) {
                var except:Array = (options['except'] is String) ? [options['except']] : options['except'];
                addFilterForAllExcept(_beforeFilters, handler, except);
            }
            else if(options['only']) {
                var only:Array = (options['only'] is String) ? [options['only']] : options['only'];
                addFilterForOnly(_beforeFilters, handler, only);
            }
        }

        private function addFilterForAll(filters:Array, handler:Function):void {
            var len:int = reflection.methods.length;
            var method:ReflectionMethod;
            for(var i:int; i < len; i++) {
                method = reflection.methods[i];
                if(method.declaredBy != 'actionpack::ActionController') {
                    filters.push(new Filter(handler, method.name));
                }
            }
        }
        
        private function addFilterForAllExcept(filters:Array, handler:Function, except:Array):void {
            var len:int = reflection.methods.length;
            var method:ReflectionMethod;
            var exceptLen:int = except.length;
            for(var i:int; i < len; i++) {
                method = reflection.methods[i];
                if(method.declaredBy != 'actionpack::ActionController' && except.index(method.name) == -1) {
                    filters.push(new Filter(handler, method.name));
                }
            }
        }
        
        private function addFilterForOnly(filters:Array, handler:Function, only:Array):void {
            var len:int = only.length;
            var methodName:String;
            for(var i:int; i < len; i++) {
                methodName = only[i];
                if(reflection.hasMethod(methodName)) {
                    filters.push(new Filter(handler, methodName));
                }
            }
        }
        
        private function executeBeforeFiltersFor(methodName:String):void {
            var self:* = this;
            _beforeFilters.forEach(function(item:Filter, index:int, items:Array):void {
                if(item.methodName == methodName) {
                    item.handler.call(self);
                }
            });
        }
        
        private function executeAfterFiltersFor(methodName:String):void {
            var self:* = this;
            _afterFilters.forEach(function(item:Filter, index:int, items:Array):void {
                if(item.methodName == methodName) {
                    item.handler.call(self);
                }
            });
        }
        
        private function renderLayout(request:Request):* {
            var className:String = pathToClassName(request.layout);
            return renderDisplayable(request, className, 'layout');
        }
        
        private function renderView(request:Request):* {
            var className:String = actionToViewClassName(request.action);
            return renderDisplayable(request, className, 'view');
        }
        
        private function renderDisplayable(request:Request, className:String, attr:String):* {
            if(!environment[attr] ||
            environment[attr] &&
            className != Reflection.create(environment[attr]).name) {
                var clazz:Class = attemptToLoadClass(className);
                var newView:* = new clazz();
                configureView(newView);
                environment[attr] = newView;
                return newView;
            }
            else {
                var view:* = environment[attr];
                configureView(view);
                return view;
            }
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
            //        view[method.name] = function(...args):* {
            //            self[method.name].apply(self, args);
            //        }
            //    }
            //});
        }
        
        private function actionToViewClassName(actionName:String=null):String {
            return pathToClassName(defaultTemplateName(actionName));
        }
        
        private function attemptToLoadClass(qualifiedClassName:String):Class {
            var clazz:Class = getDefinitionByName(qualifiedClassName) as Class;
            if(clazz == null) {
                throw new ActionControllerError('ActionController was unable to load a view: ' + qualifiedClassName);
            }
            return clazz;
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

        public function get(path:String=null):Response {
            return environment.get(path);
        }
        
        public function pathFor(options:*):String {
            return environment.pathFor(options);
        }

    }
}
