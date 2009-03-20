package site {
    import actionpack.base.View;
    import actionpack.Environment;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.utils.setTimeout;
    
    public class Index extends View {
        
        public function Index() {
            backgroundColor = 0x00ff00;
            buttonMode = true;
            addEventListener(MouseEvent.CLICK, clickHandler);
        }
        
        private function clickHandler(event:MouseEvent):void {
            backgroundColor = 0xffff00;
            draw();
            environment.get('/users');
        }

        override public function draw():void {
            x = y = 10;
            width = parent.width - 20;
            height = parent.height - 20;
            super.draw();
        }
    }
}
