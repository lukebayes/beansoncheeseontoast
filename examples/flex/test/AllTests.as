package {
    /**
     * This file has been automatically created using
     * #!/usr/bin/ruby script/generate suite
     * If you modify it and run this script, your
     * modifications will be lost!
     */

    import asunit.framework.TestSuite;
    import controllers.ProductsControllerTest;
    import models.ProductTest;

    public class AllTests extends TestSuite {

        public function AllTests() {
            addTest(new controllers.ProductsControllerTest());
            addTest(new models.ProductTest());
        }
    }
}
