package actionpack {

    public class ActionControllerTest extends ActionPackTestHelper {
        private var environment:Environment;

        public function ActionControllerTest(methodName:String=null) {
            super(methodName)
        }
        
        override protected function setUp():void {
            super.setUp();
            environment = new Environment(function():void {
                this.displayRoot = displayRoot;
            });
        }

        public function testControllerName():void {
            var controller:MockNamedController = new MockNamedController();
            assertEquals('mock_named', controller.controllerName);
        }
        
        public function testDefaultTemplateName():void {
            var controller:MockNamedController = new MockNamedController();
            assertEquals('mock_named/index', controller.defaultTemplateName());
        }
        
        public function testDefaultTemplateExists():void {
            var controller:UsersController = new UsersController();
            assertTrue(controller.templateDoesExist());
        }

        public function testSpecifiedTemplateExists():void {
            var controller:UsersController = new UsersController();
            assertTrue(controller.templateDoesExist('show'));
        }
        
        public function testGet():void {
            var controller:UsersController = new UsersController(function():void {
                this.environment = environment;
            });
            var response:* = controller.get('index');
            assertSame('Controller.response is the view and returned', response, controller.response);
            assertNotNull('controller.get should return the rendered view', response);
            assertNotNull('UsersController.index should set the users collection', controller.allUsers);
            assertNotNull('Layout should have the session object', controller.layout.session);
            assertNotNull('Index view should have the users collection', response.allUsers);
            assertNotNull('Index view should have the flash object', response.flash);
        }
        
        public function testCallGetTwiceEnsureFirstViewIsRemoved():void {
            var controller:UsersController = new UsersController(function():void {
                this.environment = environment;
            });
            var response1:* = controller.get('index');
            var response2:* = controller.get('show');
            
            
        }
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}

