<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <ns uri="http://docbook.org/ns/docbook" prefix="d"/>
    
    <pattern id="programlisting">
        <rule context="d:programlisting">
            <report test="matches(., '^[\p{Zs}\s]')" role="warning">Unless intended, <name/> should not begin with whitespace</report>
            <assert test="@language" role="warning"><name/> should have a language attribute where possible, to enable syntax highlighting</assert>
        </rule>
        <rule context="d:programlisting/@language">
            <let name="allowed-langs" value="tokenize('bourne
                c
                cmake
                cpp
                csharp
                css
                delphi
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
                xml', '\s')"/>
            <assert test=". = $allowed-langs">Value of language attribute should be one of: <value-of select="string-join($allowed-langs, ', ')"/>; got '<value-of select="."/>'</assert>            
        </rule>
    </pattern>
    
    <pattern id="title">
        <rule context="d:title">
            <report test="count(*) = 1 and d:emphasis"><name/> must not be entirely wrapped in emphasis</report>
        </rule>
    </pattern>
    
</schema>