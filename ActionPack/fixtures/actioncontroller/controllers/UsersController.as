package {
    
    import actionpack.ActionController;
    
    public class UsersController extends ActionController {
        
        public var allUsers:Array;
        private var _authenticateAllCalled:Boolean;
        private var _authenticateOnlyCalled:Boolean;
        
        public function UsersController(config:Function=null) {
            super(config);
            beforeFilter(authenticateAll);
            //beforeFilter('authenticateOnly', {'only' : 'show'});
        }
        
        public function index():void {
            allUsers = User.find('all');
        }
        
        public function show():void {
        }
        
        public function get authenticateAllCalled():Boolean {
            return _authenticateAllCalled;
        }
        
        public function get authenticateOnlyCalled():Boolean {
            return _authenticateOnlyCalled;
        }
        
        private function authenticateAll():void {
            _authenticateAllCalled = true;
        }

        private function authenticateOnly():void {
            _authenticateOnlyCalled = true;
        }
    }
}
