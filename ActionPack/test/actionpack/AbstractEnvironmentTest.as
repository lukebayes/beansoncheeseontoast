package actionpack {

    import actionpack.test.ActionPackTestCase;
    import actionpack.events.RoutingEvent;
    import flash.display.Sprite;
    import flash.events.Event;
    import users.Show;
    import reflect.Reflection;

    public class AbstractEnvironmentTest extends ActionPackTestCase {

        public function AbstractEnvironmentTest(methodName:String=null) {
            super(methodName)
        }
        
        override protected function setUp():void {
            super.setUp();
            // update Session with admin user:
            session.currentUser = {
                name : 'bob', 
                role: 'admin'
            }
        }
        
        override protected function tearDown():void {
            super.tearDown();
        }

        public function testConfigureAndLoadRoute():void {
            assertEquals('/site/index', environment.pathFor({controller:SiteController, action:'index'}));
            assertEquals('/users/index', environment.pathFor({controller:UsersController, action:'index'}));
            var response:Response = environment.get('/users');
            var rendered:* = response.view;
            assertSame('users::Index', Reflection.create(rendered).name);
            assertNotNull('response.controller', response.controller);
            assertSame('layouts::ApplicationLayout', Reflection.create(response.layout).name);
        }

        public function testCallGetTwiceEnsureFirstViewIsRemoved():void {
            var response1:Response = environment.get('/users/index');
            assertNotNull('First response should be attached', response1.view.parent);
            
            var response2:Response = environment.get('/users/show');
            assertNotNull('Second response should be attached', response2.view.parent);
            assertNull('First response should no longer be attached', response1.view.parent);
        }

        public function testQueryStrings():void {
            var response:Response = environment.get('/users/show/2?name=luke&height=5.7');
            var params:* = response.controller.params;
            assertEquals('Request should have id param', 2, params['id']);
            assertEquals('Request should have name param', 'luke', params['name']);
            assertEquals('Request should have height param', 5.7, params['height']);
        }
        
        public function testEnsureDuplicateLayoutIsNotReloaded():void {
            var response1:Response = environment.get('/users/index');
            var response2:Response = environment.get('/users/show/2');
            assertSame(response1.layout, response2.layout);
        }
        
        public function testEnsureDuplicateViewIsNotReloaded():void {
            var response1:Response = environment.get('/users/show/1');
            assertEquals('controller.params.id == 1', 1, response1.controller.params['id']);
            assertEquals('request.params.id == 1', 1, response1.request.params['id']);

            var response2:Response = environment.get('/users/show/2');
            assertEquals('controller.params.id == 2', 2, response2.controller.params['id']);
            assertEquals('request.params.id == 2', 2, response2.request.params['id']);

            assertSame(response1.view, response2.view);
        }
        
        public function testRoutingEvent():void {
            var response1:Response = environment.get('/users/index');
            assertNotNull(response1.view);
            response1.view.dispatchEvent(new RoutingEvent('/users/show/1'));
            assertTrue('View should change after event', environment.view is users.Show);
        }
        
        // TODO: Consider sending .get() method an object argument with a transition handler
        // that will allow us to transition from one view (or layout?) to another.
        // maybe something like:
        //
        // get({path:'/users/index', transition:function(from:*, to:*):void {
        //      // animate transition and remove 'from' when complete
        // });

    }
}
