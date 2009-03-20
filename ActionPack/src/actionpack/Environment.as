package actionpack {
    import actionpack.errors.RoutingError;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import ReferenceError;
    import reflect.Reflection;
    
    public class Environment extends Configurable {

        public var lastController:ActionController;

        private var lastAction:String;
        private var _controllers:Dictionary;
        private var _displayRoot:DisplayObjectContainer;
        private var _routes:Routes;
        
        public function Environment(config:Function=null) {
            _routes = new Routes();
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
        
        /**
        *   The default behavior of a get request will accept a path String that should
        *   match with a defined or default route. The default configuration accepts
        *   :controller_name[/:action_name][/:id]
        *   
        *   Usually like one of the following:
        *   get('users');
        *   get('users/show/2');
        *   get('users/edit/2');
        *   
        *   This method should also accept an options object to support features like 
        *   transitions (and other?)
        **/
        public function get(path:*):* {
            var request:Request = new Request(path);
            var route:Route;
            
            if(path is String) {
                route = _routes.routeFor(path);
            }
            else {
                throw new RoutingError('Environment.get called with unexpected request type: ' + path);
            }
            
            if(route == null) {
                throw new RoutingError('Environment.get failed with unhandled path: ' + path);
            }

            request.route = route;
            return getControllerForRoute(request.route).getAction(request);
        }
        
        public function routes(config:Function=null):Routes {
            if(config is Function) {
                _routes.configure(config);
            }
            return _routes;
        }
        
        public function pathFor(options:*):String {
            if(options.controller == null) {
                options.controller = getDefinitionByName(Reflection.create(lastController).name)
            }
            return _routes.pathFor(options);
        }
        
        private function getControllerForRoute(route:Route):ActionController {
            var controller:ActionController;
            if(_controllers[route.controller] == undefined) {
                controller = new route.controller();
                controller.environment = this;
                _controllers[route.controller] = controller;
            }
            return lastController = _controllers[route.controller];
        }
    }
}
