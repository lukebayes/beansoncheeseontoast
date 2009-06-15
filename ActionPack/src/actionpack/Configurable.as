package actionpack {
    
    public class Configurable {
        
        public function Configurable(config:Function=null) {
            applyConfiguration(config);
        }
        
        protected function applyConfiguration(config:Function=null):void {
            if(config is Function) {
                config.call(this);
            }
        }
    }
}
