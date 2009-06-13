package actionpack {
    
    import actionpack.ActionPackTestCase;
    import flash.display.Sprite;
    import flash.display.DisplayObjectContainer;
    
    public class ActionPackTestHelper extends ActionPackTestCase {
        
        protected var displayRoot:Sprite;
        protected var session:Object;
        
        public function ActionPackTestHelper(methodName:String=null) {
            super(methodName);
        }
        
        override protected function setUp():void {
            super.setUp();
            session = {currentUser : {name : 'bob', role: 'admin'}};
            displayRoot = new Sprite();
            addChild(displayRoot);
        }
        
        override protected function tearDown():void {
            super.tearDown();
            session = null;
            clearDisplay();
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
