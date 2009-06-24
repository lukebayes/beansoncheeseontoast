package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import actionpack.AbstractEnvironmentTest;
	import actionpack.ActionControllerTest;
	import actionpack.ActionRouterTest;
	import actionpack.BootTest;
	import actionpack.test.ActionPackTestCaseTest;
	import CamelCaseTest;
	import CapitalizeTest;
	import CoerceToTypeTest;
	import FindFirstTest;
	import reflect.ReflectionTest;
	import UnderscoreTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new actionpack.AbstractEnvironmentTest());
			addTest(new actionpack.ActionControllerTest());
			addTest(new actionpack.ActionRouterTest());
			addTest(new actionpack.BootTest());
			addTest(new actionpack.test.ActionPackTestCaseTest());
			addTest(new CamelCaseTest());
			addTest(new CapitalizeTest());
			addTest(new CoerceToTypeTest());
			addTest(new FindFirstTest());
			addTest(new reflect.ReflectionTest());
			addTest(new UnderscoreTest());
		}
	}
}
