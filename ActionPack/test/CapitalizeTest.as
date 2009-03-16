package  {
    import asunit.framework.TestCase;

    public class CapitalizeTest extends TestCase {

        public function CapitalizeTest(methodName:String=null) {
            super(methodName)
        }

        public function testSimple():void {
            assertEquals('Index', capitalize('index'));
        }
    }
}