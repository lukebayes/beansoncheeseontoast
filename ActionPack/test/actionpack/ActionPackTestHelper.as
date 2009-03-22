package actionpack {
    
    import asunit.framework.TestCase;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    
    public class ActionPackTestHelper extends TestCase {
        
        protected var displayRoot:Sprite;
        
        public function ActionPackTestHelper(methodName:String=null) {
            super(methodName);
        }
        
        override protected function setUp():void {
            super.setUp();
            displayRoot = new Sprite();
            addChild(displayRoot);
        }
        
        override protected function tearDown():void {
            super.tearDown();
            removeChild(displayRoot);
        }

        protected function clearDisplay():void {
            if(displayRoot is DisplayObjectContainer) {
                while(displayRoot.numChildren > 0) {
                    displayRoot.removeChildAt(0);
                }
            }
        }
    }
}
