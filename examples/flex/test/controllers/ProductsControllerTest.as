package controllers {

    import asunit.framework.TestCase;

    public class ProductsControllerTest extends TestCase {
        private var instance:ProductsController;

        public function ProductsControllerTest(methodName:String=null) {
            super(methodName);
        }

        override protected function setUp():void {
            super.setUp();
            instance = new ProductsController();
        }

        override protected function tearDown():void {
            super.tearDown();
            instance = null;
        }

        public function testInstantiated():void {
            assertTrue("instance is ProductsController", instance is ProductsController);
        }
    }
}
