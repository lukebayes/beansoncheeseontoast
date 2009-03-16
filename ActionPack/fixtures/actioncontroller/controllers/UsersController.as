package {
    
    import actionpack.ActionController;
    
    public class UsersController extends ActionController {
        public var users:Array;
        
        public function index():void {
            users = User.find('all');
        }
    }
}
