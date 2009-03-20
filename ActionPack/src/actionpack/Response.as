package actionpack {
    
    public class Response {
        public var layout:*;
        public var view:*;
        public var request:Request;
        public var controller:ActionController;
        public var action:String;
        
        public function Response(options:*=null) {
            options ||= {};
            for(var key:String in options) {
                this[key] = options[key];
            }
        }
        
        public function removeView():void {
            if(view && view.parent) {
                view.parent.removeChild(view);
            }
        }
    }
}