<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" 
	xmlns:sqf="http://www.schematron-quickfix.com/validator/process" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<sch:title>UA Business Rules</sch:title>

	<sch:let name="excluded-elements" value="('draft-comment', 'cmdname', 'codeblock', 'codeph', 'synph', 'synblk', 'msgph', 'msgblock', 'userinput', 'systemoutput', 'parmname', 'varname', 'apiname', 'filepath', 'uicontrol', 'option', 'wintitle', 'screen', 'pre', 'cite', 'term', 'change-summary')"/>

<sch:pattern>
	<sch:p>The title element for articles must use headline-style casing.</sch:p>
	<sch:rule id="UA007" context="*[contains(@class, ' topic/title ')]">
		<!--Ditamaps in solutions will always contain topicheads, while submaps never contain topicheads.-->
		<sch:report test="not(/descendant::*[contains(@class, ' mapgroup-d/topichead ')]) and not(matches(., '^[A-Z0-9]\S*\s*((a|an|and|at|as|but|by|for|from|in|of|or|on|the|to|with|([A-Z0-9_@#*$(){}&lt;>\[\]\.]\S*)|(\S*[A-Z0-9][A-Z0-9]\S*))\s*)*$'))" role="warning" sqf:fix="applyTitleCase">UA007: The title must use headline-style casing. </sch:report>
		<sqf:fix id="applyTitleCase">
			<sqf:description>
				<sqf:title>Apply headline-case to title text</sqf:title>
			</sqf:description>
			<sqf:replace match="child::text()">
				<xsl:for-each select="tokenize(.,' ')">
					<xsl:choose>
						<!--case: Prepositions /DPS-43024-->
						<xsl:when test="(.='a')or(.='an')or(.='and')or(.='at')or(.='but')or(.='by')or(.='for')or(.='from')or(.='in')or(.='of')or(.='on')or(.='or')or(.='the')or(.='to')or(.='with')">
							<xsl:value-of select="." />
						</xsl:when>
						<!--case:if word starts, ends with, or contains consecutive capital letters-->
						<xsl:when test="matches(., '^\S*[A-Z][A-Z]\S*$')">
							<xsl:value-of select="." />
						</xsl:when>
						<!--case:to allow words that begin and end with capital letters 'Ww*W-->
						<xsl:when test="matches(., '^[A-Z]\S*[A-Z]$')">
							<xsl:value-of select="." />
						</xsl:when>
						<!--case:to allow words that begin with a special character as defined in DPS-46306-->
						<xsl:when test="matches(., '^[A-Z0-9_@#*$(){}&lt;>\[\]\.]\S*$')">
							<xsl:value-of select="." />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="upper-case(substring(.,1,1))" />
							<xsl:value-of select="lower-case(substring(.,2))" />                                
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="position() ne last()">
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</sqf:replace>
		</sqf:fix>
	</sch:rule>
</sch:pattern>
<!---->
<sch:pattern>
	<sch:p>In solutions, "Architecture" topic should contain a diagram in image element.</sch:p>
	<sch:rule id="UA033" context="*[contains(@class, ' topic/topic ')][contains(title, 'Architecture')]">
		<sch:assert test="descendant::*[contains(@class, ' topic/image ')]" role="warning">Topic '<xsl:value-of select="title"/>' does not contain an image.</sch:assert>
	</sch:rule>
</sch:pattern>


<sch:pattern>
	<sch:p>A shortdesc element should not start with phrases such as "This topic describes...", "This topic is about...", "This section...", "This solution...", or "This Solution."</sch:p>
	<sch:rule id="UA040" context="*[contains(@class, ' topic/shortdesc ')]">
		<sch:report test="starts-with(., 'This') or starts-with(., 'In this') or contains(., 'this topic') or contains(., 'this section') or contains(., 'this solution')" role="error">The shortdesc element begins with a self-reference such as "This section...".</sch:report>
	</sch:rule>
</sch:pattern>

<sch:pattern>

	<sch:p>	A topic must not include examples of obvious passwords.</sch:p>
	<sch:rule id="UA087" context="text()">
		<!--Flag by regular expressions-->
		<sch:report test="matches(., 'password[0-9]+') or matches(., 'welcome[0-9]+') or matches(., 'weblogic[0-9]+')" role="warning">A text string includes one or more obvious passwords that must be removed or obfuscated. It is a security violation.</sch:report>
		<!--Flag by literal occurences-->
		<sch:report test="contains(., 'changeme') or contains(., 'change_on_install') or contains(., 'scott/tigger') or contains(., 'changeit') or contains(., 'mypassword') or contains(., 'mypasswd') or contains(., 'hr/hr') or contains(., 'testpassword') or contains(., 'soa/soa') or contains(., 'admin')" role="warning">A text string includes one or more obvious passwords that must be removed or obfuscated. It is a security violation.</sch:report>
	</sch:rule>
</sch:pattern>

<sch:pattern>
		<sch:p>A solutions submap (article) must not contain more than two levels of topics.</sch:p>
		<sch:rule id="UA094" context="*[contains(@class, ' map/map ')][not(topichead)]/topicref/topicref/topicref">
			<sch:assert test="count(descendant::topicref) = 0" role="warning">UA-094: The submap (article) contains more than two levels of topics.</sch:assert>
		</sch:rule>
</sch:pattern>
</sch:schema>