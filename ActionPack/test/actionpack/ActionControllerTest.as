package actionpack {

    import asunit.framework.TestCase;

    public class ActionControllerTest extends TestCase {

        public function ActionControllerTest(methodName:String=null) {
            super(methodName)
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
            var controller:UsersController = new UsersController();
            var response:* = controller.get('index');
            assertNotNull('controller.get should return the rendered view', response);
            assertNotNull('UsersController.index should set the users collection', controller.allUsers);
            assertNotNull('Index view should have the users collection', response.allUsers);
            assertNotNull('Index view should have the flash object', response.flash);
        }
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}

