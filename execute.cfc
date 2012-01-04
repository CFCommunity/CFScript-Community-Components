
/**
 * Execute Service : Executes a ColdFusion developer-specified process on a server computer.
 * @name execute
 * @displayname ColdFusion Execute(Command Line) Service 
 * @output false
 * @accessors true
 */
component extends="base"
{
    property string name;
    property string arguments;
    property string outputFile;
    property numeric timeout;

	//service tag to invoke
    variables.tagName = "CFEXECUTE";
	
    //valid ldap tag attributes
    variables.tagAttributes = getSupportedTagAttributes(getTagName());
	


	/**
	 * Initialization routine. Returns an instance of this component
	 * @output false
	 */
    public execute function init()
    {
		if(!structisempty(arguments))
		{
        	structappend(variables,arguments,"yes");
    	}
		
		/* 
		Special case for cfdump: 
		If attributes is not set in the contructor, we set it to an empty string.
		If this is not done, value for attributes in dump will be a struct containing all properties set in cfc variables scope.
		*/
		/*
		if(!structkeyexists(variables,"attributes")){
			this.setAttributes("");
		}
		*/
		
        return this;
    }
	


	/**
	 * Used to set "attributes" property. 
	 * Note that implicit setter setAttributes() is not used since a method with the same name is defined in base.cfc 
	 * @output false
	 */
	public void function setLdapAttributes(String attributes)
	{
		variables.attributes = attributes;
	}



	/**
	 * Returns the "attributes" property, if defined, or an empty string    
	 * Note that implicit getter getAttributes() is not used since a method with the same name is defined in base.cfc 
	 * @output false
	 */
	public function getLdapAttributes()
	{
		return structkeyexists(variables,"attributes") ? variables.attributes : "";
	}



	/**
	 * Removes tag attributes from variables scope. Accepts a list of tag attributes 
	 * If no attributes are specified, all attributes are removed from CFC variables scope
	 * @output false
	 */
	public void function clearAttributes(string tagAttributesToClear="")
	{
		//delegate call to clearAttributes in base.cfc
		super.clearAttributes(tagAttributesToClear);
		
		//required since we explicitly set attributes to "" (see init method)
		if(!structkeyexists(variables,"attributes"))
			this.setAttributes("");
	}

	

	/**
	 * Removes tag attributes
	 * @output false
	 */
	public void function clear()
	{
		//delegate call to clearAttributes
		 clearAttributes();
	}	
	
	/* ************************ BEGIN :: EXECUTE SERVICES *************************************** */
	
		/**
     * Invoke the cfexecute tag to provide the command line access in cfscript
     * @output true 
     */
    public result function execute()
	{
        //store tag attributes to be passed to the service tag in a local variable
		var tagAttributes = duplicate(getTagAttributes());

		//attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if(!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments,"yes");
        }
    
        //if a result attribute is specified, we ignore it so that we can always return the result struct 
		if(structkeyexists(tagAttributes,"result"))
        {
             structdelete(tagAttributes, "result");
        }

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

	
	
	/* ************************ END :: EXECUTE SERVICES *************************************** */




}