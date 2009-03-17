package layouts {
    import flash.display.Sprite;
    import actionpack.base.ActiveLayout;
    
    dynamic public class ApplicationLayout extends ActiveLayout {
        
        public function ApplicationLayout() {
            backgroundColor = 0x333333;
        }
        
        override public function draw():void {
            if(stage) {
                width = stage.stageWidth;
                height = stage.stageHeight;
            }
            super.draw();
        }
        
    }
}
