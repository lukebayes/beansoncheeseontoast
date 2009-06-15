package environments {
    
    import Environment;
    
    public class Test extends Environment {

        public function Test(config:Function=null) {
            super(function():void {
                // Set up Test configuration here:

                applyConfiguration(config);
            });
        }
    }
}
