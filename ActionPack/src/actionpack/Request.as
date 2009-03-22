package actionpack {
    
    public class Request {
        private static const DEFAULT_ACTION:String = 'index';
        
        public var path:String;
        public var route:Route;
        public var options:*;
        public var response:Response;
        public var status:int;
        
        private var _action:String;
        private var _layout:String;
        private var _params:*;
        
        public function Request(path:String, options:*=null) {
            this.path = path;
            this.options = options;
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
        
        public function set layout(path:String):void {
            _layout = path;
        }
        
        public function get layout():String {
            return _layout ||= 'layouts/application_layout';
        }
        
        public function set params(params:*):void {
            _params = params;
        }

        public function get params():* {
            return _params;
        }
    }
}
