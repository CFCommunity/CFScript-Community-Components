/***********************************************************************************************************
*
* Made by Raymond Camden, Jedi Master
*
* MIT License
* 
* Copyright (c) 2011 The ColdFusion Community
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
* associated documentation files (the "Software"), to deal in the Software without restriction, including 
* without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
* copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
* following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial 
* portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
* LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN 
* NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
* See also: http://www.opensource.org/licenses/mit-license.html
*
*************************************************************************************************************/

/**
 * Index Service to perform solr index operations in cfscript
 * @name index
 * @displayname ColdFusion Index Service 
 * @output false
 * @accessors true
 */
component extends="base" {

	property string action;
	property string collection;
	property string body;
	property string category;
	property string categoryTree;
	property string custom1;
	property string custom2;
	property string custom3;
	property string custom4;
	property string extensions;
	property string key;
	property string language;
	property string prefix;
	property string query;
	property string status;
	property string title;
	property string type;
	property string urlpath;

	property name="properties" type="any" getter="false" setter="false";

	//service tag to invoke
	variables.tagName = "CFINDEX";
	
    //cfcollection tag attributes
    variables.tagAttributes = getSupportedTagAttributes(getTagName());

	/**
	 * Default constructor invoked when search objects are created. 
	 * @return search object
	 * @output false
	 */
    public index function init() 
	{
		if(!structisempty(arguments)) structappend(variables,arguments);
        return this;
    }

    /**
	 * Invoke the cfindex service tag to delete keys from solr collections in cfscript
     * Usage :: new index().delete(collection="beer",key=9);
	 * @output false      
	 */
    public struct function delete()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="delete";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

    /**
	 * Invoke the cfindex service tag to purge a solr collection in cfscript
     * Usage :: new index().purge(collection="beer");
	 * @output false      
	 */
    public struct function purge()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="purge";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

    /**
	 * Invoke the cfindex service tag to refresh solr collections in cfscript
     * Usage :: new index().refresh(collection="beer",query=q);
	 * @output false      
	 */
    public struct function refresh()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="refresh";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

    /**
	 * Invoke the cfindex service tag to refresh solr collections in cfscript
     * Usage :: new index().refresh(collection="beer",query=q);
	 * @output false      
	 */
    public struct function update()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="update";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

}