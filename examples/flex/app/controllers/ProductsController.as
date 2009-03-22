package {
    import actionpack.ActionController;
    import mx.collections.ArrayCollection;
    
    [Bindable]
    public class ProductsController extends ActionController {

        public var products:ArrayCollection;
        public var product:Product;

        public function index():void {
            products = new ArrayCollection();

            var product:Product = new Product();
            product.name = 'Coffee Mug';
            product.description = 'Holds coffee and keeps it hot';
            product.price = 14.99;
            products.addItem(product);

            product = new Product();
            product.name = 'Chew Toy';
            product.description = 'Your dogs favorite chew toy';
            product.price = 4.99;
            products.addItem(product);
        }
        
        public function show():void {
            product = Product.find(params.id);
        }
    }
}