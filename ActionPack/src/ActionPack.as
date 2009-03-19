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
                var self:* = this;
                environment = new Environment(function():void {
                    this.displayRoot = self;
                });
                environment.routes(function():void {
                    this.root({'controller' : SiteController});
                    this.users({'controller' : UsersController});
                    // TODO: Need to implement 'connect'
                    // and support expression arguments
                    //this.connect(':controller/:action');
                    //this.connect(':controller/:action/:id');
                });

                environment.get('/');
            }
        }
    }
}
