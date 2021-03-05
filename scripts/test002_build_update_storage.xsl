<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <!-- GLOBAL* VARIABLES -->
    <!-- *Is this the right term? Are these actually global vars? -->
    
    <xsl:variable name="sources">
        <source url="https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml">rda_Work</source>
        <source url="https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml">rda_Work</source>
        <!-- <source url=""/> -->
    </xsl:variable>

    <!-- TEMPLATES -->
    
    <xsl:template match="/">
        <xsl:result-document href="../test002_map_storage.xml">
            <mapStorage>
                <!-- Hard-code WAU as application profile ID -->
                <ap_id>WAU</ap_id>
                <xsl:apply-templates select="$sources/source">
                    <xsl:with-param name="current" select="."/>
                </xsl:apply-templates>
            </mapStorage>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="$sources/source">
        <xsl:param name="current"/>
        <propSet>
            <!-- Filtering deprecated props with a second XPath predicate -->
            <xsl:apply-templates
                select="document(@url)/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:with-param name="current"/>
            </xsl:apply-templates>
        </propSet>
    </xsl:template>

    <!-- OK... The template match attribute below works even though it doesn't include the document function... -->
    <xsl:template
        match="rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
        <xsl:param name="current"/>
        
        <xsl:variable name="id">
            <xsl:value-of select="$current"/>
        </xsl:variable>
        
        <propSet_id>
            <xsl:value-of select="$id"/>
        </propSet_id>
        <prop
            pid="{concat($id, '_', substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'))}">
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
    </xsl:template>
</xsl:stylesheet>

<!--
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
