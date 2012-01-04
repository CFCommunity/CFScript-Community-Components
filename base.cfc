<!--- 
***********************************************************************************************************
*
* ADOBE CONFIDENTIAL
* ___________________
*
*  Copyright 2008 Adobe Systems Incorporated
*  All Rights Reserved.
*
*  NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
*  terms of the Adobe license agreement accompanying it.  If you have received this file from a 
*  source other than Adobe, then your use, modification, or distribution of it requires the prior 
*  written permission of Adobe.
*************************************************************************************************************/
--->

<cfcomponent name="base" displayname="base" output="false" hint="component with generic methods used by all services">

    <cfscript>
		
		variables.tagAttributes = '';
		variables.parameters = [];

		/**
		 * Set the name of the service tag to be invoked
		 * @output false
		 */
		private void function setTagName(string tagName)
		{
			variables.tagName = tagName;
		}


		/**
		 * Get the name of the service tag
		 * @output false
		 */
		private string function getTagName()
		{
			return variables.tagName;
		}


		/**
		 * Set cfc properties. Wrapper for setAttributes()
		 * @output false
		 */
		public void function setProperties()
		{
			if(structkeyexists(arguments,"1") and isstruct(arguments["1"]))
				setAttributes(arguments["1"]);
			else
				setAttributes(arguments);
		}


		/**
		 * Set service tag attributes. 
		 * @output false
		 */
		public void function setAttributes()
		{
			if(!structisempty(arguments))
			{
				var temp = {};
				if(structkeyexists(arguments,"1") and isstruct(arguments["1"]))
				{
						//include only relevant properties
						for(var p in arguments["1"])
						{
							if(listcontainsnocase(variables.tagAttributes,p)){
								temp[p] = arguments["1"][p];
							}
						}
						structappend(variables,temp,"yes");
					}	
				else
					structappend(variables,arguments,"yes");
			}
		}


		/**
		 * Get cfc properties. Wrapper for getAttributes()
		 * @output false
		 */
		public struct function getProperties(string attribs="") 
		{
			return getAttributes(attribs);
		}


		/**
		 * Returns a struct with all/some of the service tag attribute values. If no attributes are specified, it returns a coldfusion with all service tag attribute values
		 * @output false
		 */
		public struct function getAttributes(string attribs="") 
		{
			var attributesstruct = {};
			var i = 0;
			arguments.attribs = trim(arguments.attribs) neq "" ? trim(arguments.attribs) : variables.tagAttributes;

			for(i=1; i lte listlen(attribs); i++)
			{
				var attrib = trim(listgetat(attribs,i));
				if(structkeyexists(variables,attrib))
				{	
					attributesstruct[attrib] = variables[attrib];
				}
			}
			return attributesstruct;
		}


		/**
		 * Clear cfc properties. Wrapper for clearAttributes()
		 * @output false
		 */
		public void function clearProperties(string attribs="") 
		{
			return clearAttributes(attribs);
		}


		/**
		 * Removes a specific service tag attribute from CFC variables scope. Invoked by clearAttributes() 
		 * @output false
		 */
		private void function clearAttribute(struct tagAttributesStruct,string tagAttribute)
		{
			if(structkeyexists(tagAttributesStruct,tagAttribute))
			{ 
				structdelete(tagAttributesStruct,tagAttribute);
			}
		}
	
	
		/**
		 * Removes all|some of the service tag attributes from CFC variables scope. Accepts a list of service tag attributes to remove. If no attributes are specified, all attributes are
		 * removed from CFC variables scope
		 * @output false
		 */
		public void function clearAttributes(string tagAttributesToClear="")
		{
			var attributeslist = isdefined("arguments.tagAttributesToClear") and trim(arguments.tagAttributesToClear) neq "" ? arguments.tagAttributesToClear : variables.tagAttributes;
			var i = 0;

			for(i=1;i lte listlen(attributeslist); i++)
			{
				var attrib = trim(listgetat(attributeslist,i));
				clearAttribute(variables,attrib);
			}
		}
	

		/**
		 * Removes service tag attributes
		 * @output false
		 */
		public void function clear()
		{
			 clearAttributes();
			 clearParams();
		}

	
		/**
		 * Resets child tags by resetting the parameters array
		 * @output false
		 */    
		public void function clearParams()
		{
			if(isdefined("variables.parameters"))
			{
			 	variables.parameters = [];
			}
		}

	
		/**
		 * Returns a struct with attributes set either using implicit setters | init() | setAttributes()
		 * @output false
		 */
		private struct function getTagAttributes()
		{
			var tagAttributes = structnew();
			var i = 0;
			
			for(i=1; i lte listlen(variables.tagAttributes); i++)
			{
				var attrib = trim(listgetat(variables.tagAttributes,i));
				if(structkeyexists(variables,attrib))
				{
					tagAttributes[attrib] = variables[attrib];
				}
			}
			return tagAttributes;
		}
		
		/**
		 * Trim tag attributes
		 * @output false
		 */
		private struct function trimAttributes(struct attribs={})
		{
			var tagAttributes = {};
			if(!structisempty(attribs))
			{
				for(var attrib in attribs)
				{
					tagAttributes[attrib] = isSimpleValue(attribs[attrib]) ? trim(attribs[attrib]) : attribs[attrib];
				}
			}
			return tagAttributes;
		}		


		/** 
		 * Accepts a service tag name and returns the allowed tag attributes. Uses double-checked locking
		 * @output false
		 */
		private string function getSupportedTagAttributes(string tagName)
		{
			//store all service tag attributes in Server scope for faster access. 
			if(not isdefined("server.coldfusion.serviceTagAttributes.#tagName#"))
			{	
				lock scope="server" timeout="30" throwontimeout="yes" type="exclusive"
				{
					if(not isdefined("server.coldfusion.serviceTagAttributes.#tagName#"))
					{	
						var webinf = getPageContext().getServletContext().getRealPath("/WEB-INF");
						var sep = server.os.name contains "windows"? "\" : "/";
						var cftldpath = webinf & sep & "cftags" & sep & "META-INF" & sep & "taglib.cftld";
						var xpath = "/taglib/tag[name='#lcase(Right(tagName,len(tagName)-2))#']/attribute/name";
						var cftagsXml = XmlParse(FileRead(cftldpath));
						var tagAttributes = xmlsearch(cftagsXml,xpath);
						var attributeslist = "";
						var i = 0;
						for(i=1;i lte arraylen(tagAttributes); i++)
						{
							attributeslist = listappend(attributeslist,trim(tagAttributes[i].xmltext));
						}
						server.coldfusion.serviceTagAttributes[tagName] = listsort(attributeslist,"textnocase","ASC");
					}
				}
			}

			//use a local variable for faster access
			lock scope="server" timeout="30" throwontimeout="yes" type="readonly"
			{
				var attributeslist = server.coldfusion.serviceTagAttributes[tagName];
			}
			
			return attributeslist;
		}


		/**
		 * Add child tags like cfmailparam, cfmailpart etc
		 * @output false
		 */
		public void function addParam()
		{
			if(!structisempty(arguments))
			{
				if(isdefined("variables.parameters"))
				{
					arrayappend(variables.parameters, arguments);
				}
			}
		}


		/**
		 * Get array of parameters added using addParam()
		 * @output false
		 */
		public array function getParameters()
		{
			return variables.parameters;
		}


		/**
		 * Validate against any incorrect attributes passed to the child tags. This is done by passing allowExtraAttributes=false
		 * @output false
		 */
		private array function appendAllowExtraAttributes(array params)
		{
			var temp = [];
			var nbrOfParams = arraylen(arguments.params);
			var i = 0;

			for(i=1; i lte nbrOfParams; i++)
			{
				var param = arguments.params[i];
				if(isstruct(param))
				{
					structappend(param,{allowExtraAttributes=false});
					arrayappend(temp,param);
				}
			}
			return temp;
		}

	</cfscript>
    
    

    <!---
	The corresponding service tag to invoke. 

	Supported service tags are 
		cfhttp
		cfftp
		cfpdf
		cfmail
		cfquery
		cfstoredproc
	--->

    <cffunction name="invokeTag" access="private" output="true" returntype="any" hint="invokes the service tag">
        <cfargument name="tagName" type="string" hint="Name of the service tag to invoke">
        <cfargument name="tagAttributes" type="struct" hint="Attributes of the service tag that were set using either init() | implicit setters | setAttributes()">
        <cfargument name="tagParams" type="struct" required="no" default="#{}#" hint="Struct containing child params/tags">
        
		<cfset var params = structkeyexists(arguments.tagParams,"params") ? appendAllowExtraAttributes(arguments.tagParams["params"]) : []>
		<cfset var tagresult = new result()>
		<cfset arguments.tagAttributes = appendAllowExtraAttributes([arguments.tagAttributes])[1]>

        <cfswitch expression="#tagName#">

            <!--- http service  --->
            <cfcase value="CFHTTP">
                <cfset var httpparam = "">
                <cfhttp attributeCollection="#tagAttributes#">
                    <cfloop array="#params#" index="httpparam">
                        <cfhttpparam attributeCollection="#httpparam#">
                    </cfloop>
                </cfhttp>
	        	<!--- set query object and http prefix--->
				<cfif structkeyexists(tagAttributes,"name") and tagAttributes["name"] neq "">
                    <cfset tagresult.setResult(StructFind(variables,tagAttributes["name"]))>
				</cfif>   
				<cfset tagresult.setPrefix(cfhttp)>
                <cfreturn tagResult>
			</cfcase>
		
        	<!--- ftp service --->
            <cfcase value="CFFTP">
                <cfftp attributeCollection="#tagAttributes#">
	        	<!--- set query object (for listdir action) and cfftp prefix --->
				<cfif structkeyexists(tagAttributes,"name") and trim(tagAttributes["name"]) neq "">
                    <cfset tagResult.setResult(StructFind(variables,tagAttributes["name"]))>
				</cfif>
				<cfset tagResult.setPrefix(cfftp)>
                <cfreturn tagResult>
            </cfcase>
        
        	<!--- pdf service --->
            <cfcase value="CFPDF">
				<!--- If the "source" attribute contains any cfdocument or cfpdf variables, we need to pass a variable with that value instead of the value --->
                <cfset var sourceVar = "">
                <cfset var pdfparam = ""> 
                <cfset var nameAttributeRequiredList = "read,getinfo,processddx">
                <cfset var nameAttributeOptionalList = "extracttext">
                <cfset var nameAttributeNotRequiredList = "extractimage,thumbnail">

                <cfif structkeyexists(tagAttributes,"source") and not isSimpleValue(tagAttributes["source"])>
                     <cfset sourceVar = tagAttributes["source"]>
                     <cfset structappend(tagAttributes,{source="sourceVar"})>
                </cfif>
				
				<!--- 
				name attribute is optional in the script version but since the underlying tag would still require it, we insert one. 
				Exceptions:
				addwatermark, addheader, addfooter, deletepages, merge, optimize, protect, removeheaderfooter, removeWatermark, setinfo, transform, write
				(since these actions operate on the source pdf if name or destination attribute is not provided)
				--->
				<cfif not structkeyexists(tagAttributes,"name")>
					<cfif listcontainsnocase(nameAttributeRequiredList,tagAttributes["action"]) or listcontainsnocase(nameAttributeOptionalList,tagAttributes["action"])>
						<!--- destination and name are mutually exclusive --->
						<cfif not structkeyexists(tagAttributes,"destination")>
							<cfset tagAttributes["name"] = "_cf_pdf_#randrange(1,100000)#">
						</cfif>
					</cfif>
				</cfif>
				
				<cfpdf attributeCollection="#tagAttributes#">
                    <cfif comparenocase(tagAttributes["action"],"merge") eq 0>
                        <cfif arraylen(params) gt 0>
                            <cfloop array="#params#" index="pdfparam">
                                <cfpdfparam attributeCollection="#pdfparam#">
                            </cfloop>
                    	</cfif>
					</cfif>
                </cfpdf>  

				<!--- process name attribute for actions other than action="thumbnail | extractimage" --->
				<cfif not listcontainsnocase(nameAttributeNotRequiredList,tagAttributes["action"])>
                	<cfif structkeyexists(tagAttributes,"name") and tagAttributes["name"] neq "">
						<cfset tagResult.setResult(StructFind(variables,tagAttributes["name"]))>
                	</cfif>
				<cfelse>
                	<cfset tagResult.setResult("")>
				</cfif>
				
                <cfreturn tagResult>
            </cfcase>
			
            <!--- mail service --->
        	<cfcase value="CFMAIL">
            	<cfset var mailbody = "">
				<cfset var mailpartbody = "">
				<cfset var mailparam = "">
				<cfset var mailpart = "">
				<cfset var parts = structkeyexists(tagParams,"parts") ? appendAllowExtraAttributes(tagParams["parts"]) : []>
                <!--- if query attribute exists, pass a variable with query object instead of the query object --->
				<cfif structkeyexists(tagAttributes,"query") and isquery(tagAttributes["query"])>
                     <cfset var queryVar = tagAttributes['query']>
                     <cfset structappend(tagAttributes,{query="queryVar"},"yes")>
            	</cfif>
                <!--- Capture mail content into a local variable and delete body attribute --->
                <cfif structkeyexists(tagAttributes,"body")>
                     <cfset var mailbody = tagAttributes["body"]>
                     <cfset structdelete(tagAttributes,"body")>
                </cfif>
				<!--- invoke the cfmail/cfmailparams/cfmailpart tags --->
                <cfmail attributeCollection="#tagAttributes#">
                    #mailbody#
                    <cfloop array="#params#" index="mailparam">
                        <cfmailparam attributeCollection="#mailparam#">
                    </cfloop>
                    <cfloop array="#parts#" index="mailpart">
                        <!--- Capture mailpart content into a local variable and delete body attribute ---> 
                        <cfif structkeyexists(mailpart,"body")>
                             <cfset var mailpartbody = mailpart["body"]>
                             <cfset structdelete(mailpart,"body")>
                        </cfif>
                        <cfmailpart attributeCollection="#mailpart#">
                            #trim(mailpartbody)#
                        </cfmailpart>
                    </cfloop>
                </cfmail>
                <cfreturn tagResult>
			</cfcase>

			<!--- query service --->
            <cfcase value="CFQUERY">
				<cfset var sqlparams = structkeyexists(tagParams,"params") ? tagParams["params"] : []>
				<cfset var sqlArray = structkeyexists(tagParams,"sqlArray") ? tagParams["sqlArray"] : []>
				<cfset var sqlQuery = structkeyexists(tagParams,"sql") ? tagParams["sql"] : "">
				<cfset var sqlType = structkeyexists(tagParams,"sqlType") ? tagParams["sqlType"] : "">
				<cfset var i = 0>
                <cfquery attributeCollection="#tagAttributes#">
                    <!--- if no queryparams exist, use query directly --->
                    <cfif arraylen(sqlParams) eq 0>
                        #PreserveSingleQuotes(sqlQuery)#
                    <cfelse>    
                        #getPreserveSingleQuotes(sqlArray[1])#
                        <cfif sqlType neq "" and arraylen(sqlParams) gt 0>
                            <cfloop index="i" from="2" to="#ArrayLen(sqlArray)#">
                                <cfif (i-1) lte arraylen(sqlParams)>
                                    <cfqueryparam attributeCollection="#sqlParams[i-1]#"/>
                                 </cfif>   
                                #getPreserveSingleQuotes(sqlArray[i])#
                            </cfloop>          
                        </cfif>
                    </cfif>
                </cfquery>  
				<!--- set resultset and query meta info --->
                <cftry>
					<cfset tagResult.setResult(StructFind(variables,tagAttributes['name']))>
					<cfcatch type="any">
                    </cfcatch>
                </cftry>                    
                <cfset tagResult.setPrefix(StructFind(variables,tagAttributes['result']))>
				<cfreturn tagResult>
            </cfcase>


			<!--- storedproc service --->
            <cfcase value="CFSTOREDPROC">
				<cfset var procresults = structkeyexists(tagParams,"procresults") ? appendAllowExtraAttributes(tagParams["procresults"]) : []>
                <cfset var spResult = new storedprocResult()>
                <cfset var procparam = "">
                <cfset var procresult = "">
                <cfstoredproc attributeCollection="#tagAttributes#">
                    <cfloop array="#params#" index="procparam">
                        <cfprocparam attributeCollection="#procparam#"/>
                    </cfloop>          
                    <cfloop array="#procresults#" index="procresult">
                        <cfprocresult attributeCollection="#procresult#"/>
                    </cfloop>          
                </cfstoredproc>
                <!--- process proc vars --->
				<cfset var procvars = {}>
        		<cfloop array="#params#" index="procparam">
        			<cfif structkeyexists(procparam,"type") and listcontainsnocase("OUT,INOUT",procparam["type"])>
                		<cfif structkeyexists(procparam,"variable") and procparam["variable"] neq "">
                            <cfset procvars[procparam.variable] = StructFind(variables,procparam["variable"])>
                		</cfif>
                	</cfif>
            	</cfloop>
                <!--- process proc resultsets --->
                <cfset var procresultset = {}>
        		<cfloop array="#procresults#" index="procresult">
        			<cfset procresultset[procresult.name] = StructFind(variables,procresult["name"])>
            	</cfloop>
                <!--- set inout and out variables, proc resultsets and the cfstoredproc prefix --->
				<cfset spResult.setProcOutVariables(procvars)>
				<cfset spResult.setProcResultSets(procresultset)>
                <cfif structkeyexists(tagAttributes,"result") and tagAttributes["result"] neq "">
			 		<cfset spResult.setPrefix(StructFind(variables,tagAttributes["result"]))>
 				<cfelse>
			 		<cfset spResult.setPrefix(cfstoredproc)>
				</cfif>
                <cfreturn spResult>
            </cfcase>

        	<!--- cffeed service --->
            <cfcase value="CFFEED">
                <cfset var feedResult = {}>
                <!--- invoke the cffeed tag to perform the cffeed services read and create --->
                <cffeed attributeCollection="#tagAttributes#">
	        	<cfif tagAttributes["action"] eq "read">
		        	<!--- update feedResult with items and metadata --->
					<cfif structkeyexists(tagAttributes,"name") and trim(tagAttributes["name"]) neq "">
	                    <cfset structappend(feedResult,{name=StructFind(variables,tagAttributes["name"])})> 
					</cfif>
					<!--- update feedResult with metadata  ---> 	
					<cfif structkeyexists(tagAttributes,"properties") and trim(tagAttributes["properties"]) neq "">
	                    <cfset structappend(feedResult,{properties=StructFind(variables,tagAttributes["properties"])})> 
					</cfif>
					<!--- update feedResult with items ---> 	
					<cfif structkeyexists(tagAttributes,"query") and trim(tagAttributes["query"]) neq "">
	                    <cfset structappend(feedResult,{query=StructFind(variables,tagAttributes["query"])})> 
					</cfif>
				</cfif>
				<!--- update feedResult with xmlvar. Applicable for read and create ---> 	
				<cfif structkeyexists(tagAttributes,"xmlvar") and trim(tagAttributes["xmlvar"]) neq "">
                    <cfset structappend(feedResult,{xmlvar=StructFind(variables,tagAttributes["xmlvar"])})> 
				</cfif>
				<!--- set result property to feedResult --->
				<cfset tagResult.setResult(feedResult)>
                <cfreturn tagResult>
            </cfcase>
            
            <!--- cfexecute service --->
			<cfcase value="CFEXECUTE">
				<cfset var stdout = "" />
				<cfset var stderr = "" />
				<cfset tagAttributes.variable = "stdout" />
				<cfset tagAttributes.errorVariable = "stderr" />  
				
				<cfset var resultSet = {} />
			
                <cfexecute attributeCollection="#tagAttributes#" />
				<cfset resultSet.result = Trim(stdout) />
				<cfset resultSet.error = Trim(stderr) />
				
				
				<cfset tagResult.setResult(resultSet) />
				
				<cfreturn tagResult>
			</cfcase>
			
        	<!--- cfldap service --->
			<cfcase value="CFLDAP">
                <cfldap attributeCollection="#tagAttributes#" />
				<cfif tagAttributes["action"] eq "query">
					<!--- set query object --->
					<cfif structkeyexists(tagAttributes,"name") and tagAttributes["name"] neq "">
						<cfset tagResult.setResult(StructFind(variables,tagAttributes["name"]))>
                	</cfif>  
				</cfif>
				<cfreturn tagResult>
			</cfcase>		

        	<!--- cfdbinfo service --->
            <cfcase value="CFDBINFO">
                <cfdbinfo attributeCollection="#tagAttributes#" />
	        	<!--- set query object --->
				<cfif structkeyexists(tagAttributes,"name") and tagAttributes["name"] neq "">
                    <cfset tagresult.setResult(StructFind(variables,tagAttributes["name"]))>
				</cfif>  
                <cfreturn tagResult>
			</cfcase>

            <!--- cfpop service --->
			<cfcase value="CFPOP">
                <cfpop attributeCollection="#tagAttributes#" />
	        	<!--- set query object --->
				<cfif structkeyexists(tagAttributes,"name") and tagAttributes["name"] neq "">
                    <cfset tagresult.setResult(StructFind(variables,tagAttributes["name"]))>
				</cfif>  
                <cfreturn tagResult>
			</cfcase>

            <!--- cfimap service --->
 			<cfcase value="CFIMAP">
                <cfimap attributeCollection="#tagAttributes#" />
	        	<!--- set query object --->
				<cfif structkeyexists(tagAttributes,"name") and tagAttributes["name"] neq "">
                    <cfset tagresult.setResult(StructFind(variables,tagAttributes["name"]))>
				</cfif>  
                <cfreturn tagResult>
			</cfcase>		

        	<!--- cfsearch service --->
            <cfcase value="CFSEARCH">
                <cfset var searchResult = {}>
				<cfset var localname = "cfsearch_" & replace(createUUID(), "-","_","all")>
				<cfif structKeyExists(tagAttributes, "status") and trim(tagAttributes["status"]) neq "">
					<cfset var statusname = "cfsearchstatus_" & replace(createUUID(), "-","_","all")>
					<cfset tagAttributes.status = "local.#statusname#">
				</cfif>
                <cfsearch attributeCollection="#tagAttributes#" name="local.#localname#">
				<cfset searchResult.name = local[localname]>
				<cfif structKeyExists(tagAttributes, "status") and trim(tagAttributes["status"]) neq "">
					<cfset searchResult.status = local[statusname]>
				</cfif>

				<cfset tagResult.setResult(searchResult)>
                <cfreturn tagResult>
            </cfcase>

        	<!--- cfindex service --->
            <cfcase value="CFINDEX">
                <cfset var indexResult = {}>
				<cfif structKeyExists(tagAttributes, "status") and trim(tagAttributes["status"]) neq "">
					<cfset var statusname = "cfsearchstatus_" & replace(createUUID(), "-","_","all")>
					<cfset tagAttributes.status = "local.#statusname#">
				</cfif>
				<cfif structKeyExists(tagAttributes,"query")>
					<cfset local.query = tagAttributes.query>
					<cfset tagAttributes.query = "local.query">
				</cfif>
                <cfindex attributeCollection="#tagAttributes#">
				<cfif structKeyExists(tagAttributes, "status") and trim(tagAttributes["status"]) neq "">
					<cfset indexResult.status = local[statusname]>
				</cfif>

				<cfset tagResult.setResult(indexResult)>
                <cfreturn tagResult>
            </cfcase>

        	<!--- cfcollection service --->
            <cfcase value="CFCOLLECTION">
                <cfset var colResult = {}>
				<cfset var localname = "cfcollection_" & replace(createUUID(), "-","_","all")>
				<cfif listFindNoCase("list,categoryList",tagAttributes.action)>
					<cfset tagAttributes.name = "local.#localname#">
				</cfif>
                <cfcollection attributeCollection="#tagAttributes#">
				<cfif structKeyExists(tagAttributes, "name")>
					<cfset colResult.name = local[localname]>
				</cfif>
				<cfset tagResult.setResult(colResult)>
                <cfreturn tagResult>
            </cfcase>

		</cfswitch>
	</cffunction>
</cfcomponent>