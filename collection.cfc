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
 * Collection Service to perform solr collection operations in cfscript
 * @name collection
 * @displayname ColdFusion Collection Service 
 * @output false
 * @accessors true
 */
component extends="base" {

	property string action;
	property string categories;
	property string collection;
	property string engine;
	property string language;
	property string name;
	property string path;

	property name="properties" type="any" getter="false" setter="false";

	//service tag to invoke
	variables.tagName = "CFCOLLECTION";
	
    //cfcollection tag attributes
    variables.tagAttributes = getSupportedTagAttributes(getTagName());

	/**
	 * Default constructor invoked when search objects are created. 
	 * @return search object
	 * @output false
	 */
    public collection function init() 
	{
		if(!structisempty(arguments)) structappend(variables,arguments);
        return this;
    }


    /**
	 * Invoke the cfcollection service tag to get categories for a collection
     * Usage :: new collection().categoryList(collection="fivetag");
	 * @output false      
	 */
    public struct function categoryList()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="categorylist";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

    /**
	 * Invoke the cfcollection service tag to create collections
     * Usage :: new collection().create(collection="fivetag",path="c...");
	 * @output false      
	 */
    public struct function create()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="create";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

    /**
	 * Invoke the cfcollection service tag to delete collections
     * Usage :: new collection().delete(collection="boom");
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
	 * Invoke the cfcollection service tag to list solr collections in cfscript
     * Usage :: new collection().list();
	 * @output false      
	 */
    public struct function list()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="list";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

    /**
	 * Invoke the cfcollection service tag to optimize collections
     * Usage :: new collection().optimize(collection="boom");
	 * @output false      
	 */
    public struct function optimize()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		tagAttributes.action="optimize";

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }


}