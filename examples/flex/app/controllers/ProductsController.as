package {
    import actionpack.ActionController;
    import mx.collections.ArrayCollection;

    /**
    *   Any publicly readable member variables or accessors will be copied
    *   by reference (when possible) into the currently rendered view
    *   if that view also has a publicly writable variable of the same name.
    *   
    *   In the case of this application, the products/Index.mxml view has
    *   a Bindable products member variable whose value will match that of 
    *   this controller instance.
    *   
    *   The products/Show.mxml view has a Bindable product member variable that
    *   will be configured based on whatever value is set here.
    **/
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