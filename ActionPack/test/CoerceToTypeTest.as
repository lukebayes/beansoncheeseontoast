package  {
    import asunit.framework.TestCase;

    public class CoerceToTypeTest extends TestCase {

        public function CoerceToTypeTest(methodName:String=null) {
            super(methodName)
        }

        public function testString():void {
            assertEquals('hello', coerceToType('hello'));
        }

        public function testNumber():void {
            assertEquals(12, coerceToType('12'));
        }

        public function testTrue():void {
            assertEquals(true, coerceToType('true'));
        }

        public function testFalse():void {
            assertEquals(false, coerceToType('false'));
        }

        public function testClass():void {
            assertEquals(TestCase, coerceToType(TestCase));
        }
    }
}