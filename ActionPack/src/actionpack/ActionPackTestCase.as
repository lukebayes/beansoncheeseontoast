package actionpack {

    import asunit.errors.AssertionFailedError;
    import asunit.errors.UnimplementedFeatureError;
    import asunit.framework.TestCase;
    
    import reflect.Reflection;
    
    public class ActionPackTestCase extends TestCase {

        public function ActionPackTestCase(methodName:String=null) {
            super(methodName)
        }

        protected function assertRedirectedTo(response:Response, pathOrRoute:*):void {
            trace(">> assert redirected to: " + response);
            assertEquals('Unexpected Request.status: ' + response.request.status, ActionController.REDIRECT, response.request.status);
            if(pathOrRoute is String) {
                assertEquals('Unexpected Path from redirect: ' + pathOrRoute, pathOrRoute, response.request.route.path);
            }
            else {
                throw new UnimplementedFeatureError('assertRedirectedTo only accepts path strings at this time');
            }
        }
        
        protected function assertThrows(expectedExceptionType:Class, functionToCall:Function):void {
            var message:String;
            try {
                functionToCall.call(this);
                message ||= 'assertThrows function did not throw an Exception';
                throw new AssertThrowsError(message);
            }
            catch(e:*) {
                if(!(e is expectedExceptionType)) {
                    message ||= 'assertThrows failed with unexpected errory type: ' + Reflection.create(e).name;
                    throw new AssertionFailedError(message);
                }
            }
        }
    }
}

class AssertThrowsError extends Error {
    
    public function AssertThrowsError(message:String = "", id:int = 0) {
        super(message, id);
    }
}

