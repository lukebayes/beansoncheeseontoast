package actionpack {

    import asunit.framework.TestCase;

    public class RoutesTest extends TestCase {
        private var routes:Routes;

        public function RoutesTest(methodName:String=null) {
            super(methodName)
        }
        
        override protected function setUp():void {
            super.setUp();
            routes = new Routes();
        }
        
        override protected function tearDown():void {
            routes = null;
            super.tearDown();
        }
        
        public function testConfigure():void {
            routes.configure(function(r:*):void {
                r.users({'controller' : UsersController});
                r.root({'controller' : SiteController});
            });
        }
        
        public function testConfigureAndRetrieveSimpleRoute():void {
            testConfigure();
            assertEquals('/users', routes.urlFor({'controller' : UsersController}));
            assertEquals('/', routes.urlFor({'controller' : SiteController}));
        }
    }
}