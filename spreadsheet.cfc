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

	<cfset variables.result = "" />

    <cffunction access="public" returns="void" name="init">
		<cfreturn this/>
	</cffunction>

	<cffunction name="readInfo">
		<cfset arguments.action = "read" />
		<cfset arguments.name = "variables.result" />
		<cfset go(argumentcollection=arguments) />
		<cfreturn variables.result />
	</cffunction>

	<cffunction name="readQuery">
		<cfset arguments.action = "read" />
		<cfset arguments.query = "variables.result" />
		<cfset go(argumentcollection=arguments) />
		<cfreturn variables.result />
	</cffunction>

	<cffunction name="update">
		<cfset arguments.action = "update" />
		<cfif structKeyExists(arguments, "query")>
			<cfset variables.result = arguments.query />
			<cfset arguments.query = "variables.result" />
		</cfif>
		<cfset go(argumentcollection=arguments) />
	</cffunction>

	<cffunction name="write">
		<cfset arguments.action = "write" />
		<cfif structKeyExists(arguments, "query")>
			<cfset variables.result = arguments.query />
			<cfset arguments.query = "variables.result" />
		</cfif>
		<cfset go(argumentcollection=arguments) />
	</cffunction>

	<cffunction name="go">
		<cfspreadsheet attributeCollection="#arguments#" />
	</cffunction>

</cfcomponent>