<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" version="3.0">

    <xsl:output method="xml" indent="yes"/>
    
    <!-- TEMPLATES -->

    <xsl:template match="/">
        <xsl:result-document href="../test003_map_storage.xml">
            <mapStorage>
                <!-- Hard-code WAU as application profile ID -->
                <ap_id>WAU</ap_id>
                <xsl:apply-templates select="sources/source">
                    <xsl:with-param name="context" select="."/>
                </xsl:apply-templates>
            </mapStorage>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="sources/source">
        <xsl:param name="context"/>      
        <propSet>
            <propSet_id>
                <xsl:text>FIGURE THIS OUT IN A MINUTE</xsl:text>
            </propSet_id>
            <xsl:apply-templates select="document(.)/rdf:RDF/rdf:Description">
                <xsl:with-param name="context"/>
            </xsl:apply-templates>
        </propSet>
    </xsl:template>

    <xsl:template match="rdf:Description">
        <xsl:param name="context"/>
        <xsl:for-each select="document(.)/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
            <prop
                pid="test003">
                <prop_iri iri="{@rdf:about}"/>
                <prop_label xml:lang="en">
                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                </prop_label>
                <xsl:if test="rdfs:domain = node()">
                    <prop_domain iri="{rdfs:domain/@rdf:resource}"/>
                </xsl:if>
                <xsl:if test="rdfs:range = node()">
                    <prop_range iri="{rdfs:range/@rdf:resource}"/>
                </xsl:if>
            </prop>
        </xsl:for-each>
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
