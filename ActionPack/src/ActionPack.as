package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.setTimeout;
    import actionpack.Environment;
    import actionpack.Routes;
    
    public class ActionPack extends Sprite {
        private var environment:Environment;
        
        public function ActionPack() {
            addEventListener(Event.ADDED, addedHandler);
        }
        
        private function addedHandler(event:Event):void {
            setTimeout(timeoutComplete, 1000, event);
        }
        
        private function timeoutComplete(event:Event):void {
            if(event.target === this) {
                environment = new Environment(this);
                environment.routes(function(r:Routes):void {
                    r.root({'controller' : SiteController});
                    r.users({'controller' : UsersController});
                    // TODO: Need to implement 'connect'
                    // and support expression arguments
                    //r.connect(':controller/:action');
                    //r.connect(':controller/:action/:id');
                });

                environment.get('/');
            }
        }
    }
}
