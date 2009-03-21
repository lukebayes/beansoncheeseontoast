package {
    import actionpack.ActionController;
    
    public class ProductsController extends ActionController {
        
        public function index():void {
            trace(">> PRODUCTS index");
        }
    }
}