package actionpack {

    import asunit.errors.AssertionFailedError;

    public class ActionControllerTest extends ActionPackTestCase {

        public function ActionControllerTest(methodName:String=null) {
            super(methodName)
        }
        
        override protected function setUp():void {
            super.setUp();
            // Update the session with admin user:
            session.currentUser = {
                name : 'bob', 
                role: 'admin'
            }
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
        
        public function testBeforeFilterExceptRedirected():void {
            var response:Response = environment.get('/users/show', {});
            var controller:* = response.controller;
            assertRedirectedTo(response, '/users/login');
        }

        public function testBeforeFilterExceptPassed():void {
            var response:Response = environment.get('/users/show', {currentUser : {}});
            var controller:* = response.controller;
            assertResponseSuccess(response);
        }

        public function testBeforeFilterOnlyRedirected():void {
            var response:Response = environment.get('/users/show', {});
            var controller:* = response.controller;
            assertRedirectedTo(response, '/users/login');
        }
        
        public function testBeforeFilterOnlyPassed():void {
            var response:Response = environment.get('/users/edit/2', {currentUser : {role: 'admin'}});
            var controller:* = response.controller;
            assertResponseSuccess(response);
        }        private function getUsersIndexWithUnknownUser():Response {
            environment.session = {};
            // Should redirect with from authenticate beforeFilter:
            return environment.get('/users/show');
        }

        public function testAssertRedirectedToWithWrongPath():void {
            var response:Response = getUsersIndexWithUnknownUser();

            assertThrows(AssertionFailedError, function():void {
                assertRedirectedTo(response, '/users/login2');
            });
        }

        public function testAssertRedirectedToWithCorrectPath():void {
            var response:Response = getUsersIndexWithUnknownUser();
            assertRedirectedTo(response, '/users/login');
        }

        public function testAssertRedirectedToWithInvalidResponse():void {
            var response:Response = getUsersIndexWithUnknownUser();
            assertThrows(TypeError, function():void {
                assertRedirectedTo(null, '/users/login');
            });
        }
        
        public function testAssertThrowsWithAFunctionThatDoesNotThrow():void {
            var response:Response = getUsersIndexWithUnknownUser();
            assertThrows(AssertionFailedError, function():void {
                assertThrows(AssertionFailedError, function():void {
                    assertRedirectedTo(response, '/users/login');
                });
            });
        }
    }
}

import actionpack.ActionController;

class MockNamedController extends ActionController {
}

