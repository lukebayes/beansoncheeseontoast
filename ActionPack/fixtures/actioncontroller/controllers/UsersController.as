package {
    
    import actionpack.ActionController;
    
    public class UsersController extends ActionController {
        public var allUsers:Array;
        
        public function UsersController(config:Function=null) {
            super(config);
        }
        
        public function index():void {
            allUsers = User.find('all');
        }
    }
}
