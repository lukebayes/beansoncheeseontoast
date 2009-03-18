package {
    public function camelcase(str:String):String {
        return capitalize( str.replace(/_([\w])/gi, function(...args):String {
            return args[1].toUpperCase();
        }) );
    }
}
