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
<cfcomponent output="false" hint="Provides a simplified query-of-queries functionality">
	<cffunction access="public" returntype="query" name="init" hint="Send your queries in as named arguments. They will be appended to the local scope for use within the query.">
		<cfargument name="SQL" required="true" type="string" hint="Required: Your SQL statement. Query params are not supported." />
		<cfset structAppend( local, arguments ) />
		<cfquery dbtype="query" name="local.__queryResult">#preserveSingleQuotes(arguments.SQL)#</cfquery>
		<cfreturn local.__queryResult />
	</cffunction>
</cfcomponent>