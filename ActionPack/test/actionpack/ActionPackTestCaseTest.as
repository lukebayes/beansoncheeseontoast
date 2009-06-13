package actionpack {

    import asunit.errors.AssertionFailedError;
    
    public class ActionPackTestCaseTest extends ActionPackTestHelper {

        private var environment:Environment;

        public function ActionPackTestCaseTest(methodName:String=null) {
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
        
        private function getUsersIndexWithUnknownUser():Response {
            environment.session = {};
            // Should redirect with from authenticate beforeFilter:
            return environment.get('/users/index');
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
