package actionpack {

    import flash.display.Sprite;
    import reflect.Reflection;

    public class EnvironmentTest extends ActionPackTestHelper {
        private var environment:Environment;

        public function EnvironmentTest(methodName:String=null) {
            super(methodName)
        }
        
        override protected function setUp():void {
            super.setUp();
            environment = new Environment(function():void {
                this.displayRoot = displayRoot;
            });
            environment.routes(function():void {
                this.users({'controller' : UsersController});
            });
        }
        
        override protected function tearDown():void {
            super.tearDown();
            environment.clearDisplay();
        }

        public function testConfigureAndLoadRoute():void {
            assertEquals('/users/index', environment.pathFor({'controller' : UsersController, 'action': 'index'}));
            var response:Response = environment.get('/users');
            var rendered:* = response.view;
            assertSame('users::Index', Reflection.create(rendered).name);
            assertNotNull('lastAction', environment.lastController);
            assertSame('layouts::ApplicationLayout', Reflection.create(response.layout).name);
        }

        public function testCallGetTwiceEnsureFirstViewIsRemoved():void {
            var response1:Response = environment.get('/users/index');
            assertNotNull('First response should be attached', response1.view.parent);
            
            var response2:Response = environment.get('/users/show');
            assertNotNull('Second response should be attached', response2.view.parent);
            assertNull('First response should no longer be attached', response1.view.parent);
        }
        
        //public function testDuplicateRequestShouldDoNothing():void {
        //}
        
        // TODO: Consider sending .get() method an object argument with a transition handler
        // that will allow us to transition from one view (or layout?) to another.
        // maybe something like:
        //
        // get({'path':'/users/index', 'transition':function(from:*, to:*):void {
        //      // animate transition and remove 'from' when complete
        // });
        //
    }
}
