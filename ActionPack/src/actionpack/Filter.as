package actionpack {
    
    public class Filter {
        public var handler:Function;
        public var methodName:String;
        
        public function Filter(handler:Function, methodName:String) {
            this.handler = handler;
            this.methodName = methodName;
        }
    }
}
