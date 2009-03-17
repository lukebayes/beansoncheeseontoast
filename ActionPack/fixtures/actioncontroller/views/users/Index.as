package users {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    
    dynamic public class Index extends Sprite {
        
        public var allUsers:Array;
        
        public function Index() {
            addEventListener(Event.ADDED, addedHandler);
        }
        
        private function addedHandler(event:Event):void {
            if(event.target === this) {
                draw();
            }
        }
        
        public function draw():void {
            graphics.beginFill(0xFF0000);
            graphics.drawRect(0, 0, 200, 100);
            graphics.endFill();
            var lastY:int = 0;
            allUsers.forEach(function(user:User, index:int, users:Array):void {
                var textField:TextField = new TextField();
                textField.text = user.name;
                textField.y = lastY += 20;
                addChild(textField);
            });
        }
    }
}
