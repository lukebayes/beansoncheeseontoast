package {
    
    import actionpack.ActionController;
    
    public class UsersController extends ActionController {
        public var allUsers:Array;
        
        public function index():void {
            allUsers = User.find('all');
        }
    }
}
