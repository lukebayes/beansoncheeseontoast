package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.setTimeout;
    import actionpack.AbstractEnvironment;
    import actionpack.Routes;

    public class ActionPack extends Sprite {
        private var environment:AbstractEnvironment;
        
        public function ActionPack() {
            addEventListener(Event.ADDED, addedHandler);
        }
        
        private function addedHandler(event:Event):void {
            if(event.target === this) {
                var self:* = this;
                environment = new AbstractEnvironment(function():void {
                    this.displayRoot = self;
                    this.routes(function():void {
                        this.site({controller : SiteController});
                        this.users({controller : UsersController});
                    });
                });

                environment.get('/site');
            }
        }
    }
}
