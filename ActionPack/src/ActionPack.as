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
            var self:* = this;
            environment = Boot.strap(BEANS_ENV, function():void {
                this.displayRoot = self;
            });

            environment.get('/site');
        }
    }
}
