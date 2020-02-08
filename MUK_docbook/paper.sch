<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <ns uri="http://docbook.org/ns/docbook" prefix="d"/>
    
    <pattern id="whitespace">
        <rule context="d:programlisting">
            <report test="matches(., '^[\p{Zs}\s]')" role="warning">Unless intended, <name/> should not begin with whitespace</report>
        </rule>
    </pattern>
    
    <pattern id="title">
        <rule context="d:title">
            <report test="count(*) = 1 and d:emphasis"><name/> must not be entirely wrapped in emphasis</report>
        </rule>
    </pattern>
    
</schema>