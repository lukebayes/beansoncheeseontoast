package actionpack {
    
    import actionpack.errors.ActionControllerError;
    import actionpack.errors.RenderError;
    import capitalize;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import reflect.Reflection;
    import reflect.ReflectionMethod;
    
    public class ActionController {
        private static const DEFAULT_ACTION_NAME:String = 'index';
        
        private var _actionName:String;
        private var _controllerName:String;
        private var _controllerPath:String;
        private var _defaultTemplateName:String;
        private var _environment:Environment;
        private var _flash:Object;
        private var _layout:DisplayObjectContainer;
        private var _params:Object;
        private var _redirected:Boolean;
        private var _rendered:Boolean;
        private var _response:Object;
        private var _session:Object;
        
        public function ActionController() {
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
        
        public function set response(response:Object):void {
            _response = response;
        }

        public function get response():Object {
            return _response;
        }
        
        public function set session(session:Object):void {
            _session = session;
        }

        public function get session():Object {
            return _session;
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
        
        public function defaultTemplateName(actionName:String=null):String {
            actionName ||= DEFAULT_ACTION_NAME;
            return _defaultTemplateName = getDefaultTemplateName(actionName);
        }
        
        private function getDefaultTemplateName(actionName:String):String {
            return controllerPath + '/' + actionName;
        }
        
        // Controller entry point to convert URLs to actions and views:
        public function get(actionName:String=null):* {
            _redirected = false;
            actionName ||= DEFAULT_ACTION_NAME;
            this[actionName].call();
            return render(actionName);
        }
        
        public function redirect_to(template:String, options:Object=null):void {
            _redirected = true;
            throw new ActionControllerError('ActionController.redirect_to has not yet been implemented');
        }
        
        public function render(actionName:String, options:Object=null):* {
            // TODO: Instantiate the layout first!
            
            var clazz:Class = attemptToLoadView(actionName);
            var view:* = new clazz();
            configureView(view);
            environment.displayRoot.addChild(view);
            _rendered = true;
            return view;
        }
        
        // Create a Reflection for the concrete controller,
        // and the specific view.
        // Loop over all of the readable members on the controller,
        // and if the view is either dynamic, or has a matching
        // writable member, transfer the value.
        private function configureView(view:*):void {
            var controllerReflection:Reflection = Reflection.create(this);
            var viewReflection:Reflection = Reflection.create(view);
            var self:* = this;
            controllerReflection.readMembers.forEach(function(item:*, index:int, items:Array):void {
                if(viewReflection.isDynamic || viewReflection.hasWriteMember(item.name, item.type)) {
                    //trace(">> setting: " + item.name);
                    view[item.name] = self[item.name];
                }
            });
            
            // TODO: Should we patch methods onto the view too? Probably for helpers at least...
            // We can use something like the following to instantiate and inspect appropriate
            // helper class(es), and then patch their methods onto the view, but execute them
            // in the scope of the controller...
            //
            //controllerReflection.methods.forEach(function(method:ReflectionMethod, index:int, items:Array):void {
            //    if(method.declaredBy == "actionpack::ActionController") {
            //        trace(">> setting method: " + method.name + " with: " + method.declaredBy);
            //        view[method.name] = function(...args):* {
            //            trace(">> VIEW CALLED " + method.name + " METHOD ON " + self + " with: " + args);
            //            self[method.name].apply(self, args);
            //        }
            //    }
            //});
        }
        
        public function templateDoesExist(actionName:String=null):Boolean {
            return attemptToLoadView(actionName) != null;
        }
        
        private function attemptToLoadView(actionName:String=null):Class {
            var resolved:String = templateToClassName(defaultTemplateName(actionName));
            return attemptToLoadClass(resolved);
        }
        
        private function attemptToLoadClass(actionName:String):Class {
            return getDefinitionByName(actionName) as Class;
        }
        
        private function templateToClassName(template:String):String {
            var parts:Array = template.split('/');
            var name:String = capitalize(parts.pop());
            var resolved:String = parts.join('/');
            return resolved += '::' + name;
        }
    }
}
