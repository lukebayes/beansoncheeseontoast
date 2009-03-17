package actionpack {
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    import actionpack.errors.RoutingError;
    import ReferenceError;
    
    public class Environment {
        private var _displayRoot:DisplayObjectContainer;
        private var _parent:DisplayObjectContainer;
        private var _controllers:Dictionary;
        private var _routes:Routes;
        
        public function Environment(parent:DisplayObjectContainer=null, configuration:Function=null) {
            this._parent = parent || new Sprite();
            this._routes = new Routes(this);
            this._controllers = new Dictionary();
            this._displayRoot = new Sprite();
            _parent.addChild(this._displayRoot);
            if(configuration != null) {
                configuration.call(this, this);
            }
        }
        
        public function clearDisplay():void {
            this._parent.removeChild(this._displayRoot);
            this._parent.addChild(this._displayRoot = new Sprite());
        }
        
        public function get displayRoot():DisplayObjectContainer {
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
