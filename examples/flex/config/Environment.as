package {
    
    import actionpack.AbstractEnvironment;
    import actionpack.IEnvironment;
    
    public class Environment extends AbstractEnvironment {
        public static var BEANS_ENV:String = 'production';
        
        public function Environment(config:Function=null) {
            super(function():void {
                // Set up global Environment configuration here,
                // configurations that spans Production, Development and Test:

                // Put system-wide routes here:
                this.routes(function():void {
                    this.root({'controller' : ProductsController, 'action' : 'index'});
                    this.connect('/:controller/:action');
                    this.connect('/:controller/:action/:id');
                });
                
                applyConfiguration(config);
            });
        }
    }
}
