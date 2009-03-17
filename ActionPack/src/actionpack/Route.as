package actionpack {

    public class Route {
        public var name:String;
        public var controller:Class;
        public var action:String;
        
        public function Route(name:String, controller:Class, action:String) {
            this.name = name;
            this.controller = controller;
            this.action = action;
        }
    }
}
