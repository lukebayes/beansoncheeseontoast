package actionpack {

    import asunit.errors.AssertionFailedError;
    import asunit.errors.UnimplementedFeatureError;
    import asunit.framework.TestCase;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import reflect.Reflection;
    
    /**
    *   Collection of custom assertions and helpers that make it easier
    *   to test Controllers and their respective actions.
    **/
    public class ActionPackTestCase extends TestCase {
        
        protected var displayRoot:Sprite;
        protected var environment:IEnvironment;
        protected var session:Object;

        // Not yet implemented....
        //protected var response:Response;
        
        public function ActionPackTestCase(methodName:String=null) {
            super(methodName)
        }
        
        // Ensure subclasses call super.setUp();
        override protected function setUp():void {
            super.setUp();
            session = {};
            displayRoot = new Sprite();
            addChild(displayRoot);
            setUpEnvironment();
        }
        
        // Override to change the environment configuration:
        protected function setUpEnvironment():void {
            environment = Boot.strap(AbstractEnvironment.TEST, function():void {
                this.displayRoot = displayRoot;
                this.session = session;
            });
        }
        
        override protected function tearDown():void {
            super.tearDown();
            session = null;
            removeChild(displayRoot);
        }
        
        protected function assertResponseSuccess(response:Response):void {
            assertEquals('Response status should be successful', 0, response.request.status);
        }
        
        protected function assertRedirectedTo(response:Response, pathOrRoute:*):void {
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

