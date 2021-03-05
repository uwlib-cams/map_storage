<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" version="3.0">

    <xsl:output method="xml" indent="yes"/>
    
    <!-- KEYS -->
    <xsl:key name="rdaW" match="rdf:Description" use="substring-before(@rdf:about, 'P*****')"/>
        
    <!-- VARS FOR KEY SUBTREES -->
    <xsl:variable name="rdaWUrl" select="doc('http://www.rdaregistry.info/xml/Elements/w.xml')"/>

    <!-- TEMPLATES -->

    <xsl:template match="/">
        <xsl:result-document href="../test003_map_storage.xml">
            <mapStorage>
                <!-- Hard-code WAU as application profile ID -->
                <ap_id>WAU</ap_id>
                <xsl:apply-templates select="sources/source"/>
            </mapStorage>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="sources/source">
        <propSet>
            <xsl:apply-templates select="key('rdaW', propertyStem, $rdaWUrl)"/><!-- problem: I need to iterate through all of the entities, this select attr just gets me to Work props...  -->
        </propSet>
    </xsl:template>

    <xsl:template match=""><!-- another problem -->
        <propSet_id>
            <xsl:text>THIS IS A TEST</xsl:text>
        </propSet_id>
    </xsl:template>

</xsl:stylesheet>
<!-- 
    
    /rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]
    
    The problem which remains is:
        For building propSets in the future, different XPath formulations may be needed to access the desired information;
        certain XPath formulations will need to be associated with different sources
        (for example, pulling schema.org props from a schema.org source, BF props from a BF source, etc.)
        So I'd like to store XPaths in vars...
        ***
        xsl:evaluate? See: libraryNotes/xslt/var_XPath.xsl
        fn: expression? See: https://www.saxonica.com/html/documentation/functions/saxon/expression.html
        fn:evaluate?? See: https://www.saxonica.com/html/documentation/functions/saxon/evaluate.html
        something else???
-->
