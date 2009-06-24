package actionpack.test {

    import actionpack.Boot;
    import actionpack.Response;
    import actionpack.IEnvironment;
    import actionpack.AbstractEnvironment;
    import actionpack.ActionController;
    import actionpack.Response;
    import asunit.errors.AssertionFailedError;
    import asunit.errors.UnimplementedFeatureError;
    import asunit.framework.TestCase;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.utils.getDefinitionByName;
    import reflect.Reflection;
    
    /**
    *   Collection of custom assertions and helpers that make it easier
    *   to test Controllers and their respective actions.
    **/
    public class ActionPackTestCase extends TestCase {

        protected var displayRoot:Sprite;
        protected var environment:IEnvironment;
        protected var session:Object;
        protected var response:Response;

        private var _controllerClass:Class;
        private var _controllerName:String;

        // Not yet implemented....
        //protected var response:Response;
        
        public function ActionPackTestCase(methodName:String=null) {
            super(methodName)
        }
        
        // Ensure subclasses call super.setUp();
        override protected function setUp():void {
            super.setUp();
            Environment.BEANS_ENV = AbstractEnvironment.TEST
            session = {};
            displayRoot = new Sprite();
            addChild(displayRoot);
            setUpEnvironment();
        }
        
        // Override to change the environment configuration:
        protected function setUpEnvironment():void {
            environment = Boot.strap(Environment.BEANS_ENV, function():void {
                this.displayRoot = displayRoot;
                this.session     = session;
            });
        }
        
        override protected function tearDown():void {
            super.tearDown();
            _controllerName  = null;
            _controllerClass = null;
            session          = null;
            removeChild(displayRoot);
        }
        
        public function set controllerName(name:String):void {
            _controllerName = name;
        }
        
        public function get controllerName():String {
            return _controllerName ||= inferControllerName();
        }
        
        public function set controllerClass(clazz:Class):void {
            _controllerClass = clazz;
        }
        
        public function get controllerClass():Class {
            return _controllerClass ||= getDefinitionByName(controllerName) as Class;
        }
        
        protected function get(actionOrOptions:*, sessionData:*=null):* {
            var options:* = (actionOrOptions is String) ? {controller: controllerClass, action:actionOrOptions} : actionOrOptions;
            return this.response = environment.get(options, sessionData);
        }
        
        private function inferControllerName():String {
            var regExp:RegExp = /(.*\:\:)([a-zA-Z]*)(Test|TestCase)/gi;
            return Reflection.create(this).name.replace(regExp, '$2');
        }

        protected function assertResponseSuccess(response:Response=null):void {
            response || this.response;
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

