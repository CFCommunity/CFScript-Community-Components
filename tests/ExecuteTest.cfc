component extends="mxunit.framework.TestCase" {

	variables.NixOSList = "Mac OS X";
	variables.noTestError = "The platform [#server.os.name#] is not in the executeTest server list, or there are no tests written for it yet.";

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
			fail(variables.noTestError);	
		}	
		
	}
	
	public function testExecuteError(){
		var commandline = createObject("component", "CFScript-Community-Components.execute").init();
		
		if (ListFind(server.OS.name, variables.NixOSList) > 0){
			commandline.setName("ls");
			commandline.setArguments("/null");
			commandline.setTimeout(5);
			var result = commandLine.execute();
			AssertTrue(Len(result.getResult().result) == 0);
			AssertTrue(Len(result.getResult().error) > 0);
			
			var actual = commandline.execute().getResult().error;
			var expected = "ls: /null: No such file or directory";
			AssertEquals(expected, actual);
			
			
		}
		else{
			fail(variables.noTestError);
		}		
		
	}		

}