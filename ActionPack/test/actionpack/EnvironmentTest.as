package actionpack {

    import flash.display.Sprite;

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
        }
        
        override protected function tearDown():void {
            super.tearDown();
            environment.clearDisplay();
        }

        public function testConfigureAndLoadRoute():void {
            environment.routes(function():void {
                this.users({'controller' : UsersController});
            });

            assertEquals('/users', environment.pathFor({'controller' : UsersController}));
            
            var rendered:* = environment.get('/users');
        }

        //public function testCallGetTwiceEnsureFirstViewIsRemoved():void {
        //    var response1:* = environment.get('/users/index');
        //    assertNotNull('First response should be attached', response1.parent);
        //
        //    var response2:* = environment.get('/users/show');
        //    assertNotNull('Second response should be attached', response2.parent);
        //    assertNull('First response should no longer be attached', response1.parent);
        //}
        
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
