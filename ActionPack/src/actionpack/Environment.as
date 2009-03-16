package actionpack {
    import ReferenceError;
    import flash.display.DisplayObject;
    import flash.utils.Dictionary;
    
    public class Environment {
        private var displayRoot:DisplayObject;
        private var _controllers:Dictionary;
        private var _routes:Routes;
        
        public function Environment(displayRoot:DisplayObject, configuration:Function=null) {
            this._routes = new Routes(this);
            this._controllers = new Dictionary();
            this.displayRoot = displayRoot;
            if(configuration is Function) {
                configuration.call(this, this);
            }
        }
        
        public function get(request:*):* {
            var route:Route;
            var controller:ActionController;
            if(request is String) {
                route = _routes.routeFor(request);
            }
            if(this._controllers[route.controller] == undefined) {
                controller = new route.controller();
                controller.environment = this;
                this._controllers[route.controller] = controller;
            }
            else {
                controller = this._controllers[route.controller];
            }
            
            trace(">> GET CALLED WITH: " + request + " and: " + controller);
            
            return {};
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
    }
}
