package actionpack {

    import asunit.framework.TestCase;

    public class ActionControllerTest extends TestCase {
        private var instance:ActionController;

        public function ActionControllerTest(methodName:String=null) {
            super(methodName)
        }

        override protected function setUp():void {
            super.setUp();
            instance = new ActionController();
        }

        override protected function tearDown():void {
            super.tearDown();
            instance = null;
        }

        public function testInstantiated():void {
            assertTrue("instance is ActionController", instance is ActionController);
        }

        public function testControllerName():void {
            var controller:MockNamedController = new MockNamedController();
            assertEquals('mock_named', controller.controllerName);
        }
        
        public function testDefaultTemplateName():void {
            var controller:MockNamedController = new MockNamedController();
            assertEquals('mock_named/index', controller.defaultTemplateName());
        }
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}
