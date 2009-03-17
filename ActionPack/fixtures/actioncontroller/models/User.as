package {
    
    public class User {
        public var name:String;
        
        // TODO: Implement finders in ActiveRecord class:
        public static function find(type:String):Array {
            var user:User = new User();
            user.name = 'Luke';
            return new Array(user);
        }
    }
}
