package actionpack {

    import asunit.framework.TestCase;
    import controllers.UsersController;

    public class EnvironmentTest extends TestCase {

        public function EnvironmentTest(methodName:String=null) {
            super(methodName)
        }

        public function testConfigureRoutes():void {
            var called:Boolean;
            Environment.create(function(e:Environment):void {
                called = true;
                e.root({'controller' : UsersController, 'action' : 'index'});
            });
            
            assertTrue('Configuration handler was called', called);
        }
    }
}