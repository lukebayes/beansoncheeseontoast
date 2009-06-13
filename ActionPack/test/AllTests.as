package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import actionpack.ActionControllerTest;
	import actionpack.ActionPackTestCaseTest;
	import actionpack.EnvironmentTest;
	import actionpack.RoutesTest;
	import CamelCaseTest;
	import CapitalizeTest;
	import CoerceToTypeTest;
	import FindFirstTest;
	import UnderscoreTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new actionpack.ActionControllerTest());
			addTest(new actionpack.ActionPackTestCaseTest());
			addTest(new actionpack.EnvironmentTest());
			addTest(new actionpack.RoutesTest());
			addTest(new CamelCaseTest());
			addTest(new CapitalizeTest());
			addTest(new CoerceToTypeTest());
			addTest(new FindFirstTest());
			addTest(new UnderscoreTest());
		}
	}
}
