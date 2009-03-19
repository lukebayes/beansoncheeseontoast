package actionpack {
    
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    dynamic public class Route {
        public var action:String;
        public var controller:Class;
        public var path:String;
        
        private var pathParts:Array;
        
        public function Route(path:String, options:*=null) {
            this.path = path;
            this.pathParts = path.split('/');

            if(options != null) {
                this.controller = options.controller;
                this.action = options.action;
            }
        }
        
        public function pathFor(options:*):String {
            if(path.indexOf(':') > -1) {
                var len:int = pathParts.length;
                var part:String;
                var route:Route;
                var key:String;
                var result:Array = [];
                for(var i:int; i < len; i++) {
                    part = pathParts[i];
                    if(part.indexOf(':') > -1) {
                        key = part.replace(/^:/, '');
                        if(key == 'controller') {
                            result.push(controllerClassToPath(options[key]));
                        }
                        else {
                            result.push(options[key].toString());
                        }
                    }
                }
                return '/' + result.join('/');
            }

            var controllerName:String = controllerClassToPath(options.controller);
            var actionName:String = options.action;
            var resultPath:String = ('/' + controllerName + '/' + actionName)
            return (resultPath == path) ? resultPath : null;
        }
        
        private function controllerClassToPath(controller:Class):String {
            var name:String = getQualifiedClassName(controller).split('::').pop();
            return underscore(name).replace(/_controller$/, '');
        }
        
        /**
        *   If our path includes expressions, create a new, empty
        *   Route, populate it with the request values and return it
        *   appropriately configured
        **/
        public function routeForPath(otherPath:String):Route {
            var otherParts:Array = otherPath.split('/');
            if(otherParts.length != pathParts.length) {
                return null;
            }
            
            var result:Route = (path.indexOf(':') == -1) ? this : new Route(otherPath);
            
            var len:int = pathParts.length;
            var part:String;
            for(var i:int = 0; i < len; i++) {
                part = pathParts[i];
                if(part.match(/^:/) && result !== this) {
                    updateRouteWithPathPart(result, part, otherParts[i]);
                }
                else if(part != otherParts[i]) {
                    return null;
                }
            }
            
            return result;
        }
        
        private function updateRouteWithPathPart(route:Route, key:String, value:*):void {
            if(key == ':controller') {
                value = getDefinitionByName(camelcase(value) + 'Controller');
            }
            key = key.replace(/^:/, '');
            route[key] = coerceToType(value);
        }
    }
}
