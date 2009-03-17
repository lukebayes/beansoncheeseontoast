package  {
    import asunit.framework.TestCase;

    public class CamelCaseTest extends TestCase {

        public function CamelCaseTest(methodName:String=null) {
            super(methodName)
        }

        public function testSimple():void {
            assertEquals('ApplicationLayout', camelcase('application_layout'));
        }

        public function testLongerName():void {
            assertEquals('ApplicationLayoutWithLongName', camelcase('application_layout_with_long_name'));
        }
        
        public function testShortName():void {
            assertEquals('Application', camelcase('application'));
        }
    }
}