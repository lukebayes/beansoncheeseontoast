package actionpack.events {

    import flash.events.Event;
    
    public class RoutingEvent extends Event {
        public static const TYPE:String = 'ROUTING_EVENT';
        private static const BUBBLES:Boolean = true;
        
        public var method:String;
        public var path:*;
        
        public function RoutingEvent(path:*=null, method:String='get') {
            super(TYPE, BUBBLES);
            this.method = method;
            this.path = path;
        }
        
        override public function toString():String {
            return "[RoutingEvent path='" + path + "']";
        }
        
        override public function clone():Event {
            return new RoutingEvent(path);
        }
    }
}