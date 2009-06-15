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
            routes.configure(function():void {
                this.root({controller : SiteController, action : 'index'});
                this.connect('/people/all', {controller : UsersController, action : 'index'});
                this.connect('/people/:action', {controller : UsersController});
                this.connect('/people/:action/:id', {controller : UsersController});
                this.connect('/:controller/:action/:id');
                this.connect('/:controller/:action');
            });
        }
        
        override protected function tearDown():void {
            routes = null;
            super.tearDown();
        }
        
        protected function assertRoute(route:Route, path:String, controller:Class, action:String=null, id:Number=NaN):void {
            assertNotNull(path + ' should work with default route', route);
            assertEquals(path + ' should load default route', path, route.path);
            assertSame(path + ' should load SiteController', controller, route.controller);
            assertEquals(path + ' should execute ' + action, action, route.action);
            if(!isNaN(id)) {
                assertEquals(path + ' should have id ' + id, id, route.id);
            }
        }
        
        public function testRoot():void {
            var route:Route = routes.routeFor('/');
            assertRoute(route, '/', SiteController, 'index');
        }
        
        public function testConnectDynamicControllerAndDefaultAction():void {
            var route:Route = routes.routeFor('/site');
            assertRoute(route, '/site/:action', SiteController, 'index');
        }
        
        public function testConnectDynamicControllerAndSpecifiedAction():void {
            var route:Route = routes.routeFor('/site/show');
            assertRoute(route, '/site/show', SiteController, 'show');
        }
        
        public function testConnectDynamicControllerAndSpecifiedActionAndId():void {
            var route:Route = routes.routeFor('/site/show/2');
            assertRoute(route, '/site/show/2', SiteController, 'show', 2);
        }
        
        public function testConnectStaticControllerAndDefaultAction():void {
            var route:Route = routes.routeFor('/people');
            assertRoute(route, '/people/:action', UsersController, 'index');
        }
        
        public function testConnectStaticControllerAndStaticAction():void {
            var route:Route = routes.routeFor('/people/all');
            assertRoute(route, '/people/all', UsersController, 'index');
        }
        
        public function testConnectStaticControllerAndSpecifiedAction():void {
            var route:Route = routes.routeFor('/people/show');
            assertRoute(route, '/people/show', UsersController, 'show');
        }
        
        public function testConnectStaticControllerAndSpecifiedActionAndId():void {
            var route:Route = routes.routeFor('/people/show/3');
            assertRoute(route, '/people/show/3', UsersController, 'show', 3);
        }
        
        public function testRouteByHashForUsersIndex():void {
            var route:Route = routes.routeFor({controller : UsersController, action : 'index'});
            assertRoute(route, '/users/index', UsersController, 'index');
        }
        
        public function testRouteByHashForUsersShowWithId():void {
            var route:Route = routes.routeFor({controller : UsersController, action : 'show', 'id' : 3});
            assertRoute(route, '/users/show/3', UsersController, 'show', 3);
        }
        
        public function testToString():void {
            assertNotNull(routes.toString());
        }
    }
}