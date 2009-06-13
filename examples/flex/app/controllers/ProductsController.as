package {
    import actionpack.ActionController;
    import mx.collections.ArrayCollection;
    
    [Bindable]
    public class ProductsController extends ActionController {

        public var products:ArrayCollection;
        public var product:Product;

        public function index():void {
            products = Product.find('all');
        }
        
        public function show():void {
            product = Product.find(params.id);
        }
    }
}