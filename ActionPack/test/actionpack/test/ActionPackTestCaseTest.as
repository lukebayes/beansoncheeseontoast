package actionpack.test {

    import actionpack.test.ActionPackTestCase;
    import asunit.framework.TestCase;

    public class ActionPackTestCaseTest extends TestCase {
        private var instance:ActionPackTestCase;

        public function ActionPackTestCaseTest(methodName:String=null) {
            super(methodName);
        }

        override protected function setUp():void {
            super.setUp();
            instance = new StubControllerTest();
        }

        override protected function tearDown():void {
            super.tearDown();
            instance = null;
        }

        public function testInstantiated():void {
            assertTrue("instance is ActionPackTestCase", instance is ActionPackTestCase);
        }

        public function testControllerName():void {
            assertEquals('StubController', instance.controllerName);
        }
    }
}

import actionpack.test.ActionPackTestCase;

class StubControllerTest extends ActionPackTestCase {
}
