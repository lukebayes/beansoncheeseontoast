package actionpack {

    public class Redirect {
        
        public var path:String;
        public var options:*;
        
        public function Redirect(path:String, options:*=null) {
            this.path = path;
            this.options = options;
        }
    }
}
