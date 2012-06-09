# ColdFusion 9+ Script Components
## Community Edition!

The components in this project are contributed by the ColdFusion community, for the ColdFusion Community.

### Installing...

You can simply [download the zip](https://github.com/CFCommunity/CFScript-Community-Components/zipball/master) of the available components and toss them in the appropriate directory, if you want. (`{cf-install}\CustomTags\com\adobe\coldfusion\`)

It would be easier to update if you use git:

1. Open a terminal prompt at the above directory
1. Run this: `git init;git remote add origin git://github.com/CFCommunity/CFScript-Community-Components.git;git pull`
1. Any time you want to update, simply (go into that directory and) run `git pull`

# Deficiencies!

These are the tags that need to be ported over to script. Godspeed!

## Significant omissions:

* cfexchangecalendar    
* cfexchangeconnection  
* cfexchangecontact      
* cfexchangefilter      
* cfexchangemail 
* cfexchangetask 
* cfinvoke (support for dynamic method names, please!)
* cfmodule 
* cfoutput (implementation of query looping with grouping)
* cfparam (fix the bug in that enforced requiredness doesn’t work (ie: param name="foo";))
* cfquery (cachedwithin support)
* cfsetting 

## Reasonable case

* cfassociate    
* cfcache        
* cfprint      
* cfsharepoint  
* cftimer

## Ambivalent

* cfgridupdate
* cfinsert
* cflogin 
* cfobjectcache
* cfreport
* cfreportparam
* cfupdate

# Adobe copyright...

The following components ship with CF9 and CF9.01. Adobe holds copyright on them, but has granted permission to modify and distribute under an unspecified license, the text of which is below the list. Unless modified to support additional functionality or fix any bugs that may arise, they are not included in this repository. Any time they are changed, you can be sure tremendous effort has been made to maintain compatibility and, unless noted somewhere in this readme, has been achieved.

* base.cfc
* dbinfo.cfc
* feed.cfc
* ftp.cfc
* http.cfc
* imap.cfc
* ldap.cfc
* mail.cfc
* pdf.cfc
* pop.cfc
* query.cfc
* result.cfc
* storedproc.cfc
* storedprocresult.cfc

## Adobe license

This license text is taken from the components that ship with Adobe ColdFusion 9 and applies only to those components.

>ADOBE CONFIDENTIAL
>___________________
>
>Copyright 2008 Adobe Systems Incorporated
>All Rights Reserved.
>
>NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the terms of the Adobe license agreement accompanying it.  If you have received this file from a source other than Adobe, then your use, modification, or distribution of it requires the prior written permission of Adobe.

# MIT License

>Copyright (c) 2011 The ColdFusion Community
>
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See also: [http://www.opensource.org/licenses/mit-license.html](http://www.opensource.org/licenses/mit-license.html)

# Hey Adobe!

You are welcome, and encouraged, to ship these in future versions of ColdFusion. Please do, at least where appropriate. In some cases it just doesn't look and feel right to use CFCs to make these features. When that's the case, they are included here only as a stop-gap so that we can _actually write full-script components_. Please, where it makes sense, still write the features in Java. But where this implementation looks and feels natural, by all means, run with it! It'll make life better for everyone!