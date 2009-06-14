package {
    
    import actionpack.ActionController;
    
    public class UsersController extends ApplicationController {
        
        public var allUsers:Array;
        
        public function UsersController(config:Function=null) {
            super(config);
        }
        
        override protected function initialize():void {
            beforeFilter(authenticate, {except : ['login', 'index']});
            beforeFilter(admin, {only : 'edit'});
        }
        
        public function index():void {
            allUsers = User.find('all');
        }
        
        public function show():void {
        }
        
        public function login():void {
        }
        
        public function edit():void {
        }
    }
}
