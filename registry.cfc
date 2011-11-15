<!-----------------------------------------------------------------------------------------------------------
   ADOBE COLDFUSION COMMUNITY
   BSD License
   ___________________
   
   Copyright 2011 The ColdFusion Community
   These days the kids call the BSD License the "do whatever the fuck you want to" license.
   That sounds good. Have fun.
   
   NOTICE:  The ColdFusion Community permits you to use, modify, and distribute this file in accordance 
   with the following terms: please don't be a dick.
------------------------------------------------------------------------------------------------------------->
<cfcomponent>

	<cfset variables.result = "" />

    <cffunction access="public" returns="void" name="init">
		<cfreturn this/>
	</cffunction>

	<cffunction name="getAll">
		<cfset arguments.name = "variables.result" />
		<cfset go(arguments) />
		<cfreturn variables.result />
	</cffunction>

	<cffunction name="get">
		<cfset arguments.variable = "variables.result" />
		<cfset go(arguments) />
		<cfreturn variables.result />
	</cffunction>

	<cffunction name="set">
		<cfset go(arguments) />
	</cffunction>

	<cffunction name="delete">
		<cfset go(arguments) />
	</cffunction>

	<cffunction name="go">
		<cfregistry attributeCollection="#arguments#" />
	</cffunction>

</cfcomponent>