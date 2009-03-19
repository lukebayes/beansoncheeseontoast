package actionpack {
    import actionpack.errors.RoutingError;
    
    dynamic public class Routes {
        private var _routes:Array;
        
        public function Routes() {
            _routes = new Array();
        }

        // The Route class should only be instantiated through this factory,
        // where we can associate the correct environment with created
        // controller instances.
        private function createRoute(name:String, options:*=null):Route {
            var controller:ActionController = new options.controller(function():void {
                this.environment = new Environment();
            });
            return new Route('/' + name, controller, options.action);
        }
        
        public function root(options:Object):void {
            _routes.push(createRoute('/', options));
        }
        
        public function pathFor(options:*):String {
            return routeFor(options).path;
        }
        
        public function routeFor(path:String):Route {
            return findFirst(_routes, function(route:Route, index:int, routes:Array):Boolean {
                return (route.acceptsPath(path));
            });
        }
        
        protected function addNamedRoute(name:String, options:Object=null):void {
            _routes.push(createRoute(name, options))
        }
        
        private function findRouteByOptions(options:*):Route {
            return null;
        }
        
        private function findRouteByController(options:*):Route {
            return findFirst(_routes, function(route:Route, index:int, items:Array):Boolean {
                return (route.controllerInstance === options.controller);
            }).name || options.controller.controllerPath;
        }

        public function configure(config:Function):void {
            try {
                config.call(this);
            }
            catch(te:TypeError) {
                processTypeError(te.message, config);
            }
        }
        
        private function processTypeError(message:String, config:Function):void {
            var result:* = message.match(/\: (\w+) is not a function/i);
            addHookForNamedRoute(result[1], config);
        }
        
        private function addHookForNamedRoute(name:String, config:Function):void {
            if(this[name] != undefined) {
                throw new RoutingError('Attempted to create a named route where a property already exists [' + name + ']');
            }
            this[name] = function(options:Object):void {
                addNamedRoute(name, options);
            }
            // Loop back and run configuration again:
            configure(config);
        }
    }
}
