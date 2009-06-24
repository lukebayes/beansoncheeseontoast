package {
    
    import actionpack.AbstractEnvironment;
    import actionpack.IEnvironment;
    
    public class Environment extends AbstractEnvironment {
        public static var BEANS_ENV:String = 'production';
        
        public function Environment(config:Function=null) {
            super(function():void {
                // Set up global Environment configuration here,
                // configurations that spans Production, Development and Test:
                applyConfiguration(config);
            });
        }
    }
}
