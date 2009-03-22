package actionpack {
    import actionpack.errors.RoutingError;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.net.URLVariables;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import ReferenceError;
    import reflect.Reflection;
    
    public class Environment extends Configurable {

        private var _displayRoot:DisplayObjectContainer;
        private var _layout:*;
        private var _view:*;
        private var _routes:Routes;
        
        public function Environment(config:Function=null) {
            _routes = new Routes();
            super(config);
        }
        
        public function set displayRoot(root:*):void {
            _displayRoot = root;
        }
        
        public function get displayRoot():* {
            return _displayRoot;
        }
        
        public function set layout(newLayout:*):void {
            if(_layout && _layout.parent === displayRoot) {
                displayRoot.removeChild(_layout);
            }
            _layout = newLayout;
            displayRoot.addChild(newLayout);
        }
        
        public function get layout():* {
            return _layout;
        }
        
        public function set view(newView:*):void {
            if(_view && _view.parent === layout.contentContainer) {
                layout.contentContainer.removeChild(view);
            }
            _view = newView;
            layout.contentContainer.addChild(_view);
        }
        
        public function get view():* {
            return _view;
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
            var request:Request;
            var route:Route;
            
            if(path is String) {
                var parts:Array = path.split('?');
                path = parts.shift();
                var variables:URLVariables = new URLVariables(parts.shift());
                request = new Request(path, variables);
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
            return _routes.pathFor(options);
        }
        
        private function getControllerForRoute(route:Route):ActionController {
            var controller:ActionController;
            controller = new route.controller();
            controller.environment = this;
            return controller;
        }
    }
}
