package users {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import actionpack.base.View;
    import flash.events.MouseEvent;
    
    public class Index extends View {
        
        public var allUsers:Array;
        
        override public function draw():void {
            backgroundColor = 0xffcc00;
            x = y = 10;
            width = parent.width - 20;
            height = parent.height - 20;
            super.draw();
            var lastY:int = 0;
            allUsers.forEach(function(user:User, index:int, users:Array):void {
                var sprite:Sprite = new Sprite();
                sprite.buttonMode = true;
                sprite.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
                    trace(">> ITEM CLICKED WITH: " + user.name);
                });
                sprite.y = lastY += 20;
                sprite.mouseChildren = false;
                var textField:TextField = new TextField();
                textField.selectable = false;
                textField.text = user.name;
                sprite.addChild(textField);
                addChild(sprite);
            });
        }
        
    }
}
