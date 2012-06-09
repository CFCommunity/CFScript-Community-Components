component extends="mxunit.framework.TestCase" {

	function testLoginLogout() {
		assertFalse(isUserLoggedIn());
		assertFalse(isUserInAnyRole("role,otherRole"));
		assertFalse(isUserInRole("role"));

		createObject("component", "CFScript-Community-Components.loginuser").init("everybody","secretpassword","role");

		assertTrue(isUserLoggedIn());
		assertTrue(isUserInAnyRole("role,otherRole"));
		assertTrue(isUserInRole("role"));
		assertFalse(isUserInRole("otherRole"));

		createObject("component", "CFScript-Community-Components.logout").init();

		assertFalse(isUserLoggedIn());
		assertFalse(isUserInAnyRole("role,otherRole"));
		assertFalse(isUserInRole("role"));
	}

}