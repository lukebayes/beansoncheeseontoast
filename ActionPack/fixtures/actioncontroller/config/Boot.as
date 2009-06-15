package {
    
    import actionpack.AbstractEnvironment;
    import actionpack.IEnvironment;
    import environments.Development;
    import environments.Production;
    import environments.Test;

    public class Boot {
        
        public static function strap(env:String=null, config:Function=null):IEnvironment {
            switch(env || Environment.BEANS_ENV) {
                case AbstractEnvironment.TEST :
                    return new Test(config);
                case AbstractEnvironment.DEVELOPMENT :
                    return new Development(config);
                default :
                    return new Production(config);
            }
        }
    }
}
