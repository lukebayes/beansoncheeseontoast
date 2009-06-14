package {
    
    import actionpack.ActionController;
    
    public class SiteController extends ActionController {
        
        public function SiteController(config:Function=null) {
            super(config);
        }
        
        override protected function initialize():void {
            beforeFilter(index);
        }
        
        public function index():void {
        }
    }
}
