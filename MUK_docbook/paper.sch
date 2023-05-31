<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- NAMESPACE DECLARATIONS -->

    <ns uri="http://docbook.org/ns/docbook" prefix="d"/>
    <ns uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
    
    <!-- GLOBAL VARIABLES -->
    
    <let name="bib-ids" value="//d:bibliography//@xml:id"/>
    <let name="bib-items" value="//d:bibliography//(d:bibliomixed|d:biblioentry)"/>
    
    <!-- KEYS -->
    
    <xsl:key name='xref-target' match='*' use='@xml:id'/> 
    
    <!-- ABSTRACT PATTERNS -->
    
    <pattern id="leading-whitespace" abstract="true">
        <rule context="$element">
            <report test="matches(., '^[\p{Zs}\s]')" role="warning"><name/> should not begin with whitespace</report>
        </rule>
    </pattern>
    
    <pattern id="trailing-whitespace" abstract="true">
        <rule context="$element">
            <report test="matches(., '[\p{Zs}\s]$')" role="warning"><name/> should not end with whitespace</report>
        </rule>
    </pattern>
    
    <pattern id="trailing-punctuation" abstract="true">
        <rule context="$element">
            <report test="matches(normalize-space(.), '[\.,:;]$')" role="warning"><name/> should not end with punctuation</report>
        </rule>
    </pattern>
    
    <!-- CONCRETE PATTERNS -->
    
    <pattern is-a="leading-whitespace">
        <param name="element" value="d:programlisting | d:screen | d:synopsis | d:title"/>
    </pattern>
    
    <pattern is-a="trailing-whitespace">
        <param name="element" value="d:programlisting | d:screen | d:synopsis | d:biblioid | d:title"/>
    </pattern>
    
    <pattern id="programlisting">
        <rule context="d:programlisting | d:screen | d:synopsis">
            <sqf:fix id="programlisting-xml">
                <sqf:description>
                    <sqf:title>Sets the language to 'xml'</sqf:title>
                </sqf:description>
                <sqf:add match="." node-type="attribute" target="language">xml</sqf:add>
            </sqf:fix>
            <assert test="@language" role="warning" sqf:fix="programlisting-xml"><name/> should have a language attribute where possible, to enable syntax highlighting</assert>
        </rule>
        <rule context="d:programlisting/@language | d:screen/@language | d:synopsis/@language">
            <let name="allowed-langs" value="tokenize('bourne
                c
                cmake
                cpp
                csharp
                css
                delphi
                diff3
                ini
                java
                javascript
                lua
                m2
                perl
                php
                python
                ruby
                sql1999
                sql2003
                sql92
                tcl
                upc
                xml
                xquery', '\s+')"/>
            <assert test=". = $allowed-langs" role="warning">Value of language attribute should be one of: <value-of select="string-join($allowed-langs, ', ')"/>; got '<value-of select="."/>'</assert>            
        </rule>
        <rule context="d:programlisting/d:co | d:screen/d:co | d:synopsis/d:co">
            <sqf:fix id="callout-spacing">
                <sqf:description>
                    <sqf:title>Inserts space before callouts in programlistings</sqf:title>
                </sqf:description>
                <!-- @xml:space is required here to force the whitespace-only text node to be added by the QuickFix;
                wrapping it in <xsl:text> also works, but in oXygen 21.0 at least, it monkeys with the indentation -->
                <sqf:add match="." position="before" xml:space="preserve"> </sqf:add>
            </sqf:fix>
            <assert test="preceding-sibling::node()[self::text() or self::*][matches(., '\s$')]" role="warning" sqf:fix="callout-spacing"><name/> should be preceded by whitespace</assert>
        </rule>
    </pattern>
    
    <pattern id="whole-element-emphasis">
        <rule context="d:title | d:personname">
            <sqf:fix id="remove-emphasis">
                <sqf:description>
                    <sqf:title>Strips whole-element emphasis</sqf:title>
                </sqf:description>
                <sqf:replace match="d:emphasis">
                    <sqf:copy-of select="node()"/>
                </sqf:replace>
            </sqf:fix>
            <report test="count(*) = 1 and node()[1][self::d:emphasis] and node()[last()][self::d:emphasis]" sqf:fix="remove-emphasis"><name/> must not be entirely wrapped in emphasis</report>
        </rule>
    </pattern>
    
    <pattern id="bibliography">
        <rule context="d:xref">
            <sqf:fix id="rename-xref">
                <sqf:description>
                    <sqf:title>Replaces element xref with biblioref</sqf:title>
                </sqf:description>
                <sqf:replace match="." node-type="element" target="biblioref">
                    <sqf:copy-of select="@*"/>
                </sqf:replace>
            </sqf:fix>
            <report test="@linkend = $bib-ids" sqf:fix="rename-xref">Cross-references to bibliography entries must use biblioref rather than <name/></report>
        </rule>
        <rule context="d:citation">
            <assert test=". = $bib-items/d:abbrev">Content of <name/> must match that of an abbrev element in the bibliography: '<value-of select="."/>' not found</assert>
        </rule>
        <rule context="d:bibliography">
            <let name="xreflabels" value="$bib-items/(@xreflabel|d:abbrev)"/>
            <assert test="count(distinct-values($xreflabels)) = count($xreflabels)">Bibliography contains multiple instances of the same xreflabel attribute or abbrev element; please make sure that they are distinct, as this will result in the same label appearing for different items</assert>
        </rule>
    </pattern>
    
    <pattern id="bib-titles" is-a="trailing-punctuation">
        <param name="element" value="d:bibliomixed/d:title | d:biblioentry/d:title"/>
    </pattern>
    
    <pattern id="article-metadata">
        <rule context="d:article/d:info">
            <assert test="d:abstract" role="warning">Element abstract should be present</assert>
        </rule>
    </pattern>
    
    <pattern id="listitems">
        <rule context="d:listitem/d:para[not(*)]" id="empty-listitem">
            <assert test="normalize-space()"><name path=".."/>/<name/> must not be empty</assert>
        </rule>
        <rule context="d:listitem">
            <report test="@remap">Please use attribute override instead of remap='<value-of select="@remap"/>'</report>
        </rule>
    </pattern>
    
    <pattern id="auto-generated-titles">
        <rule context="d:appendix">
            <report test="matches(d:title, '^Appendix [A-Z]?')"><name/> titles must not begin with 'Appendix [label]': <value-of select="d:title"/></report>
        </rule>
    </pattern>
    
    <pattern id="anchored-para-pseudo-footnote">
        <rule context="d:para/d:anchor">
            <report test="not(preceding-sibling::node())
                and following-sibling::node()[1][self::text()][matches(., '\[[0-9]+\]')]
                and following-sibling::d:link[@xlink:href]">This looks like a footnote: please use element footnote instead</report>
        </rule>
    </pattern>
    
    <pattern id="caption-vs-figure-title">
        <rule context="d:mediaobject[d:textobject and d:caption]">
            <report test="d:caption[starts-with(normalize-space(.), normalize-space(../d:textobject))]">Please use figure instead here and move the content of <name/>/caption into its title</report>
        </rule>
    </pattern>
    
    <pattern id="root-element">
        <rule context="/">
            <assert test="d:article">The root element must be article</assert>
        </rule>
    </pattern>
    
    <pattern id="xref">
        <rule context="d:xref">
            <let name="target" value="key('xref-target', @linkend)"/>
            <assert test="$target/(d:info/d:title|d:title)">Cross-references must be to an element with a title - please either add a title or use element link with text content instead; see element with xml:id='<value-of select="@linkend"/>'</assert>
        </rule>
    </pattern>
    
</schema>
