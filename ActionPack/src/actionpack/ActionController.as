package actionpack {
    
    import capitalize;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    
    public class ActionController {
        private static const DEFAULT_ACTION_NAME:String = 'index';
        public static const viewPackages:Array = ['views'];
        public static const controllerPackages:Array = ['controllers'];
        public static const modelPackages:Array = ['models'];
        
        private var _actionName:String;
        private var _controllerName:String;
        private var _controllerPath:String;
        private var _defaultTemplateName:String;
        private var _environment:Environment;
        private var _params:Object;
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
            return _environment;
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
        
        public function defaultTemplateName(actionName:String=DEFAULT_ACTION_NAME):String {
            return _defaultTemplateName = getDefaultTemplateName(actionName);
        }
        
        private function getDefaultTemplateName(actionName:String):String {
            return controllerPath + '/' + actionName;
        }

        public function templateDoesExist(actionName:String=null, templateName:String=null):Boolean {
            actionName ||= DEFAULT_ACTION_NAME;
            templateName ||= defaultTemplateName(actionName);
            var resolved:String = templateToClassName(templateName);
            return attemptToLoadView(resolved) != null;
        }
        
        private function attemptToLoadView(name:String):Class {
            var clazz:Class = null;
            viewPackages.some(function(packageName:String, index:int, items:Array):Boolean {
                return (clazz = attemptToLoadClass(packageName + '.' + name)) != null;
            });
            return clazz;
        }
        
        private function attemptToLoadClass(name:String):Class {
            try {
                return getDefinitionByName(name) as Class;
            }
            catch(e:ReferenceError) {
            }
            return null;
        }
        
        private function templateToClassName(template:String):String {
            var parts:Array = template.split('/');
            var name:String = capitalize(parts.pop());
            var resolved:String = parts.join('/');
            return resolved += '::' + name;
        }
    }
}
