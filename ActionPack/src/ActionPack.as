package {
    import flash.display.Sprite;
    import flash.events.Event;
    import actionpack.Environment;
    import actionpack.Routes;
    
    public class ActionPack extends Sprite {
        private var environment:Environment;
        
        public function ActionPack() {
            environment = new Environment(this);
            environment.routes(function(r:Routes):void {
                r.root({'controller' : SiteController});
                r.users({'controller' : UsersController});
            });
            addEventListener(Event.ADDED, addedHandler);
        }
        
        private function addedHandler(event:Event):void {
            if(event.target === this) {
                environment.get('/');
            }
        }
    }
}
