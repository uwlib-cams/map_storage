<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sin="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs mapstor" version="2.0">
    <xsl:template match="/">
        <!-- WAU:RT:RDA:Work:monograph -->
        <xsl:result-document href="../wau_rt_rda_work_monograph.xml">
            <xsl:variable name="institution" select="'WAU'"/>
            <xsl:variable name="propSet" select="'rda_Work'"/>
            <xsl:variable name="resource" select="'Work'"/>
            <xsl:variable name="format" select="'monograph'"/>
            <xsl:call-template name="create_RT">
                <xsl:with-param name="institution" select="$institution"/>
                <xsl:with-param name="propSet" select="$propSet"/>
                <xsl:with-param name="resource" select="$resource"/>
                <xsl:with-param name="format" select="$format"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    <!--
    <ns1:hasPropertyTemplate rdf:nodeID="f278f6fe166a6436aad8ff7b90ed44122b1"/>
    <ns1:hasClass rdf:resource="http://example.com/Class001"/>
  </rdf:Description> -->
    <xsl:template name="create_RT">
        <xsl:param name="institution"/>
        <xsl:param name="propSet"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:variable name="resourceID"
            select="concat($institution, ':RT:', substring-before($propSet, '_'), ':', $resource, ':', $format)"/>
        <rdf:RDF>
            <rdf:Description rdf:about="https://api.stage.sinopia.io/resource/{$resourceID}">
                <sin:hasRemark xml:lang="eng"/>
                <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
                <sin:hasAuthor>mcm104@uw.edu</sin:hasAuthor>
                <sin:hasResourceId>
                    <xsl:value-of select="$resourceID"/>
                </sin:hasResourceId>
                <sin:hasDate>
                    <xsl:value-of select="current-date()"/>
                </sin:hasDate>
                <rdfs:label>
                    <xsl:value-of
                        select="concat($institution, ' RT ', substring-before($propSet, '_'), ' ', $resource, ' ', $format)"
                    />
                </rdfs:label>
                <sin:hasResourceTemplate>sinopia:template:resource</sin:hasResourceTemplate>
                <xsl:for-each
                    select="//mapstor:prop[mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:format/@mapid_format = $format]">
                    <sin:hasPropertyTemplate rdf:nodeID="{substring-after(@localid_prop, '/')}"/>
                </xsl:for-each>
            </rdf:Description>
            <xsl:for-each select="//mapstor:prop[mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:format/@mapid_format = $format]">
                <rdf:Description rdf:nodeID="{substring-after(@localid_prop, '/')}">
                    <!-- 
  <rdf:Description rdf:nodeID="f278f6fe166a6436aad8ff7b90ed44122b14">
    <ns1:hasResourceAttributes rdf:nodeID="f278f6fe166a6436aad8ff7b90ed44122b15"/>
    <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
    <rdfs:label xml:lang="eng">nested resource prop - no property attributes - rt id specified</rdfs:label>
    <ns1:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/resource"/>
    <ns1:hasPropertyUri rdf:resource="http://example.com/nestedResourceProp001"/>
  </rdf:Description>
                    -->
                    <beep>boop</beep>
                </rdf:Description>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>
    <xsl:template name="create_PT">
        <xsl:param name="prop_node_id"/>
    </xsl:template>
</xsl:stylesheet>
