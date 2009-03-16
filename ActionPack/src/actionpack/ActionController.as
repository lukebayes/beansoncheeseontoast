package actionpack {
    
    import flash.utils.getQualifiedClassName;
    
    public class ActionController {
        private static const DEFAULT_ACTION_NAME:String = 'index';
        
        private var _actionName:String;
        private var _controllerName:String;
        private var _controllerPath:String;
        private var _defaultTemplateName:String;
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
        
    }
}
