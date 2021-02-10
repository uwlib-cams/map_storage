<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    version="3.0">

    <xsl:output indent="yes"/>

    <xsl:template match="/">
        <mapStorage>
            <id_ap>WAU</id_ap>
            <xsl:apply-templates select="propSets/set"/>
        </mapStorage>
    </xsl:template>

    <xsl:template match="propSets/set">
        <xsl:param name="set" select="."/>
        <xsl:variable name="docURL">
            <xsl:choose>
                <xsl:when test="$set = 'rdaWork'">https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml</xsl:when>
                <xsl:when test="$set = 'rdaExpression'">https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml</xsl:when>
                <xsl:when test="$set = 'rdaManifestation'">https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml</xsl:when>
                <xsl:when test="$set = 'rdaItem'">https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/i.xml</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <propSet>
            <xsl:text>Will this even work?? </xsl:text>
            <!-- This is amazing; I did NOT expect this to work -->
            <!-- Test use of each file by pulling a simple value here -->
            <xsl:value-of select="document($docURL)/rdf:RDF/rdf:Description/dc:title"/>
            <!-- The problem which remains is:
                For building propSets in the future, different XPath formulations may be needed to access the desired information;
                certain XPath formulations will need to be associated with different sources
                (for example, pulling schema.org props from a schema.org source, BF props from a BF source, etc. -->
        </propSet>
    </xsl:template>

</xsl:stylesheet>
