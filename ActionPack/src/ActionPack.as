package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.setTimeout;
    import actionpack.IEnvironment;
    import actionpack.Boot;

    public class ActionPack extends Sprite {
        public static const BEANS_ENV:String = 'production';
        
        private var environment:IEnvironment;
        
        public function ActionPack() {
            addEventListener(Event.ADDED, addedHandler);
        }
        
        private function addedHandler(event:Event):void {
            if(event.target === this) {
                var self:* = this;
                environment = Boot.strap(BEANS_ENV, function():void {
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
