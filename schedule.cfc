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
    <cffunction access="public" returns="void" name="init">
		<cfif structIsEmpty(arguments)>
			<cfreturn />
		</cfif>
		<cfschedule attributeCollection="#arguments#" />
	</cffunction>
</cfcomponent>