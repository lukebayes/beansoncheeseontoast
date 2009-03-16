package  {
    
    public function underscore(camelCased:String):String {
        return camelCased.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase();
    }
}
