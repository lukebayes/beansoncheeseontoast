package environments {
    
    import Environment;
    
    public class Production extends Environment {

        public function Production(config:Function=null) {
            super(function():void {
                // Set up Production configuration here:

                applyConfiguration(config);
            });
        }
    }
}
