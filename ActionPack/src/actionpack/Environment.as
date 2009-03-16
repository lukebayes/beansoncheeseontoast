package actionpack {
    
    public class Environment extends Routes {
        
        public function Environment(locked:ConstantKey) {
        }
        
        public static function create(configuration:Function=null):Environment {
            configuration ||= function():void {};
            var env:Environment = new Environment(new ConstantKey());
            configuration(env);
            return env;
        }
    }
}

// Hackey inner class to prevent external calls to the 
// Environment constructor
class ConstantKey {
}