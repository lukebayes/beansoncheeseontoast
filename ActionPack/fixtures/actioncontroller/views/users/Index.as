package users {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import actionpack.base.View;
    
    public class Index extends View {
        
        public var allUsers:Array;
        
        override public function draw():void {
            backgroundColor = 0xffcc00;
            super.draw();
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
