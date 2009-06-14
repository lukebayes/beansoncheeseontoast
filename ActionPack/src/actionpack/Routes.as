package actionpack {

    import actionpack.errors.RoutingError;
    import flash.utils.getQualifiedClassName;
    
    dynamic public class Routes {
        private var _routes:Array;
        
        public function Routes() {
            _routes = new Array();
        }

        public function configure(config:Function):void {
            try {
                config.call(this);
            }
            catch(te:TypeError) {
                convertTypeErrorToNamedRoute(te.message, config);
            }
        }
        
        // The Route class should only be instantiated through this factory,
        // where we can associate the correct environment with created
        // controller instances.
        private function createRoute(path:String, options:*=null):Route {
            return new Route(path, options);
        }
        
        public function connect(path:String, options:Object=null):void {
            addRoute(path, options);
        }
        
        public function root(options:Object):void {
            _routes.push(createRoute('/', options));
        }
        
        public function pathFor(options:*):String {
            var len:int = _routes.length;
            var route:Route;
            var path:String;
            for(var i:int; i < len; i++) {
                path = _routes[i].pathFor(options);
                if(path != null) {
                    return path;
                }
            }
            return null;
        }
        
        /**
        *   routeFor accepts either a String or Hash/Object argument.
        *   
        *   Examples:
        *   routeFor('/users/index');
        *   routeFor('/users/show/3');
        *   routeFor({ 'controllers' : UsersController, 'action' : 'index' });
        *   routeFor({ 'controllers' : UsersController, 'action' : 'show', 'id' : 3 });
        **/
        public function routeFor(pathOrHash:*):Route {
            if(!(pathOrHash is String)) {
                pathOrHash = buildPathFromHash(pathOrHash);
            }
            var len:int = _routes.length;
            var route:Route;
            for(var i:int; i < len; i++) {
                route = _routes[i].routeFor(pathOrHash)
                if(route != null) {
                    if(route !== _routes[i]) {
                        _routes.splice(i, 0, route);
                    }
                    return route;
                }
            }
            return null;
        }
        
        public function toString():String {
            var lines:Array = [];
            _routes.forEach(function(route:Route, index:int, items:Array):void {
                lines.push(route.toString());
            });
            return lines.join('\n');
        }

        private function convertTypeErrorToNamedRoute(message:String, config:Function):void {
            var result:* = message.match(/\: (\w+) is not a function/i);
            addNamedRoute(result[1]);
            // Loop back and run configuration again:
            configure(config);
        }
        
        private function addNamedRoute(name:String):void {
            if(this[name] != undefined) {
                throw new RoutingError('Attempted to create a named route where a property already exists [' + name + ']');
            }
            this[name] = function(options:Object):void {
                if(options.action == null) {
                    options.action = ':action';
                }
                addRoute('/' + name, options);
            }
        }

        private function duplicateHash(hash:*):* {
            var dupe:Object = {};
            for(var key:String in hash) {
                dupe[key] = hash[key];
            }
            return dupe;
        }
        
        private function buildPathFromHash(hash:*):String {
            hash = duplicateHash(hash);
            var parts:Array = [''];
            parts.push(controllerClassToPath(hash.controller));
            delete hash.controller;
            if(hash.action) {
                parts.push(hash.action);
                delete hash.action;
            }
            for(var key:String in hash) {
                parts.push(hash[key]);
            }
            return parts.join('/');
        }
        
        protected function addRoute(path:String, options:Object=null):void {
            _routes.push(createRoute(path, options));
        }
        
        private function findRouteByOptions(options:*):Route {
            return null;
        }
        
        private function controllerClassToPath(controller:Class):String {
            var name:String = getQualifiedClassName(controller).split('::').pop();
            return underscore(name).replace(/_controller$/, '');
        }
        
        private function findRouteByController(options:*):Route {
            return findFirst(_routes, function(route:Route, index:int, items:Array):Boolean {
                return (route.controller === options.controller);
            }).name || options.controller.controllerPath;
        }

    }
}
