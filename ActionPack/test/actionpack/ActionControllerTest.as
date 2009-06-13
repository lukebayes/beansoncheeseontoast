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
                this.session = session;
                this.routes(function():void {
                    this.connect('/:controller/:action/:id');
                });
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
            var response:Response = environment.get('/users/show/2');
            assertEquals('Request should have id param', 2, response.controller.params['id']);
        }
        
        public function testBasicBeforeFilter():void {
            environment.session = {};
            var response:Response = environment.get('/users/index');
            var controller:* = response.controller;

            assertRedirectedTo(response, '/users/login')
            //assertNotNull('authenticateAll should have been called', controller.currentUser);
            //assertEquals('controller did not redirect', response.action, 'index');
        }

        public function testBasicBeforeFilterForAllExcept():void {
            var response:Response = environment.get('/users/show/2', {currentUser : {role: 'admin'}});
            var controller:* = response.controller;
            //assertFalse('authenticateAll should not ave been called', controller.current);
            //assertTrue('authenticateOnly should have been called', controller.authenticateOnlyCalled);
        }
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}

