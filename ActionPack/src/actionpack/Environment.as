package actionpack {
    import ReferenceError;
    import flash.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import flash.display.Sprite;
    
    public class Environment {
        private var _displayRoot:DisplayObjectContainer;
        private var _parent:DisplayObjectContainer;
        private var _controllers:Dictionary;
        private var _routes:Routes;
        
        public function Environment(parent:DisplayObjectContainer, configuration:Function=null) {
            this._parent = parent;
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
            
            return controller.get(route.action);
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
