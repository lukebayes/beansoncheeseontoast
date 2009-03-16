package actionpack {
    import actionpack.errors.RoutingError;
    
    dynamic public class Routes {
        private var _environment:Environment;
        private var _routes:Array;
        
        public function Routes(env:Environment=null) {
            _environment = env;
            _routes = new Array();
        }
        
        public function root(options:Object):void {
            _routes.push(new Route('/', options.controller, options.action));
        }
        
        public function urlFor(options:*):String {
            return findRouteByController(options.controller).name;
        }
        
        public function routeFor(url:String):Route {
            return findFirst(_routes, function(route:Route, index:int, routes:Array):Boolean {
                return (route.name == url);
            });
        }
        
        protected function addNamedRoute(name:String, options:Object=null):void {
            _routes.push(new Route('/' + name, options.controller, options.action));
        }
        
        private function findRouteByController(controller:Class):Route {
            return findFirst(_routes, function(route:Route, index:int, items:Array):Boolean {
                return (route.controller === controller);
            });
        }

        public function configure(config:Function):void {
            try {
                config.call(_environment, this);
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
