<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <sch:title>UA Business Rules</sch:title>
<!-- Date: 27 AUG 2018 Developer: Scott Hudson -->
<!-- Note: The business rules listed below are not implemented via DTDs. -->
<!--
        Severities				
        1 = error =       Unacceptable	  Must be fixed before checking in the file.
        2 = warning =  Severe	      Must be fixed before composing a review draft.
        3 = warning =  Minimal	      Must be fixed before releasing to the public.
        4 = warning =  Non-optimum	  Should be fixed before releasing to the public.
    -->

<!-- UA business rules -->
<sch:let name="approvers" value="document('IATable.xml')" />
<sch:let name="booktypes" value="document('BookTypes.xml')" />
<sch:let name="products" value="document('ProductNames.xml')" />
    
<sch:let name="excluded-elements" value="('draft-comment', 'cmdname', 'codeblock', 'codeph', 'synph', 'synblk', 'msgph', 'msgblock', 'userinput', 'systemoutput', 'parmname', 'varname', 'apiname', 'filepath', 'uicontrol', 'option', 'wintitle', 'screen', 'pre', 'cite', 'term', 'change-summary')"/>
       
    <sch:pattern>
        <sch:p>In Get Started node, "Learn About…" submap must be in first position.</sch:p>
        <sch:rule id="UA005" context="*[contains(@class, ' mapgroup-d/topichead ')][@navtitle='Get Started']">
            <sch:assert test="child::topicref[1]/topicmeta/navtitle/text()[starts-with(., 'Learn About')]" role="error">UA005: "Learn About…" submap is missing or not placed in first position.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>In Get Started node, within the "Learn About..." map, a topic with title "Learn About the [solution]" must be in first position.</sch:p>
        <sch:rule id="UA006" context="map[title[starts-with(., 'Learn About')]]">
            <sch:assert test="child::topicref[topicmeta/navtitle/text()[starts-with(., 'Learn About')]][not(preceding-sibling::topicref)]" role="error">UA006: In Get Started node, within the "Learn About..." map, a topic with title "Learn about the [solution]" must be in first position.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>       
        <sch:p>The title element for articles must use headline-style casing.</sch:p>
        <sch:rule id="UA007" context="*[contains(@class, ' topic/title ')]">
            <sch:assert test="matches(., '^[A-Z]\w*\s*((a|an|the|and|but|or|on|in|with|([A-Z]\w*))\s*)*$')" role="error">UA007: The title must use headline-style casing.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>All child topics of "Learn About..." must be of type Concept.</sch:p>
        <sch:rule id="UA008" context="map[title[starts-with(., 'Learn About')]]//topicref">
            <sch:assert test="@type='concept'" role="error" sqf:fix="addConceptType">UA008: This article must only contain topics of the type Concept.</sch:assert>
            <sqf:fix id="addConceptType">
                <sqf:description>
                    <sqf:title>Add @type="concept"</sqf:title>
                </sqf:description>
                <sqf:add node-type="attribute" target="type">concept</sqf:add>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>Title elements for articles in a ditamap must use imperative verb phrases, not gerunds</sch:p>
        <sch:rule id="UA009" context="*[contains(@class, ' topic/title ')]">
            <sch:report test="matches(., '^([\w*]+ing)')" role="error">UA009: The title must begin with an imperative phrase. Please rewrite.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>Each article must contain at least one task topic.</sch:p>
        <sch:rule id="UA010" context="*[contains(@class, ' map/map ')][title[not(starts-with(., 'Learn About'))]]">
            <sch:assert test="count(descendant::topicref[@type='task']) > 0" role="error" sqf:fix="addTask addTaskType addGUID">UA010: Article does not contain any topicref elements with @type="task".</sch:assert>
            <sqf:fix id="addTaskType">
                <sqf:description>
                    <sqf:title>Add @type="task" to the task topicref</sqf:title>
                </sqf:description>
                <sqf:add match="//topicref[not(@type)]" node-type="attribute" target="type">task</sqf:add>                
            </sqf:fix>
            <sqf:fix id="addGUID">
                <sqf:description>
                    <sqf:title>Add GUID</sqf:title>
                </sqf:description>
                <sqf:user-entry name="taskGUID">
                    <sqf:description>
                        <sqf:title>Add a GUID to the task topicref</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:add match="//topicref[not(@href)]" node-type="attribute" target="href"><sch:value-of select="$taskGUID" /></sqf:add>                              
            </sqf:fix>
            <sqf:fix id="addTask">
                <sqf:description>
                    <sqf:title>Add a new task topicref</sqf:title>
                </sqf:description>
                <sqf:user-entry name="taskTitle">
                    <sqf:description>
                        <sqf:title>Add a task title</sqf:title>
                    </sqf:description>
                </sqf:user-entry>               
                <sqf:add node-type="element" target="topicref" position="last-child">
                  <topicmeta><navtitle><sch:value-of select="$taskTitle" /></navtitle></topicmeta>
                </sqf:add>                 
                </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>In Get Started node of Develop, Integrate, or Operate solutions, a concept topic with title "About Required Services and Roles…" must be in third position in "Learn About…" submap.</sch:p>
        <sch:rule id="UA011" context="*[contains(@class, ' mapgroup-d/topichead ')][@navtitle='Get Started']">
            <sch:assert test="child::topicref[3][starts-with(topicmeta/navtitle/text(), 'About Required Services and Roles')][@type='concept'][@href]" role="error" sqf:fix="addConcept addConceptType addGUID">UA011: In Get Started node, "About Required Services and Roles" topic is missing or is not of the type Concept.</sch:assert>
            <sqf:fix id="addConceptType">
                <sqf:description>
                    <sqf:title>Add @type="concept" to the "About Required Services and Roles" topicref</sqf:title>
                </sqf:description>
                <sqf:add match="topicref[topicmeta/navtitle/text()[starts-with(., 'About Required Services and Roles')]]" node-type="attribute" target="type">concept</sqf:add>                
            </sqf:fix>
            <sqf:fix id="addGUID">
                <sqf:description>
                    <sqf:title>Add GUID to the "About Required Services and Roles" topicref</sqf:title>
                </sqf:description>
                <sqf:user-entry name="conceptGUID">
                    <sqf:description>
                        <sqf:title>GUID for the "About Required Services and Roles" topicref:</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:add match="topicref[topicmeta/navtitle/text()[starts-with(., 'About Required Services and Roles')]]" node-type="attribute" target="href"><sch:value-of select="$conceptGUID" /></sqf:add>                              
            </sqf:fix>
            <sqf:fix id="addConcept">
                <sqf:description>
                    <sqf:title>Add a new "About Required Services and Roles" topicref</sqf:title>
                </sqf:description>            
                <sqf:add node-type="element" target="topicref" position="last-child">
                    <topicmeta><navtitle>About Required Services and Roles</navtitle></topicmeta>
                </sqf:add>                 
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>If an article contains "About..." concept topic, it must be in first position.</sch:p>
        <sch:rule id="UA012" context="*[contains(@class, ' map/topicref ')][@type='concept'][topicmeta/navtitle/text()[starts-with(., 'About')]][preceding-sibling::topicref]">
            <sch:assert test="position() = 1" role="warning">UA012: "About…" topic is not placed in first position.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>An article should contain a "Before You Begin" (steps) task or (list) concept topic.</sch:p>
        <sch:rule id="UA013" context="*[contains(@class, ' map/map ')]">
            <sch:assert test="descendant::topicref/topicmeta/navtitle/text()[starts-with(., 'Before You Begin')]" role="warning">UA013: Article is missing a "Before you Begin" concept or task topic.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>Explore More Solutions must be placed last in an article unless a solution contains a Download Code submap, where it must be placed next to last with only Download Code following it.</sch:p>
        <sch:rule id="UA015a" context="*[contains(@class, ' map/map ')][not(descendant::topicref/topicmeta/navtitle/text()[starts-with(., 'Download Code')])]">
            <sch:assert test="descendant::topicref[last()][topicmeta/navtitle/text()[starts-with(., 'Explore More Solutions')]]" role="warning">UA015a: Explore More Solutions topic must be placed last in this solution; only Download Code can follow it</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>Explore More Solutions must be placed last in an article unless a solution contains a Download Code submap, where it must be placed next to last with only Download Code following it.</sch:p>
        <sch:rule id="UA015b" context="*[contains(@class, ' map/map ')][descendant::topicref/topicmeta/navtitle/text()[starts-with(., 'Download Code')]]">
            <sch:assert test="descendant::topicref[topicmeta/navtitle/text()[starts-with(., 'Explore More Solutions')]][following-sibling::topicref/topicmeta/navtitle/text()[starts-with(., 'Download Code')]]" role="warning">UA015b: Explore More Solutions topic must be placed last in this solution; only Download Code can follow it</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>An article must not contain more than seven topics.</sch:p>
        <sch:rule id="UA016" context="*[contains(@class, ' map/map ')]">
            <sch:let name="topicCount" value="count(descendant::topicref)"/>
            <sch:assert test="count(descendant::topicref) &lt; 8" role="error">UA016: An article must not contain more than seven topics. Article contains <xsl:value-of select="$topicCount"/> topics.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>A topic must not contain inline links or listed cross-references.</sch:p>
        <sch:rule id="UA018" context="*[contains(@class, ' topic/topic ')][not(starts-with(title, 'Download Code'))]">
            <sch:report test="descendant::*[contains(@class, ' topic/xref ')]" role="error">UA018: Content contains one or more cross-references. Cross-references are not allowed in solutions content.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>A &lt;title> element must contain content.</sch:p>
        <sch:rule id="UA019" context="*[contains(@class, ' topic/topic ')]">
            <sch:assert test="title/text()" role="error" sqf:fix="addMissing addText">UA019: The title string is empty or does not contain enough characters. Please rewrite.</sch:assert>
            <sqf:fix id="addMissing" use-when="not(title)">
                <sqf:description>
                    <sqf:title>Add the missing &lt;title>.</sqf:title>
                </sqf:description>
                <sqf:user-entry name="newTitle">
                    <sqf:description>
                        <sqf:title>Enter a text string for &lt;title>.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:add match="." position="first-child" target="title" node-type="element"><xsl:value-of select="$newTitle" /></sqf:add>
            </sqf:fix>
            <sqf:fix id="addText" use-when="not(title/text())">
                <sqf:description>
                    <sqf:title>Enter a text string for &lt;title>.</sqf:title>
                    <sqf:p>The title string is empty or does not contain enough characters. Please rewrite.</sqf:p>
                </sqf:description>
                <sqf:user-entry name="newTitle">
                    <sqf:description>
                        <sqf:title>Enter a text string for &lt;title>.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:replace match="title"><title><sch:value-of select="$newTitle" /></title></sqf:replace>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>In Download Code topics, ensure that links to Github or OTN use universal links.</sch:p>
        <sch:rule id="UA021" context="*[contains(@class, ' topic/topic ')][starts-with(title, 'Download Code')]//*[contains(@class, ' topic/xref ')]">
            <sch:assert test=".[@format='html'][starts-with(@href, 'https://www.oracle.com/pls/topic/lookup?ctx=en/solutions&amp;id=')][@locktitle='yes'][@navtitle='Source Zip'][scope='external']" role="error">UA021: The link is not properly formatted as a universal link. The link should be formatted: &lt;topicref format="html" href="https://www.oracle.com/pls/topic/lookup?ctx=en/solutions&amp;id=universal-link-name" locktitle="yes" navtitle="Source Zip" scope="external" /></sch:assert>
        </sch:rule>
    </sch:pattern>
    
   <sch:pattern>
       <sch:p>In Solutions, topics should not contain conditions.</sch:p>
       <sch:rule id="UA025" context="node()[@audience | @platform | @product | @deliveryTarget | @otherprops | @props]">
        <sch:report test="@audience | @platform | @product | @deliveryTarget | @otherprops | @props" role="warning">UA025: The <sch:name/> element contains one or more conditions. Use conditions sparingly.</sch:report>
    </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>If only one link to a solution is in an Explore More Solutions topic, it cannot be placed in a list.</sch:p>
        <sch:rule id="UA032" context="*[contains(@class, ' topic/topic ')][starts-with(title, 'Explore More Solutions')]//*[contains(@class, ' topic/xref ')]">
            <sch:let name="linkCount" value="count(//*[contains(@class, ' topic/xref ')])"></sch:let>
            <sch:report test="($linkCount = 1) and parent::li" role="error" sqf:fix="Convert2Text">UA032: There is only one child element in the list.</sch:report>
            <sqf:fix id="Convert2Text">
                <sqf:description>
                    <sqf:title>Remove the parent list element and convert to a paragraph.</sqf:title>
                </sqf:description>
                <sch:let name="orphan" value="." />
                <sqf:replace match="ancestor::*[contains(@class, ' topic/ul ')][1]">
                    <p><sch:value-of select="$orphan" /></p>
                </sqf:replace>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>Product names within topic content must be conrefs.</sch:p>
        <sch:rule id="UA049" context="text()[not(parent::node()/name() = $excluded-elements)]">
            <sch:report test="contains(., ' Service ')" role="warning">UA049: Product names must be conrefs.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        
        <sch:rule id="ORCL000" context="processing-instruction('ORACLE-exception')">
            <sch:let name="part1" value="substring-after(., 'IA=&quot;')" />
            <sch:let name="IA" value="substring-before($part1, '&quot; approvalID')" />
            
            <sch:assert test="$approvers//IA[normalize-space(.) =$IA ]" role="error" sqf:fix="removeOverride">ORCL000 [Unacceptable]: The approver must be one of the following: <sch:value-of select="$approvers" />
            </sch:assert>
        <sqf:fix id="removeOverride">
                <sqf:description>
                    <sqf:title>Remove the override process instruction.</sqf:title>
                    <sqf:p>Contact the Information Architect if you need further help.</sqf:p>
                </sqf:description>
                <sqf:delete match="." />
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <!-- Images -->
        <sch:rule id="image" context="image">
            <sch:report test="alt and longdescref">Image may have either alt or longdescref but not both</sch:report>
            <sch:assert test="alt or longdescref">Image must have alt text or description topic</sch:assert>
        </sch:rule>
        <!-- Table row header present -->
        <sch:rule id="tableCol1" context="table[not(@conref)]//row">
            <sch:assert test="string-length(entry[1]) > 0">Column 1 may not be blank</sch:assert>
        </sch:rule>
        <!-- Table desc present and has at least 6 characters -->
        <sch:rule id="tableDesc" context="table[not(@conref)]">
            <sch:assert test="desc" sqf:fix="addTableDesc">Table description missing</sch:assert>
            <sch:assert test="desc and string-length(desc) > 5">Table description is too short</sch:assert>
            <!--<sqf:fix id="addTableDesc">
                <sqf:description>
                    <sqf:title>Add the 'desc' element</sqf:title>
                </sqf:description>
                <sqf:add node-type="element" target="desc"></sqf:add>
            </sqf:fix>-->
            <sqf:fix id="addTableDesc">
                <sqf:description>
                    <sqf:title>Add the 'desc' element</sqf:title>
                </sqf:description>
                <sqf:user-entry name="tdesc" type="xs:string">
                    <sqf:description>
                        <sqf:title>Enter a table description</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:add node-type="element" target="desc" select="$tdesc"></sqf:add>
            </sqf:fix>
        </sch:rule>
        <!-- Short description  -->
        <!--<sch:rule context="shortdesc">
            <sch:assert test="string-length(.) &lt; 81">Short description cannot exceed 80 characters</sch:assert>
        </sch:rule>-->
    </sch:pattern>
    <sch:pattern>
        <sch:rule id="menucascade" context="*">
            <sch:report test="menucascade">Do not use Menucascade. The output is not accessible.</sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>