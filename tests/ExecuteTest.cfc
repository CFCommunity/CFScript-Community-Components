component extends="mxunit.framework.TestCase" {

	public function testPWD(){
		var commandline = createObject("component", "CFScript-Community-Components.execute");
		
		commandline.setName("pwd");
		commandline.setTimeout(5);
		var result = commandline.execute();
		debug(result);
			
		
	}	

}