package users {
    import actionpack.base.View;
    
    import flash.text.TextField;
    
    dynamic public class Edit extends View {

 
         override public function draw():void {
             var label:TextField = new TextField();
             label.text = 'Users::Edit';
             addChild(label);
         }
   }
}