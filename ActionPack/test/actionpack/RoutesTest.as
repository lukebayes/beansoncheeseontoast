package actionpack {

    import asunit.framework.TestCase;
    import controllers.UsersController;

    public class RoutesTest extends TestCase {

        public function RoutesTest(methodName:String=null) {
            super(methodName)
        }
        
        public function testConfigureAndRetrieveSimpleRoute():void {
            var routes:Routes = new Routes();
            routes.configure(function(r:*):void {
                r.users({'controller' : UsersController});
            });

            assertEquals('/users', routes.urlFor({'controller' : UsersController}));
        }
    }
}