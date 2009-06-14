package models {

    import asunit.framework.TestCase;

    public class ProductTest extends TestCase {
        private var product:Product;

        public function ProductTest(methodName:String=null) {
            super(methodName);
        }

        override protected function setUp():void {
            super.setUp();
            product = new Product();
        }

        override protected function tearDown():void {
            super.tearDown();
            product = null;
        }

        public function testInstantiated():void {
            assertTrue("product is Product", product is Product);
        }
    }
}
