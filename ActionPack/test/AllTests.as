package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import actionpack.ActionControllerTest;
	import UnderscoreTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new actionpack.ActionControllerTest());
			addTest(new UnderscoreTest());
		}
	}
}
