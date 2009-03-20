package actionpack {
    
    import actionpack.errors.RoutingError;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    dynamic public class Route {
        private static const DEFAULT_ACTION:String = 'index';
        
        public var action:String;
        public var controller:Class;
        public var path:String;
        
        private var pathParts:Array;
        private var options:*;
        
        public function Route(path:String, options:*=null) {
            this.options = options;
            pathParts = path.split('/');
            if(path != '/' && pathParts.length == 2) {
                path += '/:action';
                pathParts.push(':action');
            }
            this.path = path;

            if(options != null) {
                controller = options.controller;
                action = options.action;
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
                            if(this.controller !== options[key]) {
                                return null;
                            }
                            result.push(controllerClassToPath(options[key]));
                        }
                        else if(key == 'action') {
                            result.push(options[key] || DEFAULT_ACTION);
                        }
                        else {
                            result.push(options[key]);
                        }
                    }
                    else {
                        result.push(part);
                    }
                }
                return result.join('/');
            }
            
            var controllerName:String = controllerClassToPath(options.controller);
            var actionName:String = options.action || DEFAULT_ACTION;
            var resultPath:String = ('/' + controllerName + '/' + actionName)
            return (resultPath == path) ? resultPath : null;
        }
        
        private function controllerClassToPath(controller:Class):String {
            var name:String = getQualifiedClassName(controller).split('::').pop();
            return underscore(name).replace(/_controller$/, '');
        }
        
        private function get staticPathPartsLength():int {
            var count:int;
            pathParts.forEach(function(item:String, index:int, items:Array):void {
                if(!item.match(/^:/)) {
                    count++;
                }
            });
            return count;
        }
        
        public function routeFor(path:String):Route {
            return routeForPath(path);
        }
        
        /**
        *   If our path includes expressions, create a new, empty
        *   Route, populate it with the request values and return it
        *   appropriately configured
        **/
        private function routeForPath(otherPath:String):Route {
            if(otherPath == path) {
                return this;
            }
            
            var otherParts:Array = otherPath.split('/');
            if(otherParts.length > pathParts.length) {
                return null;
            }
            
            var result:Route = (path.indexOf(':') == -1) ? this : new Route(otherPath, options);
            
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
            if(key == ':action' && value == null) {
                value = DEFAULT_ACTION;
            }
            key = key.replace(/^:/, '');
            route[key] = coerceToType(value);
        }
    }
}
