package {
    
    import actionpack.ActionRouter;
    
    dynamic public class Routes extends ActionRouter {
        
        override protected function initialize():void {
            // Put application routes here:
            this.users({controller : UsersController});
            this.site({controller : SiteController});
            
            // Default catch-all routes here:
            this.connect('/:controller/:action');
            this.connect('/:controller/:action/:id');
        }
    }
}
