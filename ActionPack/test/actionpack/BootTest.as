package actionpack {
    
    import asunit.framework.TestCase;
    import environments.Development;
    import environments.Production;
    import environments.Test;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    public class BootTest extends TestCase {
        
        public function BootTest(method:String=null) {
            super(method);
        }
        
        public function testProductionEnvironment():void {
            assertEnvironmentAcceptedConfiguration(AbstractEnvironment.PRODUCTION, Production);
        }
        
        public function testDevelopmentEnvironment():void {
            assertEnvironmentAcceptedConfiguration(AbstractEnvironment.DEVELOPMENT, Development);
        }
        
        public function testTestEnvironment():void {
            assertEnvironmentAcceptedConfiguration(AbstractEnvironment.TEST, Test);
        }
        
        private function assertEnvironmentAcceptedConfiguration(env:String, clazz:Class):void {
            var environment:IEnvironment = Boot.strap(env);
            assertSame(getClassByInstance(environment), clazz);
        }
        
        private function getClassByInstance(instance:Object):Class {
            return getDefinitionByName(getQualifiedClassName(instance)) as Class;
        }
    }
}
