<!-----------------------------------------------------------------------------------------------------------
	MIT License

	Copyright (c) 2011 The ColdFusion Community

	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
	associated documentation files (the "Software"), to deal in the Software without restriction, including 
	without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
	copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
	following conditions:

	The above copyright notice and this permission notice shall be included in all copies or substantial 
	portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
	LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
	NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

	See also: http://www.opensource.org/licenses/mit-license.html
------------------------------------------------------------------------------------------------------------->
<cfcomponent>

	<cffunction access="public" name="init">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="cfml2wddx">
		<cfargument name="input" required="true" />
		<cfargument name="useTimeZoneInfo" default="yes" />
		<cfset arguments.action="cfml2wddx" />
		<cfset arguments.output="local.result" />
		<cfwddx attributeCollection="#arguments#" />
		<cfreturn local.result />
	</cffunction>
	
	<cffunction name="wddx2cfml">
		<cfargument name="input" required="true" />
		<cfargument name="useTimeZoneInfo" default="yes" />
		<cfargument name="validate" default="no" />
		<cfset arguments.action="wddx2cfml" />
		<cfset arguments.output="local.result" />
		<cfwddx attributeCollection="#arguments#" />
		<cfreturn local.result />
	</cffunction>
	
	<cffunction name="cfml2js">
		<cfargument name="input" required="true" />
		<cfargument name="topLevelVariable" />
		<cfargument name="useTimeZoneInfo" default="yes" />
		<cfargument name="validate" default="no" />
		<cfset arguments.action="cfml2js" />
		<cfset arguments.output="local.result" />
		<cfwddx attributeCollection="#arguments#" />
		<cfreturn local.result />
	</cffunction>
	
	<cffunction name="wddx2js">
		<cfargument name="input" required="true" />
		<cfargument name="topLevelVariable" />
		<cfargument name="useTimeZoneInfo" default="yes" />
		<cfargument name="validate" default="no" />
		<cfset arguments.action="wddx2js" />
		<cfset arguments.output="local.result" />
		<cfwddx attributeCollection="#arguments#" />
		<cfreturn local.result />
	</cffunction>
	
</cfcomponent>
