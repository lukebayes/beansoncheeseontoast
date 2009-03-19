package actionpack {
    import actionpack.errors.RoutingError;
    
    dynamic public class Routes {
        private var _routes:Array;
        
        public function Routes() {
            _routes = new Array();
        }

        public function configure(config:Function):void {
            try {
                config.call(this);
            }
            catch(te:TypeError) {
                convertTypeErrorToNamedRoute(te.message, config);
            }
        }
        
        private function convertTypeErrorToNamedRoute(message:String, config:Function):void {
            var result:* = message.match(/\: (\w+) is not a function/i);
            addNamedRoute(result[1]);
            // Loop back and run configuration again:
            configure(config);
        }
        
        private function addNamedRoute(name:String):void {
            if(this[name] != undefined) {
                throw new RoutingError('Attempted to create a named route where a property already exists [' + name + ']');
            }
            this[name] = function(options:Object):void {
                if(options.action == null) {
                    options.action = ':action';
                }
                addRoute('/' + name, options);
            }
        }

        // The Route class should only be instantiated through this factory,
        // where we can associate the correct environment with created
        // controller instances.
        private function createRoute(path:String, options:*=null):Route {
            return new Route(path, options);
        }
        
        public function connect(path:String, options:Object=null):void {
            addRoute(path, options);
        }
        
        public function root(options:Object):void {
            _routes.push(createRoute('/', options));
        }
        
        public function pathFor(options:*):String {
            var len:int = _routes.length;
            var route:Route;
            var path:String;
            for(var i:int; i < len; i++) {
                path = _routes[i].pathFor(options);
                if(path != null) {
                    return path;
                }
            }
            return null;
        }
        
        public function routeFor(path:String):Route {
            var len:int = _routes.length;
            var route:Route;
            for(var i:int; i < len; i++) {
                route = _routes[i].routeForPath(path)
                if(route != null) {
                    return route;
                }
            }
            return null;
        }
        
        protected function addRoute(path:String, options:Object=null):void {
            _routes.push(createRoute(path, options));
        }
        
        private function findRouteByOptions(options:*):Route {
            return null;
        }
        
        private function findRouteByController(options:*):Route {
            return findFirst(_routes, function(route:Route, index:int, items:Array):Boolean {
                return (route.controller === options.controller);
            }).name || options.controller.controllerPath;
        }

    }
}
