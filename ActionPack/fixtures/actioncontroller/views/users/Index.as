package users {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    
    /**
    *   The view class can be any DisplayObject.
    *   
    *   The only requirement is that it can be added (using addChild)
    *   to whatever DisplayObjectContainer was provided to the Environment
    *   object during configuration.
    *   
    *   So - if you gave the Environment a Flex Application (or IUIComponent),
    *   then your views might need to also be IUIComponents.
    *   If you provided a standard Sprite to the Environment, then your views
    *   can be any class that extends DisplayObject.
    *   
    *   If your view is 'dynamic' (all MXML classes are), then all publicly
    *   readable properties on your Controller will be copied to your views.
    *   
    *   If your view is not 'dynamic', then only properties that are publicly
    *   readable on the Controller, and publicly writable on the view will
    *   be copied.
    *   
    *   This attribute copying can get confusing and messy. For example,
    *   If your MXML class defines a nested VBox with an id='users', you
    *   may lose the ability to target this node if the 'users'
    *   attribute also exists on your Controller.
    *   
    *   Regardless of how your view is constructed, the ActionController
    *   will execute the appropriate action (defined by the route), and 
    *   assuming the action did not trigger a redirect_to, or it's own 
    *   call to 'render', the approprite default view will be selected
    *   and instantiated.
    *   
    *   After being instantiated with an argument-free constructor, 
    *   controller properties will be copied and the view will then
    *   be added to the display list. If your view is written in Flex,
    *   it's layout will be invalidated and the updateDisplayList 
    *   template method will be called. If your view is a simple Sprite,
    *   you may want to add a listener to the Event.ADDED event, check
    *   to see if you're the event.target, and call a draw method or
    *   some such configuration.
    *   
    *   There is a problem with ActionScript, where a package name masks
    *   public properties. This means that when we're in the 'users' package,
    *   we cannot also have a public property called 'users'. Please complain
    *   to Adobe about this if you get a chance.
    **/
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
