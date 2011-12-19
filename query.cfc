/***********************************************************************************************************
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

/**
 * Query Service to execute SQL queries in cfscript
 * @name query
 * @displayname ColdFusion Query Service 
 * @output false
 * @accessors true
 */
component extends="base"
{
    property string name; 
    property numeric blockfactor;
    property string cachedafter;
    property string cachedwithin;
    property string dataSource;
    property string dbtype;
    property boolean debug;
    property numeric maxRows;
    property string password;
    property string result;
    property numeric timeout;
    property string username;
    property string sql;
    
    //array to store cfqueryparams
    variables.parameters = [];

    //service tag to invoke
    variables.tagName = "CFQUERY";

    //list of valid cfquery tag attributes
    variables.tagAttributes = getSupportedTagAttributes(getTagName());

    //default error message and error type
    variables.errorMessage = "Error Executing Database Query";
    variables.errorType = "Application";

    //constants
    variables.COMMA = ",";
    variables.RIGHTPARENTHESIS = ")";
    variables.NEWLINE = chr(13) & chr(10);
    variables.SPACE = " ";
    variables.EMPTYSTRING = "";
    variables.SINGLEQUOTE= "'";
    variables.NAMED_DELIMITER = ":";
    variables.POSITIONAL_DELIMITER = "?"; 
    variables.NAMED_DELIMITER_MARKER = chr(2);
    variables.POSITIONAL_DELIMITER_MARKER = chr(3);
    
    
    /**
     * Initialization routine. Returns an instance of this component
     * @output false
     */
    public com.adobe.coldfusion.query function init()
    {
        if(!structisempty(arguments))
        {        
            structappend(variables,arguments,"yes");
        }
        return this;
    }


    /**
     * Inserts a named sql param into sqlParams array. If the named param is not found, an exception is thrown
     * 
     * @param1 namedparam 
     * @param2 namedparamsarray Array containing all named sql params
     * @param3 sqlParams Array containing all sql queryparams supplied
     * @return array with the sqlParams inserted
     * 
     * @output false
     */
    private array function insertNamedParams(string namedparam,array namedparamsarray,array sqlParams,string sql)
    {
        var i = 0;
        var foundNamedParam = false;
        for(i=1; i lte arraylen(namedparamsarray); i++)
        {
            if(structkeyexists(namedparamsarray[i],"name") and trim(namedparamsarray[i]["name"]) eq namedparam)
            {
                arrayappend(sqlParams,duplicate(namedparamsarray[i]));
                /*
                Delete "name" attribute for this entry (named param) from sqlParams array as we no longer need it, and besides, 
                sending it to cfqueryparam with the name attribute would throw an error since allowExtraAttribute=false
                */
                structdelete(sqlParams[arraylen(sqlParams)],"name");
                foundNamedParam = true;
                break;
            }
        }
        if(!foundNamedParam)
        {
            var errorDetail = "Parameter '" & namedparam & "' not found in the list of parameters specified" & "<br><br>" & "SQL: " & sql;
            throw(errorMessage,errorType,errorDetail);
        }
        return sqlParams;
    }


    /**
     * Processes named sql params. Invokes insertNamedParams() to insert the named param into sqlparams array.
     *
     * @param1 sqlArray 
     * @param2 sqlParams
     * @param3 namedparamsarray Array containing all named sql params
     * @param4 queryparams Array containing all sql queryparams supplied
     * @param5 sqlCommand Sql operation to perform
     * @return struct with sqlArray and sqlParams
     * 
     * @output false
     */
    private struct function processNamedParams(array sqlArray,array sqlParams,array namedparamsarray,array queryparams,string sqlCommand,string sql)
    {
        var namedparam = "";
        var i = 0;
        if(arraylen(sqlArray) gt 0)
        {
            for(i=2; i <= arraylen(sqlArray); i++)
            {
                var delimters = SPACE & COMMA & RIGHTPARENTHESIS & NEWLINE;
                namedparam = trim(listfirst(sqlArray[i],delimters));
                sqlArray[i] = replace(arguments.sqlArray[i],namedparam,EMPTYSTRING);
                sqlParams = insertNamedParams(namedparam,namedparamsarray,sqlParams,sql);
             }
         }
        return {sqlArray=sqlArray,sqlParams=sqlParams};
    }
    
    
    /** 
     * Removes first positional param from positional sql params array
     *
     * @param1 posparamsarray An array with positional sql params
     * @return array with first positional sql param removed
     * 
     * @output false
     */
    private array function removePosParam(array posparamsarray)
    {
        var newPosParamsArray = [];
        var i = 0;

        //create a temp array from posparamsarray without the first element
        for(i=2;i lte arraylen(posparamsarray); i++)
        {
            newPosParamsArray[i-1] = posparamsarray[i];
        }
        return newPosParamsArray;
    }


    /**
     * Processes positional sql params
     *
     * @param1 sqlArray 
     * @param1 sqlParams
     * @param1 posparamsarray An array with all positional params
     * @param1 queryparams An array with all queryparams the user supplied
     * @return struct with keys sqlArray and sqlParams
     *
     * @output false
     */
    private struct function processPosParams(array sqlArray,array sqlParams,array posparamsarray,array queryparams,string sql) 
    {
        if(arraylen(sqlArray) gt 0)
        {
            if(arraylen(queryparams) lt arraylen(sqlArray)-1)
            {                
                var errorDetail = "The number of parameters specified do not match the number of specified or implied columns" & "<br><br>" & "SQL: " & sql;                
                throw(errorMessage,errorType,errorDetail);
            }

            var j = 0;
            //loop until all positional sql params are processed
            for(j=1;j lte arraylen(sqlArray); j++)
            {
                if(arraylen(posparamsarray) gt 0)
                {
                    arrayappend(sqlParams,posparamsarray[1]);
                }
                //remove the postional sql param from the posparamsarray array
                posparamsarray = removePosParam(posparamsarray);
            }
        }
        return {sqlArray=sqlArray,sqlParams=sqlParams};
    }
    
    
    /**
     * Merge one array into another at a specified position and returns the merged array
     * 
     * @param1 sqlArray1 Array into which to insert
     * @param2 sqlArray2 Array to be inserted
     * @param2 pos  Position at which to insert
     * @return array (merged)
     *
     * @output false
     */
    private array function arrayinsert(array sqlArray1, array sqlArray2, numeric pos) 
    {
        var mergedArray = [];
        var i = 0;
        
        //copy array sqlArray1 elements until pos-1 into mergedArray 
        for(i=1; i lte pos-1; i++)
        {
            arrayappend(mergedArray,sqlArray1[i]);
        }
        
        //copy sqlArray2 into mergedArray
        for(i=1; i lte arraylen(arguments.sqlArray2); i++)
        {
            arrayappend(mergedArray,sqlArray2[i]);
        }
        
        //copy the remainder of sqlArray1 elements
        for(i=pos+1; i lte arraylen(sqlArray1); i++)
        {
            arrayappend(mergedArray,sqlArray1[i]);
        }
        
        //return the merged array 
        return mergedArray;
    }


    /** 
     * Checks if a named sql param exists in namedparams array. 
     * 
     * @param1 namedparams  named sql params array
     * @param2 currentnamedparam  named param to search in the array
     * @return Position at which the named param is found or false otherwise
     * 
     * @output false
     */
    private boolean function checkIfNamedParamExists(array namedSqlparams, string namedparam)
    {
        var i = 0;
        for(i=1; i lte arraylen(namedSqlparams)-1; i++)
        {
             if(structkeyexists(namedSqlparams[i],"name") and trim(namedSqlparams[i]["name"]) eq namedparam)
             {
                return i;   
             }
        }
        return false;
    }


    /**
     * parse queryparams stored in parameters array to filter out all named sql params.
     * 
     * @param1 queryparams An array containing all queryparams
     * @return array containing all named sql params
     *   
     * @output false
     */
    private array function getNamedSqlParams(array queryparams)  
    {
        var namedSqlParams = [];
        var i = 0;

        for(i=1; i lte arraylen(queryparams); i++)
        {
            if(structkeyexists(queryparams[i],"name"))
            {
                //If named sql param already exists, update it. Else, add it
                var namedparam =  trim(queryparams[i]["name"]);
                var found = checkIfNamedParamExists(namedSqlParams,namedparam);
                if(!found)
                {
                    //insert the queryparam into the namedSqlParams array
                    arrayappend(namedSqlParams,queryparams[i]);
                }
                else
                {
                    //since the named param already exists, update its value
                    structappend(namedSqlParams[found],queryparams[i],"yes");
                }
             }
        }
        return namedSqlParams;
    }
    
    
    /** 
     * parse queryparams stored in parameters array to filter out all postional sql params.
     *
     * @param1 queryparams An array containing all queryparams
     * @return array containing all positional sql params
     *
     * @output false
     */
    private array function getPositionalSqlParams(array queryparams)
    {
        var positionalSqlParams = [];
        var i = 0;
        for(i=1; i lte arraylen(queryparams); i++)
        {
            //if there is no "name" key in the queryparam, it is a positional sql param
            if(!structkeyexists(queryparams[i],"name"))
            {
                //insert the queryparam into the positionalSqlParams array
                arrayappend(positionalSqlParams,queryparams[i]);
             }
        }
        return positionalSqlParams;
    }
    

    /** 
     * replace named and positional delimiters inside single quotes with corresponding markers to allow parsing SQL on delimiters 
     * @output false
     */
    private string function replaceDelimsWithMarkers(string sql, string sqlDelimtersList, string sqlDelimtersMarkersList)
    {
        var sqlArray = listtoarray(arguments.sql,SINGLEQUOTE,true);
        var newSql = "";
        var i = 0;
        for(i=1; i lte arraylen(sqlArray); i++)
        {
            //even numbered array indices contain value inside the single quotes
            //replace occurence of named or positional delimiters in the value with corresponding markers 
            if( (i%2) eq 0 )
            {
                sqlArray[i] = ReplaceList(sqlArray[i],sqlDelimtersList,sqlDelimtersMarkersList);
                newSql = newSql & SINGLEQUOTE & sqlArray[i] & SINGLEQUOTE & " ";
            }
            else
            {
                newSql = newSql & sqlArray[i];
            }
        }
        return newSql;
    }


    /**
     * Replaces markers for named and positional delimiters (inside single quotes) with actual delimiters
     *
     * @param1 sqlArray Array with parsed sql
     * @return array Array with markers replaced with single quotes 
     *
     * @output false 
     */
    private array function replaceMarkersWithDelims(array sqlArray, string sqlDelimtersMarkersList, string sqlDelimtersList)
    {
        var i = 0;
        for(i=1; i lte arraylen(sqlArray); i++)
        {
            sqlArray[i] = ReplaceList(sqlArray[i],sqlDelimtersMarkersList,sqlDelimtersList);
        }
        return sqlArray;
    }
    
    
    /**
     * preservesinglequotes() can't handle expressions, so something like #preservesinglequotes(SQlArray[1])# would'nt work,
     * hence the need for this wrapper 
     * @output false 
     */  
    private string function getPreserveSingleQuotes(string sqlstatement)
    {
        return PreserveSingleQuotes(arguments.sqlstatement);
    }


    /**
     * Parse the SQL into named and positional params. 
     * 
     * For named params, order of params is not important but for postional params we need to match 
     * the order in which the params are listed.
     * 
     * Named SQL parameters are specified using ":" (for example, select  * from art where artid = :artistid)
     * Positional SQL parameters are specified using  "?" (for example, select  * from art where artid = ? and artistid = ?)
     * 
     * A combination of named and positional sql params is also possible (although not encouraged)
     * (for example, select  * from art where artid = :artid and artistid = ?)
     * 
     * If named/positional param delimiters (i.e. ":" and "?") appear inside single quotes, we replace them with markers 
     * to help with the parsing. After we are done with the parsing and before we pass the sql to execute() for execution, we replace the markers back with 
     * the delimiters 
     * 
     * This function parses the sql into sqlArray[] and sqlParams[]
     *  
     * @param1 sql The sql used in the query
     * @param2 queryparams The queryparams for the query 
     * @param3 sqlCommand The sql operation to perform
     * @return A struct with keys - sqlType (named/param/both), sqlArray (sql parsed into array) and sqlParams (queryparams parsed into array of structs)
     *
     * @output false    
     */
    private any function parseSQL(string sql,array queryparams,string sqlCommand)
    {
        //type of sql (named | positional | both | "" (for simple SQL)) 
        var sqlType = "";

        //sql delimiter (: -> named, ? -> positional)
        var delimiter = "";

        //array to store parsed sql
        var sqlArray = [];

        //array to store parsed sql queryparams
        var sqlParams = [];

        //markers used to replace named or positional parameters found inside single quotes or ''
        var sqlDelimtersList = NAMED_DELIMITER & "," & POSITIONAL_DELIMITER;
        var sqlDelimtersMarkersList = NAMED_DELIMITER_MARKER & "," & POSITIONAL_DELIMITER_MARKER;

        //replace occurences of any named or positional delimters inside single quotes with markers since we are dealing with a value rather than a sql param
        var mysql = replaceDelimsWithMarkers(sql,sqlDelimtersList,sqlDelimtersMarkersList);
        var param = [];

        //parse queryparams (stored in paramters array) into named sql params and positional sql params 
        var namedparamsarray = getNamedSqlParams(queryparams);
        var posparamsarray = getPositionalSqlParams(queryparams);

        //if the sql has both named and positional params, we first parse the sql for positional params, and then for named params
        if(mysql contains NAMED_DELIMITER and mysql contains POSITIONAL_DELIMITER)
        {
            sqlType = "both";
            delimiter = POSITIONAL_DELIMITER;
        }
        else if(mysql contains NAMED_DELIMITER and not (mysql contains POSITIONAL_DELIMITER))
        {
            sqlType = "namedSql";
            delimiter = NAMED_DELIMITER;
        }
        else if(mysql contains POSITIONAL_DELIMITER and not (mysql contains NAMED_DELIMITER))
        {
            sqlType = "posSql";
            delimiter = POSITIONAL_DELIMITER;
        }
        else
        {    
            sqlType = "";
            delimiter = "";
        }
        
        //convert sql into an array. If there are no named/positional params, the array would consist of merely the sql but if there are params, we use the delimiter
        sqlArray = (delimiter eq "")? [mysql]: listtoarray(mysql,delimiter,true,true);  

        switch(sqlType)
        {
            //we are dealing with postional sql parameters 
            case "posSql":
            {
                var s = processPosParams(sqlArray,sqlParams,posparamsarray,queryparams,sql);
                sqlArray = s["sqlArray"];
                sqlParams = s["sqlParams"];
                break;
            }
            
            //we are dealing with named sql parameters
            case "namedSql":
            {
                s = processNamedParams(sqlArray,sqlParams,namedparamsarray,queryparams,sqlCommand,sql);
                sqlArray = s["sqlArray"];
                sqlParams = s["sqlParams"];
                break;
            }
            
            //we are dealing with a combination of both named and positional sql parameters 
            case "both":
            {
                continueloop = true;
                var i = 1;
                
                //loop until we are finished with sqlArray[], which grows dynamically as we continue processing the params
                while(continueloop eq true)
                {
                    //this is a positional sql param that we are dealing with here 
                    if(sqlArray[i] does not contain NAMED_DELIMITER)
                    {
                        if(i lt arraylen(sqlArray))
                        {
                            if(arraylen(posparamsarray) gt 0)
                            {
                                arrayappend(sqlParams,posparamsarray[1]);
                            }
                            posparamsarray = removePosParam(posparamsarray);
                        }
                        i = i + 1;
                    }
                    else
                    {
                        //this is a named sql param that we are dealing with here 
                        var temp = processNamedParams(listtoarray(sqlArray[i],NAMED_DELIMITER),sqlParams,namedparamsarray,queryparams,sqlCommand,sql);
                        param = temp["sqlArray"];
                        sqlParams = temp["sqlParams"];

                        //insert array param into sqlArray at postion i and returns the new merged array
                        sqlArray = arrayinsert(sqlArray,param,i);
                        
                        //since we are already done with processing the param array, we skip past it and resume our processing 
                        i = i + arraylen(param);
                        if(i lte arraylen(sqlArray))
                        {
                            if(arraylen(posparamsarray) gt 0)
                            {
                                arrayappend(sqlParams,posparamsarray[1]);
                            }
                            posparamsarray = removePosParam(posparamsarray);
                        }
                    }
                    if(i gt arraylen(sqlArray))
                    {
                        continueloop=false;
                    }
                }
                break;
            }
            default:
            {
                sqlArray = [mysql]; 
                break;
            }
        }
        
        //replace markers for named and positional delimiters with actual delimiters 
        sqlArray = replaceMarkersWithDelims(sqlArray,sqlDelimtersMarkersList,sqlDelimtersList);
        
        //return a struct with the parsed array and parsed queryparams back
        return {sqlArray=sqlArray,sqlParams=sqlParams,sqlType=sqlType};
    }


    
    /**
     * Validate SQL for errors 
     * @return SQL or an error if SQL has errors   
     * @output false
     */
    private string function validateSQL(struct tagAttributes)
    { 
        var sql = "";
        var errorDetail = "";

        //throw an error if SQL is not defined
        if(not structkeyexists(tagAttributes,"sql"))
        {
            errorDetail = "SQL is required";
            throw(errorMessage,errorType,errorDetail);
        }
        else
        {
            sql = tagAttributes["sql"];
            //throw an error if SQL is empty
            if(len(trim(sql)) eq 0)
            {
                errorDetail = "The value of SQL cannot be empty";
                throw(errorMessage,errorType,errorDetail);
            }
        }
        return sql;
    }
 
 
    /**
     * Invoke the cfquery (and cfqueryparam) service tag to execute a query in cfscript. Returns the query resultset
     * @output false
     */
    public result function execute()
    {  
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //store query params
        var queryparams = duplicate(variables.parameters);

        //attributes passed to service tag action like execute() override existing attributes and are discarded after the action
        if(!structisempty(arguments))
        {
             structappend(tagAttributes,arguments,"yes");
        }

        //extract SQL from attributes and validate it for errors
        var sql = validateSQL(tagAttributes);

        //remove leading and trailing parenthesis for stored procs called using {CALL myproc 1,2}
        if(left(sql,1) eq "{" and right(sql,1) eq "}")
        {
            sql = trim(mid(sql,2,len(sql)-2));
        }

        //sql operation to perform (Select | update | insert | delete | exec | call)
        var sqlCommand = ucase(listfirst(sql," "));
        
        //parse SQL and process queryparams, if defined
        var r = parseSQL(sql,queryparams,sqlCommand);
        var sqlType = r["sqlType"];
        var sqlArray = r["sqlArray"];
        var sqlParams = r["sqlParams"];
        
        //put back leading and trailing parenthesis for stored procs called using {CALL myproc 1,2}
        if(sqlCommand eq "CALL")
        {
            sqlArray[1] = "{" & sqlArray[1];
            sqlArray[arraylen(sqlArray)] = sqlArray[arraylen(sqlArray)] & "}";
        }
        
        //looks like query name attribute isn't really required, so we give the query a name in case one is not specified
        if(!structkeyexists(tagAttributes,"name") or (structkeyexists(tagAttributes,"name") and tagAttributes["name"] eq ""))
        {
            tagAttributes["name"] = "qryname#randrange(1,100000)#";
        }
        
        //should we do the same for result attribute also? 
        if(!structkeyexists(tagAttributes,"result") or (structkeyexists(tagAttributes,"result") and tagAttributes["result"] eq ""))
        {
            tagAttributes["result"] = "qryresult#randrange(1,100000)#";
        }
        
        //delete sql attribute since passing it would execute the sql which is not what we want as we are preparsing the sql
        if(structkeyexists(tagAttributes,"sql"))
        {
            structdelete(tagAttributes,"sql");
        }
            
        //trim attribute values
        tagAttributes = trimAttributes(tagAttributes);

        //invoke the cfquery/cfqueryparam tags replacing any named or positional params with cfqueryparam tag 
        return super.invokeTag(getTagName(),tagAttributes,{params=sqlParams,sqlArray=sqlArray,sql=sql,sqlType=sqlType});
    }
}