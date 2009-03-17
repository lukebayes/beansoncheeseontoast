package actionpack {

    import asunit.framework.TestCase;

    public class EnvironmentTest extends TestCase {
        private var environment:Environment;

        public function EnvironmentTest(methodName:String=null) {
            super(methodName)
        }
        
        override protected function setUp():void {
            super.setUp();
            environment = new Environment(getContext());
        }
        
        override protected function tearDown():void {
            super.tearDown();
            environment.clearDisplay();
        }

        public function testConfigureAndLoadRoute():void {
            environment.routes(function(r:Routes):void {
                r.users({'controller' : UsersController});
            });

            assertEquals('/users', environment.urlFor({'controller' : UsersController}));
            
            var rendered:* = environment.get('/users');
        }
    }
}
