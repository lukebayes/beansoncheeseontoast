package layouts {
    import flash.display.Sprite;
    import actionpack.base.ActiveView;
    
    dynamic public class ApplicationLayout extends ActiveView {
        
        public function ApplicationLayout() {
            backgroundColor = 0xcccccc;
        }
        
        override public function draw():void {
            if(stage) {
                x = y = 5;
                width = stage.stageWidth - 10;
                height = stage.stageHeight - 10;
            }
            super.draw();
        }
    }
}
