package  {
    import asunit.framework.TestCase;

    public class UnderscoreTest extends TestCase {

        public function UnderscoreTest(methodName:String=null) {
            super(methodName)
        }

        public function testSimple():void {
            assertEquals('action_pack', underscore('ActionPack'));
        }
        
        public function testLong():void {
            assertEquals('foo_bar_terrific', underscore('FooBarTerrific'));
        }
    }
}