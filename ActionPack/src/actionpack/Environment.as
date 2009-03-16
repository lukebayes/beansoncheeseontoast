package actionpack {
    import ReferenceError;
    import actionpack.errors.RoutingError;
    
    dynamic public class Environment extends Routes {
        
        public function Environment(configuration:Function=null) {
            configuration ||= function():void {};
            executeConfiguration(configuration);
        }
        
        private function executeConfiguration(config:Function):void {
            try {
                config(this);
            }
            catch(te:TypeError) {
                processTypeError(te.message, config);
            }
        }
        
        private function processTypeError(message:String, config:Function):void {
            var result:* = message.match(/\: (\w+) is not a function/i);
            addHookForNamedRoute(result[1], config);
        }
        
        private function addHookForNamedRoute(name:String, config:Function):void {
            if(this[name] != undefined) {
                throw new RoutingError('Attempted to create a named route where a property already exists [' + name + ']');
            }
            this[name] = function(options:Object):void {
                addNamedRoute(name, options);
            }
            // Loop back and run configuration again:
            executeConfiguration(config);
        }
    }
}
