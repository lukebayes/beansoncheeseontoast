package {
    
    public function coerceToType(value:*):* {
        if(value is Class) {
            return value;
        }
        if(!isNaN(Number(value))) {
            return Number(value);
        }
        if(value == 'true') {
            return true;
        }
        if(value == 'false') {
            return false;
        }
        return value;
    }
}
