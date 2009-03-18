package actionpack {
    
    public class Configurable {
        
        public function Configurable(config:Function=null) {
            executeConfiguration(config);
        }
        
        private function executeConfiguration(config:Function=null):void {
            if(config is Function) {
                config.call(this);
            }
        }
    }
}
