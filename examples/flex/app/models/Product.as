package {
    
    import flash.events.EventDispatcher;
    import flash.utils.setTimeout;
    import mx.collections.ArrayCollection;
    
    /**
    *   This class is currently being stubbed in order to more easily
    *   demonstrate Controller / View / Routing features.
    *   
    *   One should imagine a variety of methods here that make
    *   requests against a server and asynchronously update responses.
    **/
    [Bindable]
    public class Product extends EventDispatcher {
        public var id:int;
        public var name:String;
        public var description:String;
        public var price:Number;
        
        public static function find(options:*):* {
            if(options == 'all') {
                return getAllProductsFromServer();
            }
            if(options is Number) {
                return getSingleProductFromServer(options);
            }
        }
        
        // This should give us a delayed response for index action:
        private static function getAllProductsFromServer():* {
            var products:ArrayCollection = new ArrayCollection();
            setTimeout(function():void {
                var response:Array = getProducts();
                for(var i:int; i < response.length; i++) {
                    products.addItem(response[i]);
                }
            }, 500);
            return products;
        }

        // This should give us a delayed response for show action:
        private static function getSingleProductFromServer(productId:Number):* {
            var product:Product = new Product();
            setTimeout(function():void {
                var response:Array = getProducts();
                var remoteProduct:Product;
                for(var i:int; i < response.length; i++) {
                    remoteProduct = response[i];
                    if(remoteProduct.id == productId) {
                        product.id = remoteProduct.id;
                        product.name = remoteProduct.name;
                        product.description = remoteProduct.description;
                        product.price = remoteProduct.price;
                        break;
                    }
                }
            }, 500);
            return product;
        }
        
        // Essentially our database:
        private static function getProducts():Array {
            var products:Array = new Array();
            var product:Product = new Product();
            product.id = 1;
            product.name = 'Coffee Mug';
            product.description = 'Holds coffee and keeps it hot';
            product.price = 14.99;
            products.push(product);

            product = new Product();
            product.id = 2;
            product.name = 'Chew Toy';
            product.description = 'Your dogs favorite chew toy';
            product.price = 4.99;
            products.push(product);
            return products;
        }
    }
}
