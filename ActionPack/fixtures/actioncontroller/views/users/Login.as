package users {
    import actionpack.base.View;
    
    import flash.text.TextField;
    
    dynamic public class Login extends View {
        
        override public function draw():void {
            var label:TextField = new TextField();
            label.text = 'Users::Login';
            addChild(label);
        }
   }
}