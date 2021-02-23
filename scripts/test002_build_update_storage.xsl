<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <!-- VARS -->
    <xsl:variable name="sources">
        <source url="https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml"/> 
        <source url="https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml"/>
        <!-- <source url=""/> -->
    </xsl:variable>
    <xsl:variable name="propSet_id">
        <xsl:choose>
            <xsl:when test="$sources/source[@url = 'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml']">rda_Work</xsl:when>
            <xsl:when test="$sources/source[@url = 'https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml']">rda_Expression</xsl:when>
            <!-- <xsl:when test="$sources/source = ''"></xsl:when> -->
        </xsl:choose>
    </xsl:variable>

    <!-- TEMPLATE(S) -->
    <xsl:template match="/">
        <xsl:result-document href="../test002_map_storage.xml">
            <xsl:variable name="context" select="."/>
            <mapStorage>
                <ap_id>WAU</ap_id>
                <xsl:for-each select="$sources/source">
                    <propSet>
                        <propSet_id>
                            <xsl:value-of select="id"/>
                        </propSet_id>
                        <!-- Filtering deprecated props with a second XPath predicate -->
                        <xsl:for-each
                            select="document(@url)/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                            <prop
                                pid="{concat($propSet_id, '_', substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'))}">
                                <prop_iri>
                                    <xsl:value-of select="@rdf:about"/>
                                </prop_iri>
                                <prop_label xml:lang="en">
                                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                </prop_label>
                                
                            </prop>
                        </xsl:for-each>
                    </propSet>
                </xsl:for-each>
            </mapStorage>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>

<!-- The problem which remains is:
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
