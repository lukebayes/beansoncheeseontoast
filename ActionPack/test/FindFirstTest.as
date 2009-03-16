package  {

    import asunit.framework.TestCase;

    public class FindFirstTest extends TestCase {

        public function FindFirstTest(methodName:String=null) {
            super(methodName)
        }

        public function testFindFirstSimple():void {
            var item:String = findFirst(['one', 'two', 'three'], function(item:String, index:int, items:Array):Boolean {
                return (item == 'two');
            });
            
            assertEquals('two', item);
        }
    }
}