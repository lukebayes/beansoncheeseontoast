package actionpack {
    
    public class Request {
        private static const DEFAULT_ACTION:String = 'index';
        
        public var path:String;
        public var route:Route;
        public var options:*;
        public var response:Response;
        
        private var _action:String;
        private var _layoutPath:String;
        
        public function Request(path:String, options:*=null) {
            this.path = path;
            for(var key:String in options) {
                this[key] = options[key];
            }
        }
        
        public function set action(name:String):void {
            _action = name;
        }
        
        public function get action():String {
            if(_action) {
                return _action;
            }
            return (route && route.action) ? route.action : DEFAULT_ACTION;
        }
        
        public function set layoutPath(path:String):void {
            _layoutPath = path;
        }
        
        public function get layoutPath():String {
            return _layoutPath ||= 'layouts/application_layout';
        }
    }
}
