<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" 
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:title>Phase 2C</sch:title>

 
    <sch:let name="solutionContext" value="substring-before(substring-after(map/processing-instruction(solution), 'type=&quot;'), '&quot;')" />
 
    <sch:pattern>
        <sch:p>UA044-A: Image must have either 'alt' or 'longdescref' but not both.</sch:p>
        <sch:rule context="*[contains(@class, ' topic/image ')]">
            <sch:report test="alt and longdescref" role="error" sqf:fix="removeAlt removeLongdescref">UA044: Image may have either alt or longdescref but not both</sch:report>
            <sqf:fix id="removeAlt">
                <sqf:description>
                    <sqf:title>Delete 'alt'.</sqf:title>
                </sqf:description>
                <sqf:delete match="alt"></sqf:delete>
            </sqf:fix>
            <sqf:fix id="removeLongdescref">
                <sqf:description>
                    <sqf:title>Delete 'longdescref'.</sqf:title>
                </sqf:description>
                <sqf:delete match="longdescref"></sqf:delete>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:p>UA044-B: Image must have alt text or description topic.</sch:p>
        <sch:rule context="*[contains(@class, ' topic/image ')]">
            <sch:assert test="alt or longdescref" role="error">UA044: Image must have alt text or description topic</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:p>UA002: In a Design solution, the contents of the 'title' element must begin with "Learn"</sch:p>
        <sch:rule context="*[contains(@class, ' map/map ')]">
            <sch:report test="not(compare($solutionContext, 'Design')) and not(starts-with(child::title, 'Learn '))" role="error">In a Design solution, the contents of the 'title' element must begin with "Learn" || <xsl:value-of select="not(compare($solutionContext, 'Design'))" /> || <xsl:value-of select="$solutionContext"/></sch:report>
        </sch:rule>
    </sch:pattern>

    <sch:pattern>
        <sch:p>UA003: In a Develop, Operate, or Integrate solution, the contents of the 'title' element MUST NOT begin with "Learn".</sch:p>
        <sch:rule context="*[contains(@class, ' map/map ')]">
            <sch:assert test="(not(compare($solutionContext, 'Develop')) or not(compare($solutionContext, 'Operate')) or not(compare($solutionContext, 'Integrate'))) and not(starts-with(child::title, 'Learn '))" role="error"> In a Develop, Operate, or Integrate solution, the contents of the 'title' element MUST NOT begin with "Learn".</sch:assert>
        </sch:rule>
    </sch:pattern> 

    <sch:pattern>
        <sch:p>UA004: A Design solution should contain an "Explore" topichead..</sch:p>
        <sch:rule context="*[contains(@class, ' map/map ')]">
            <sch:report test="not(compare($solutionContext, 'Design')) and not(topichead/topicmeta/navtitle[starts-with(., 'Explore')])" role="warning"> This solution should contain an "Explore" topichead.</sch:report>
        </sch:rule>
    </sch:pattern>

</sch:schema>