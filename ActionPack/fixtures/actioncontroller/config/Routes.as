package {
    
    import actionpack.ActionRouter;
    
    dynamic public class Routes extends ActionRouter {
        
        override protected function initialize():void {
            // Put system-wide routes here:
            
            // Default catch-all routes here:
            this.connect('/:controller/:action');
            this.connect('/:controller/:action/:id');
        }
    }
}
