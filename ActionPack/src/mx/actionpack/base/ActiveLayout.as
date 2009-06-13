package mx.actionpack.base {
    
    import actionpack.Environment;
    import actionpack.events.RoutingEvent;
    import flash.display.DisplayObjectContainer;
    import mx.containers.VBox;
    
    [Bindable]
    public class ActiveLayout extends VBox {
        
        public var actionName:String;
        public var controllerName:String;
        public var environment:Environment;
        public var flash:Object;
        public var params:Object;
        public var response:Object;
        public var session:Object;

        public function ActiveLayout() {
            trace(">> ActiveLayout INSTANTIATED with: " + this);
        }
        
        public function get(path:*, sessionData:*=null):* {
            return environment.get(path, sessionData);
        }

        public function get contentContainer():DisplayObjectContainer {
            return this;
        }
    }
}
