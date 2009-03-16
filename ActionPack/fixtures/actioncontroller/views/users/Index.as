package users {
    import flash.display.Sprite;
    
    public class Index extends Sprite {
        
        public function Index() {
        }
        
        public function draw():void {
            graphics.beginFill(0xFF0000);
            graphics.drawRect(0, 0, 200, 100);
            graphics.endFill();
        }
    }
}
