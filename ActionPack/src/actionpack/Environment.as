package actionpack {
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    import actionpack.errors.RoutingError;
    import ReferenceError;
    
    public class Environment extends Configurable {
        private var _displayRoot:DisplayObjectContainer;
        private var _controllers:Dictionary;
        private var _routes:Routes;
        
        public function Environment(config:Function=null) {
            _routes = new Routes(this);
            _controllers = new Dictionary();
            super(config);
        }
        
        public function clearDisplay():void {
            if(displayRoot is DisplayObjectContainer) {
                while(displayRoot.numChildren > 0) {
                    displayRoot.removeChildAt(0);
                }
            }
        }
        
        public function set displayRoot(root:*):void {
            _displayRoot = root;
        }
        
        public function get displayRoot():* {
            return _displayRoot;
        }
        
        public function get(request:*):* {
            var route:Route;
            if(request is String) {
                route = _routes.routeFor(request);
            }
            else {
                throw new RoutingError('Environment.get called with unexpected request type: ' + request);
            }
            return getControllerForRoute(route).get(route.action);
        }
        
        public function routes(handler:Function=null):Routes {
            if(handler != null) {
                _routes.configure(handler);
            }
            return _routes;
        }
        
        public function urlFor(options:*):String {
            return _routes.urlFor(options);
        }
        
        private function getControllerForRoute(route:Route):ActionController {
            var controller:ActionController;
            if(_controllers[route.controller] == undefined) {
                controller = new route.controller();
                controller.environment = this;
                return _controllers[route.controller] = controller;
            }
            return _controllers[route.controller];
        }
    }
}
