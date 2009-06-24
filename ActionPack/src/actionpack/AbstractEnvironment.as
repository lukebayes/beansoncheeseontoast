package actionpack {

    import actionpack.errors.RoutingError;
    import actionpack.events.RoutingEvent;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.IEventDispatcher;
    import flash.net.URLVariables;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import ReferenceError;
    import reflect.Reflection;
    
    public class AbstractEnvironment extends Configurable implements IEnvironment {
        public static const DEVELOPMENT:String = 'development';
        public static const PRODUCTION:String  = 'production';
        public static const TEST:String        = 'test';

        private var _displayRoot:DisplayObjectContainer;
        private var _layout:*;
        private var _view:*;
        private var _session:*;
        private var _routes:ActionRouter;
        
        public function AbstractEnvironment(config:Function=null) {
            _routes = new Routes();
            super(config);
        }
        
        override protected function applyConfiguration(config:Function=null):void {
            super.applyConfiguration(config);
        }
        
        public function set session(session:*):void {
            _session = session;
        }
        
        public function get session():* {
            return _session ||= {};
        }
        
        public function set displayRoot(root:*):void {
            if(_displayRoot) {
                removeConfiguredListeners(_displayRoot);
            }
            _displayRoot = root;
            configureListeners(_displayRoot);
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
        public function get(path:*, sessionData:*=null):* {
            var redirect:Redirect;
            var request:Request;
            var route:Route;
            session = sessionData || session;
            
            if(path is String) {
                var parts:Array = path.split('?');
                path = parts.shift();
                var variables:URLVariables = new URLVariables(parts.shift());
                request = new Request(path, variables);
                route = _routes.routeFor(path);
            }
            else if(path is Redirect) {
                redirect = path as Redirect;
                request = new Request(redirect.path, redirect.options);
                request.status = ActionController.REDIRECT;
                route = _routes.routeFor(redirect.path);
            }
            else {
                return get(_routes.pathFor(path), sessionData);
                /*throw new RoutingError('AbstractEnvironment.get called with unexpected request type: ' + path);*/
            }
            
            if(route == null) {
                throw new RoutingError('AbstractEnvironment.get failed with unhandled path: ' + path);
            }

            request.route = route;
            var controller:ActionController = getControllerForRoute(request.route)
            return controller.getAction(request);
        }
        
        public function routes(config:Function=null):ActionRouter {
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
            var clazz:Class = route.controller;
            if(clazz == null) {
                throw new RoutingError('Unable to find controller for ' + route.path);
            }
            controller = new clazz();
            controller.environment = this;
            controller.session = session;
            return controller;
        }
        
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(RoutingEvent.TYPE, routingEventHandler);
        }

        private function removeConfiguredListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(RoutingEvent.TYPE, routingEventHandler);
        }
        
        private function routingEventHandler(event:RoutingEvent):void {
            this[event.method](event.path);
        }
    }
}
