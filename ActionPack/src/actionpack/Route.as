package actionpack {

    public class Route {
        public var pathExpression:String;
        public var controllerInstance:ActionController;
        public var controllerClass:Class;
        public var action:String;
        
        public function Route(pathExpression:String, controller:ActionController, action:String=null) {
            this.pathExpression = pathExpression;
            this.controllerInstance = controller;
            this.action = action || controller.defaultActionName;
        }
        
        public function get controller():ActionController {
            return controllerInstance;
        }
        
        public function get path():String {
            return '/' + controllerInstance.controllerName + '/' + action;
        }
        
        public function acceptsPath(path:String):Boolean {
            return false;
        }
    }
}
