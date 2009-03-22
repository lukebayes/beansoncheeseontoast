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
        
        override protected function tearDown():void {
            super.tearDown();
            clearDisplay();
        }

        public function testControllerName():void {
            var controller:MockNamedController = new MockNamedController();
            assertEquals('mock_named', controller.controllerName);
        }
        
        public function testDefaultTemplateName():void {
            var controller:MockNamedController = new MockNamedController();
            assertEquals('mock_named/index', controller.defaultTemplateName());
        }
        
        public function testGet():void {
            var controller:UsersController = new UsersController(function():void {
                this.environment = environment;
            });
            var response:Response = controller.getAction('index');
            assertNotNull('Response should be returned', response);
            assertNotNull('Response should have request', response.request);

            assertNotNull('UsersController.index should set the users collection', controller.allUsers);
            assertNotNull('Layout should have the session object', response.view.session);
            assertNotNull('Index view should have the users collection', response.view.allUsers);
            assertNotNull('Index view should have the flash object', response.view.flash);
        }
        
        public function testParams():void {
            environment.routes(function():void {
                this.connect('/:controller/:action/:id');
            });
            var response:Response = environment.get('/users/show/2');
            assertEquals('Request should have id param', 2, response.controller.params['id']);
        }
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}

