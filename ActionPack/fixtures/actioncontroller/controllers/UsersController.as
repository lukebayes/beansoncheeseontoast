package {
    
    import actionpack.ActionController;
    
    public class UsersController extends ActionController {
        
        public var allUsers:Array;
        
        public function UsersController(config:Function=null) {
            super(config);
            beforeFilter(authenticate, {'except' : 'login'});
            beforeFilter(admin, {'only' : 'edit'});
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
        
        public function get currentUser():* {
            return session['currentUser'] ||= {'role': 'admin'};
        }
        
        private function authenticate():void {
            if(currentUser == null) {
                flash['warning'] = 'You must sign in to take that action';
                redirectTo('/users/login');
            }
        }

        private function admin():void {
            if(!currentUser || currentUser.role != 'admin') {
                flash['warning'] = 'You must be an administrator to take that action';
                redirectTo('/users/login');
            }
        }
    }
}
