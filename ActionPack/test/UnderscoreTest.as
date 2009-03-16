package  {

    import asunit.framework.TestCase;

    public class UnderscoreTest extends TestCase {

        public function UnderscoreTest(methodName:String=null) {
            super(methodName)
        }

        public function testSimple():void {
            assertEquals('action_pack', underscore('ActionPack'));
        }
    }
}