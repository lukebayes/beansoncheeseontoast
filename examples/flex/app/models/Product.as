package {
    
    import flash.events.EventDispatcher;
    
    [Bindable]
    public class Product extends EventDispatcher {
        public var id:int;
        public var name:String;
        public var description:String;
        public var price:Number;
    }
}
