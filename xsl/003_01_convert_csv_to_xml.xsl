<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:dcam="http://purl.org/dc/dcam/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    version="2.0">
    
    <!-- TO DO 
        OUTPUT 'RDA_alignments.xml' is used by:
        003_02_add_toolkit_URLs.xsl
        005_RDA_hierarchy.xsl 
        But I cannot get this stylesheet to function -->
    <xsl:output indent="yes"/>
    <xsl:param name="csv" select="unparsed-text('https://www.rdaregistry.info/csv/Aligns/alignRDA2TK.csv')"/>
    
    <xsl:template match="/" name="convert_csv_to_xml">
        <xsl:result-document href="../xml/RDA_alignments.xml">
            <alignmentPairs>
                <xsl:for-each select="tokenize($csv, '\n')">
                    <!-- skip header row -->
                    <xsl:if test="not(position()=1)">
                        <alignmentPair>
                            <xsl:for-each select="tokenize(., ',')">
                                <xsl:choose>
                                    <!-- regex for RDA property, e.g. rdaw:P10001 -->
                                    <xsl:when test="matches(., '[r][d][a]\D[:]\D\d\d\d\d\d')">
                                        <rdaPropertyNumber><xsl:value-of select="."/></rdaPropertyNumber>
                                    </xsl:when>
                                    <!-- URL, remove carriage return at the end of string if it's there -->
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="contains(., '&#xD;')">
                                                <xsl:variable name="url" select="substring-before(., '&#xD;')"/>
                                                <rdaToolkitURL uri="{$url}"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:variable name="url" select="."/>
                                                <rdaToolkitURL uri="{$url}"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </alignmentPair>
                    </xsl:if>
                </xsl:for-each>
            </alignmentPairs>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>