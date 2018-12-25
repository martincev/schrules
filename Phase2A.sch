<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" 
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:title>UA Business Rules</sch:title>

    <sch:pattern>
		<sch:p>A &lt;shortdesc&gt; element must be between 10 and 30 words in length.</sch:p>
        <sch:rule id="UA037" context="*[contains(@class, ' topic/shortdesc ')]">
            <sch:let name="descText" value="normalize-space(string-join(child::text(), ' '))"/>
            <sch:let name="phText" value="normalize-space(string-join(child::ph, ' '))"/>
            <sch:let name="codephText" value="normalize-space(string-join(child::codeph, ' '))"/>
            <sch:let name="wordCount" value="count(tokenize($descText, '\s+')) + count(tokenize($phText, '\s+')) + count(tokenize($codephText, '\s+'))"/>
            <sch:assert test="$wordCount &lt;= 50" role="error" >
                UA037: Short description must not exceed 50 words in length. Your short description contains <xsl:value-of select="$wordCount"></xsl:value-of> words.
            </sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>

