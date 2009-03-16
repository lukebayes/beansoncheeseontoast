package actionpack {

    import asunit.framework.TestCase;
    import controllers.UsersController;

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
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}

