package {
    
    import actionpack.ActionController;
    
    public class ApplicationController extends ActionController {
        
        public function ApplicationController(config:Function=null) {
            super(config);
        }
        
        public function get currentUser():* {
            return session['currentUser'];
        }
        
        protected function authenticate():void {
            if(currentUser == null) {
                flash['warning'] = 'You must sign in to take that action';
                redirectTo('/users/login');
            }
        }
        
        protected function admin():void {
            if(!currentUser || currentUser.role != 'admin') {
                flash['warning'] = 'You must be an administrator to take that action';
                redirectTo('/users/login');
            }
        }
    }
}
