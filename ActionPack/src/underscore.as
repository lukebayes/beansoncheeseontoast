package  {
    
    public function underscore(capitalized:String):String {
        return capitalized.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase();
    }
}
