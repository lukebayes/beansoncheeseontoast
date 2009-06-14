package actionpack {
    
    public class Configurable {
        
        public function Configurable(config:Function=null) {
            if(config is Function) {
                config.call(this);
            }
        }
    }
}
