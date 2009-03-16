package actionpack {
    import ReferenceError;
    import flash.display.DisplayObject;
    
    public class Environment {
        private var displayRoot:DisplayObject;
        private var _routes:Routes;
        
        public function Environment(displayRoot:DisplayObject, configuration:Function=null) {
            this._routes = new Routes(this);
            this.displayRoot = displayRoot;
            if(configuration is Function) {
                configuration.call(this, this);
            }
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
