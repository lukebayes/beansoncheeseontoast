package actionpack {

    import asunit.framework.TestCase;
    import controllers.UsersController;

    public class EnvironmentTest extends TestCase {

        public function EnvironmentTest(methodName:String=null) {
            super(methodName)
        }

        public function testConfigureAndRetrieveSimpleRoute():void {
            var env:Environment = new Environment(function(e:*):void {
                e.users({'controller' : UsersController});
            });

            assertEquals('/users', env.urlFor({'controller' : UsersController}))
        }
    }
}