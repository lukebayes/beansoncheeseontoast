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
                    this.routes(function():void {
                        this.site({'controller' : SiteController});
                        this.users({'controller' : UsersController});
                    });
                });

                environment.get('/site');
            }
        }
    }
}
