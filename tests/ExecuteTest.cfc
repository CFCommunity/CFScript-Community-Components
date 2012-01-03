component extends="mxunit.framework.TestCase" {

	variables.NixOSList = "Mac OS X";

	public function testDate(){
		var commandline = createObject("component", "CFScript-Community-Components.execute").init();
		
		if (ListFind(server.OS.name, variables.NixOSList) > 0){
			commandline.setName("date");
			commandline.setArguments("+%Y-%m-%d-%H-%M-%S");
			commandline.setTimeout(5);
			var actual = commandline.execute().getResult().result;
			var now = now();
			var expected = DateFormat(now, "yyyy-mm-dd-") & TimeFormat(now, "HH-mm-ss");
			AssertEquals(expected, actual);
		}
		else{
			fail("The platform [#server.os.name#] is not in the executeTest server list, or there are no tests written for it yet.");	
		}	
		
	}	

}