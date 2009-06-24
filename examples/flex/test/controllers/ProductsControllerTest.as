package controllers {

    import actionpack.test.ActionPackTestCase;

    public class ProductsControllerTest extends ActionPackTestCase {
        private var instance:ProductsController;

        public function ProductsControllerTest(methodName:String=null) {
            super(methodName);
        }
        
        public function testShouldGetIndex():void {
            get('index');
            
            assertResponseSuccess();
        }

    }
}
