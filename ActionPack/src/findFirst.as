package {
    
    public function findFirst(collection:Array, handler:Function):* {
        trace(">> findFirst with: " + collection.length);
        var result:*;
        collection.every(function(item:Object, index:int, items:Array):Boolean {
            if(handler(item, index, items)) {
                result = item;
                return false;
            }
            return true;
        });
        return result;
    }
}
