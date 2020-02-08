<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <ns uri="http://docbook.org/ns/docbook" prefix="d"/>
    
    <pattern id="whitespace">
        <rule context="d:programlisting">
            <report test="matches(., '^[\p{Zs}\s]')" role="warning">Unless intended, <name/> should not begin with whitespace</report>
        </rule>
    </pattern>
    
</schema>