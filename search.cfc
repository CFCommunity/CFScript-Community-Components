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
 * Search Service to perform search operations in cfscript
 * @name search
 * @displayname ColdFusion Search Service 
 * @output false
 * @accessors true
 */
component extends="base" {

	property string collection;
	//property string name;
	property string category;
	property string categoryTree;
	property numeric contextBytes;
	property string contextHighlightBegin;
	property string contextHighlightEnd;
	property numeric contextPassages;
	property string criteria;
	//Language is deprecated
	property numeric maxRows;
	property string previousCriteria;
	property numeric startRow;
	property string status;
	property string suggestions;
	property string orderby;
	//Type is deprecated

	property name="properties" type="any" getter="false" setter="false";

	//service tag to invoke
	variables.tagName = "CFSEARCH";
	
    //cffeed tag attributes
    variables.tagAttributes = getSupportedTagAttributes(getTagName());

	/**
	 * Default constructor invoked when search objects are created. 
	 * @return search object
	 * @output false
	 */
    public search function init() 
	{
		if(!structisempty(arguments)) structappend(variables,arguments);
        return this;
    }

    /**
	 * Invoke the cfsearch service tag to search solr collections in cfscript
     * Usage :: new search().search(criteria="foo",maxRows=10);
	 * @output false      
	 */
    public struct function search()
    {
        //store tag attributes to be passed to the service tag in a local variable
        var tagAttributes = duplicate(getTagAttributes());

        //attributes passed to service tag action like send() override existing attributes and are discarded after the action
		if (!structisempty(arguments))
        {
    		 structappend(tagAttributes,arguments);
        }

		//trim attribute values
		tagAttributes = trimAttributes(tagAttributes);

		return super.invokeTag(getTagName(),tagAttributes);
    }

}