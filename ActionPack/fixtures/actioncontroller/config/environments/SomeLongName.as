package environments {
    
    import Environment;
    
    public class SomeLongName extends Environment {

        public function SomeLongName(config:Function=null) {
            super(function():void {
                // Set up Production configuration here:

                applyConfiguration(config);
            });
        }
    }
}
