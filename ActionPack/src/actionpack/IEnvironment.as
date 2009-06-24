package actionpack {
    
    public interface IEnvironment {
        
        function set session(session:*):void;
        function get session():*;
        function set displayRoot(root:*):void;
        function get displayRoot():*;
        
        // Provided layout must implement 
        // addChild(view:*):void  and removeChild(view:*):void;
        function set layout(layout:*):void;
        function get layout():*;
        
        // Provided object must be able to be added to layouts:
        function set view(view:*):void;
        function get view():*;
        
        // Initiate a GET request against the Environment:
        function get(path:*, sessionData:*=null):*;

        // Forward configuration function to routes:
        function routes(config:Function=null):ActionRouter;
        
        // Get a path for a hash of options:
        // pathFor({controller: UsersController, action: 'index'}); // '/users'
        function pathFor(options:*):String
    }
}
