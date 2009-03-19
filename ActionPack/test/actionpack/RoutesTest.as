package actionpack {

    import asunit.framework.TestCase;
    import reflect.Reflection;

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
            routes.configure(function():void {
                this.root({'controller' : SiteController});
                this.users({'controller' : UsersController});
                this.connect('/people/:action', {'controller' : UsersController, 'action' : 'index'});
                this.connect('/:controller/:action/:id');
                this.connect('/:controller/:action');
            });
            
            var route:Route = routes.routeFor('/site/index');
            assertNotNull('/site/index should work with default route', route);
            assertEquals('/site/index should load default route', '/site/index', route.path);
            assertSame('/site/index should load SiteController', SiteController, route.controller);
            
            route = routes.routeFor('/people/index');
            assertNotNull('/people/index should return a valid route', route);
            assertEquals('/people/index should point at UsersController', '/people/index', route.path);
        }
        
        //public function testConfigureAndRetrieveSimpleRoute():void {
        //    testConfigure();
        //    assertEquals('/users', routes.pathFor({'controller' : UsersController}));
        //    assertEquals('/', routes.pathFor({'controller' : SiteController}));
        //}
        //
        //public function testDefaultRoutes():void {
        //    assertEquals('/users', routes.pathFor({'controller' : UsersController}));
        //}
    }
}