package reflect {
    import asunit.framework.TestCase;
    import flash.display.Sprite;
    import flash.geom.Rectangle;

    public class ReflectionTest extends TestCase {
        private var sprite:Sprite;
        private var reflection:Reflection;
        private var classReflection:Reflection;
        private var fakeRecord:FakeRecord;

        public function ReflectionTest(testMethod:String = null) {
            super(testMethod);
        }

        protected override function setUp():void {
            sprite = new Sprite();
            reflection = Reflection.create(sprite);
            classReflection = Reflection.create(Sprite);
            fakeRecord = new FakeRecord();
        }

        protected override function tearDown():void {
            fakeRecord = null;
            reflection = null;
            classReflection = null;
            Reflection.clearCache();
        }

        public function testInstantiated():void {
            assertTrue("Reflection instantiated", reflection is Reflection);
        }

        public function testBlockedConstructor():void {
            try {
                var broken:Reflection = new Reflection(fakeRecord, null);
                assertTrue("Reflection constructor should throw if anyone attempts to instantiate it directly", false);
            }
            catch(e:Error) {
                assertTrue(true);
            }
        }
        
        public function testCache():void {
            var reflect1:Reflection = Reflection.create(Object);
            var reflect2:Reflection = Reflection.create(Object);
            Reflection.clearCache();
            var reflect3:Reflection = Reflection.create(Object);
            assertTrue(reflect1 === reflect2);
            assertFalse(reflect1 === reflect3);
        }
        
        public function testGetDescription():void {
            var desc:XML = reflection.description;
            assertTrue(desc is XML);
        }
        
        public function testGetMethods():void {
            var methods:Array = reflection.methods;
            assertTrue(methods.length > 0);
        }
        
        public function testGetMethod():void {
            var method:ReflectionMethod = reflection.getMethodByName('startDrag');
            var parameters:Array = method.parameters;
            var parameter:ReflectionMethodParameter = parameters[1];
            assertNotNull("1", method);
            assertNotNull("2", parameters);
            assertTrue("3", parameters.length > 0);
            assertEquals("4", 2, parameter.index);
            assertEquals("5", "flash.geom::Rectangle", parameter.type);
            assertTrue("6", parameter.optional);
        }
        
        public function testMethodNames():void {
            var names:Array = reflection.methodNames;
            var found:Boolean = !names.every(function(item:String, index:int, items:Array):Boolean {
                return (item != 'stopDrag');
            });
            assertTrue(found);
        }
        
        public function testHasMethodName():void {
            assertTrue(reflection.hasMethod("swapChildren"));
            assertFalse(reflection.hasMethod("foobar"));
        }
        
        public function testGetMethodByName():void {
            var method:ReflectionMethod = reflection.getMethodByName("swapChildren");
            assertEquals("swapChildren", method.name);
            assertEquals(2, method.parameters.length);
            assertEquals("flash.display::DisplayObjectContainer", method.declaredBy);
            assertEquals("void", method.returnType);
        }
        
        public function testGetMethodByNameFailure():void {
            var method:ReflectionMethod = reflection.getMethodByName("foobar");
            assertNull(method);
        }
        
        public function testDescription():void {
            var desc:XML = reflection.description;
            assertNotNull(desc);
//            trace("desc: " + desc);
        }
        
        public function testAccessors():void {
            var accessor:ReflectionAccessor = reflection.getAccessorByName('buttonMode');
            assertEquals("buttonMode", accessor.name);
            assertEquals("readwrite", accessor.access);
            assertEquals("Boolean", accessor.type);
            assertEquals("flash.display::Sprite", accessor.declaredBy);
        }
        
        public function testNonOptionalParameter():void {
            var method:ReflectionMethod = reflection.getMethodByName("addEventListener");
            var parameters:Array = method.parameters;
            assertFalse(parameters[0].optional);
        }
        
        public function testGetName():void {
            assertEquals("flash.display::Sprite", reflection.name);
        }
        
        public function testGetBase():void {
            assertEquals("flash.display::DisplayObjectContainer", reflection.base);
        }
        
        public function testGetIsDynamic():void {
            assertFalse(reflection.isDynamic);
        }
        
        public function testGetIsFinal():void {
            assertFalse(reflection.isFinal);
        }
        
        public function testGetIsStatic():void {
            assertFalse(reflection.isStatic);
        }
        
        public function testInterfaceNames():void {
            var interfaceNames:Array = reflection.interfaceNames;
            assertEquals("flash.display::IBitmapDrawable", interfaceNames[0]);
            assertEquals("flash.events::IEventDispatcher", interfaceNames[1]);
        }
        
        public function testInheritedNames():void {
            var extendedClasses:Array = reflection.extendedClasses;
            assertEquals("flash.display::DisplayObjectContainer", extendedClasses[0]);
            assertEquals("flash.display::InteractiveObject", extendedClasses[1]);
            assertEquals("flash.display::DisplayObject", extendedClasses[2]);
            assertEquals("flash.events::EventDispatcher", extendedClasses[3]);
            assertEquals("Object", extendedClasses[4]);
        }
        
        public function testIsClass():void {
            assertTrue(classReflection.isClass);
            assertFalse(reflection.isClass);
        }
        
        public function testSeparateCacheForClassesAndInstancesOfSameName():void {
            assertFalse(classReflection === reflection);
        }
        
        public function testConstructor():void {
            var rect:Rectangle = new Rectangle();
            var reflection:Reflection = Reflection.create(rect);
            var parameters:Array = reflection.constructor.parameters;
            assertTrue(reflection.hasConstructor);
            assertEquals(1, parameters[0].index);
            assertEquals("Number", parameters[0].type);
            assertEquals(true, parameters[0].optional);
        }
        
        public function testEmptyConstructor():void {
            var constructor:ReflectionMethod = reflection.constructor;
            assertFalse(reflection.hasConstructor);
        }
        
        public function testVariables():void {
            var rect:Rectangle = new Rectangle();
            var reflection:Reflection = Reflection.create(rect);
            var variables:Array = reflection.variables;
            assertEquals(4, variables.length);
            assertTrue(reflection.hasVariable('y', 'Number'));
            assertTrue(reflection.hasVariable('x', 'Number'));
            assertTrue(reflection.hasVariable('width', 'Number'));
            assertTrue(reflection.hasVariable('height', 'Number'));
        }
        
        public function testGetReadWriteMembers():void {
            var members:Array = reflection.readWriteMembers;
            assertEquals(32, members.length);
        }
    }
}

class FakeRecord {
    public var name:String;
    public var prop1:String;
    
    public function get label():String {
        return name;
    }
}
