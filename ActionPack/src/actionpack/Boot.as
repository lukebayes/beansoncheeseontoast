package actionpack {
    
    import flash.utils.getDefinitionByName;
    
    /**
    *   Entry point for bringing up an Environment.
    *   
    *   @param env String the environment subclass that should be instantiated
    *   @param config Function an optional configuration function that will
    *   be _called_ so that _this_ applies to the newly-created IEnvironment.
    *   
    *   @example Provide a string environment name in all lower case with
    *   words separated by underscores.
    *   
    *   <listing>
    *   Boot.strap('some_long_name', function():void {
    *       this.routes(function():void {
    *           this.root({controller: 'SiteController', action: 'index'});
    *           this.connect(':controller/:action');
    *           this.connect(':controller/:action/:id');
    *       });
    *   });
    *   </listing>
    **/
    public class Boot {
        
        public static function strap(env:String, config:Function=null):IEnvironment {
            var className:String = 'environments::' + camelcase(env);
            var clazz:Class = getDefinitionByName(className) as Class;
            return new clazz(config);
        }
    }
}
