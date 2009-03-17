package {
    
    public class User {
        public var name:String;
        
        public function User(options:Object=null) {
            if(options != null) {
                for(var key:String in options) {
                    this[key] = options[key];
                }
            }
        }
        
        // TODO: Implement finders in ActiveRecord class:
        public static function find(type:String):Array {
            var users:Array = [];
            users.push(new User({'name':'Luke'}));
            users.push(new User({'name':'Bob'}));
            users.push(new User({'name':'Bill'}));
            return users;
        }
    }
}
