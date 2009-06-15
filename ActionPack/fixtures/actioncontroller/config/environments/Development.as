package environments {
    
    import Environment;
    
    public class Development extends Environment {

        public function Development(config:Function=null) {
            super(function():void {
                // Set up Development configuration here:

                applyConfiguration(config);
            });
        }
    }
}
