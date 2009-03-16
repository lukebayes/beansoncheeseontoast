package actionpack {
    
    public class Routes {
        private var _routes:Array;
        
        public function Routes() {
            _routes = new Array();
        }
        
        public function root(options:Object):void {
            _routes.push(new Route('/', options.controller, options.action));
        }
        
        public function urlFor(options:*):String {
            return '/' + findRouteByController(options.controller).name;
        }
        
        protected function addNamedRoute(name:String, options:Object=null):void {
            _routes.push(new Route(name, options.controller, options.action));
        }
        
        private function findRouteByController(controller:Class):Route {
            return findFirst(_routes, function(route:Route, index:int, items:Array):Boolean {
                return (route.controller === controller);
            });
        }
    }
}

class Route {
    public var name:String;
    public var controller:Class;
    public var action:String;
    
    public function Route(name:String, controller:Class, action:String) {
        this.name = name;
        this.controller = controller;
        this.action = action;
    }
}
