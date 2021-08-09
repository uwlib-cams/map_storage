<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:sin="http://sinopia.io/vocabulary/"
    exclude-result-prefixes="xs mapstor" version="2.0">
    <xsl:template match="/">
        <!-- WAU:RT:RDA:Work:monograph -->
        <xsl:variable name="institution" select="'WAU'"/>
        <xsl:variable name="propSet" select="'rda_Work'"/>
        <xsl:variable name="resource" select="'Work'"/>
        <xsl:variable name="format" select="'monograph'"/>
        <xsl:result-document href="../{$institution}_RT_{substring-before($propSet, '_')}_{$resource}_{$format}_test.xml">
            <xsl:call-template name="create_RT">
                <xsl:with-param name="institution" select="$institution"/>
                <xsl:with-param name="propSet" select="$propSet"/>
                <xsl:with-param name="resource" select="$resource"/>
                <xsl:with-param name="format" select="$format"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="create_RT">
        <xsl:param name="institution"/>
        <xsl:param name="propSet"/>
        <xsl:param name="resource"/>
        <xsl:param name="format"/>
        <xsl:variable name="resourceID"
            select="concat($institution, ':RT:', substring-before($propSet, '_'), ':', $resource, ':', $format, ':test')"/>
        <rdf:RDF>
            <!-- Resource template -->
            <rdf:Description rdf:about="https://api.stage.sinopia.io/resource/{$resourceID}">
                <sin:hasResourceTemplate>sinopia:template:resource</sin:hasResourceTemplate>
                <rdf:type rdf:resource="http://sinopia.io/vocabulary/ResourceTemplate"/>
                <sin:hasResourceId><xsl:value-of select="$resourceID"/></sin:hasResourceId>
                <sin:hasClass rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdfs:label>
                    <xsl:value-of
                        select="concat($institution, ' RT ', substring-before($propSet, '_'), ' ', $resource, ' ', $format, ' test ', format-date(current-date(), '[Y0001]-[M01]-[D01]'))"
                    />
                </rdfs:label>
                <sin:hasAuthor>mcm104@uw.edu</sin:hasAuthor>
                <sin:hasDate>
                    <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                </sin:hasDate>
                <xsl:for-each select="//mapstor:prop[mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:format/@mapid_format = $format]">
                    <xsl:sort select="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource=$resource]/mapstor:form_order"/>
                    <xsl:if test="position() = 1">
                        <xsl:call-template name="start_PT_list">
                            <xsl:with-param name="prop_node_id" select="concat(substring-after(@localid_prop, '/'), '_order')"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </rdf:Description>
            <rdf:Description rdf:about="http://rdaregistry.info/Elements/c/C10001">
                <rdfs:label>work</rdfs:label>
            </rdf:Description>
            <!-- Nodes for properties -->
            <xsl:for-each select="//mapstor:prop[mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:format/@mapid_format = $format]">
                <xsl:sort select="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource=$resource]/mapstor:form_order"/>
                <!-- List nodes -->
                <rdf:Description rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_order')}">
                    <rdf:first rdf:nodeID="{substring-after(@localid_prop, '/')}"/>
                    <xsl:choose>
                        <xsl:when test="following-sibling::mapstor:prop[mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:format/@mapid_format = $format]">
                            <rdf:rest rdf:nodeID="{concat(substring-after(following-sibling::mapstor:prop[1]/@localid_prop, '/'), '_order')}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdf:rest rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#nil"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
                <rdf:Description rdf:about="{mapstor:prop_iri/@iri}">
                    <rdfs:label><xsl:value-of select="mapstor:prop_label"/></rdfs:label>
                </rdf:Description>
                <!-- Property templates -->
                <rdf:Description rdf:nodeID="{substring-after(@localid_prop, '/')}">
                    <rdf:type rdf:resource="http://sinopia.io/vocabulary/PropertyTemplate"/>
                    <rdfs:label xml:lang="{mapstor:prop_label/@xml:lang}"><xsl:value-of select="mapstor:prop_label"/></rdfs:label>
                    <sin:hasPropertyUri rdf:resource="{mapstor:prop_iri/@iri}"/>
                    <xsl:variable name="implementationSet" select="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]"/>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:required/@value='true'">
                        <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/required"/>
                    </xsl:if>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:repeatable/@value='true'">
                        <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/repeatable"/>
                    </xsl:if>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:ordered/@value='true'">
                        <sin:hasPropertyAttribute rdf:resource="http://sinopia.io/vocabulary/propertyAttribute/ordered"/>
                    </xsl:if>
                    <xsl:if test="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes">
                        <sin:hasLiteralAttributes rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_literalAttributes')}"/>
                    </xsl:if>
                    <xsl:variable name="prop_type" select="$implementationSet/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type"/>
                    <xsl:choose>
                        <xsl:when test="$prop_type='literal'">
                            <sin:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/literal"/>
                        </xsl:when>
                        <xsl:when test="$prop_type='nested_resource'">
                            <sin:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/resource"/>
                        </xsl:when>
                        <xsl:when test="$prop_type='uri_or_lookup'">
                            <sin:hasPropertyType rdf:resource="http://sinopia.io/vocabulary/propertyType/uri"/>
                        </xsl:when>
                    </xsl:choose>
                    <sin:hasRemark xml:lang="{$implementationSet/mapstor:remark/@xml:lang}"><xsl:value-of select="$implementationSet/mapstor:remark"/></sin:hasRemark>
                </rdf:Description>
                <!-- Literal attributes -->
                <xsl:if test="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes">
                    <rdf:Description rdf:nodeID="{concat(substring-after(@localid_prop, '/'), '_literalAttributes')}">
                        <rdf:type rdf:resource="http://sinopia.io/vocabulary/LiteralPropertyTemplate"/>
                        <!-- Default value -->
                        <xsl:if test="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes/mapstor:default_literal">
                            <sin:hasDefault xml:lang="{mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes/mapstor:default_literal/@xml:lang}"><xsl:value-of select="mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/mapstor:resource[@mapid_resource = $resource]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type_attributes/mapstor:literal_attributes/mapstor:default_literal"/></sin:hasDefault>
                        </xsl:if>
                    </rdf:Description>
                </xsl:if>
            </xsl:for-each>
            <!-- Define property types -->
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type='literal'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyType/literal">
                    <rdfs:label>literal</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type='nested_resource'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyType/resource">
                    <rdfs:label>nested resource</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:sinopia_prop_type='uri_or_lookup'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyType/uri">
                    <rdfs:label>uri or lookup</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <!-- Define property attributes -->
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:required/@value='true'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyAttribute/required">
                    <rdfs:label>required</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:repeatable/@value='true'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyAttribute/repeatable">
                    <rdfs:label>repeatable</rdfs:label>
                </rdf:Description>
            </xsl:if>
            <xsl:if test="//mapstor:resource[@mapid_resource=$resource and mapstor:format/@mapid_format=$format]/mapstor:sinopia_prop_attributes/mapstor:ordered/@value='true'">
                <rdf:Description rdf:about="http://sinopia.io/vocabulary/propertyAttribute/ordered">
                    <rdfs:label>ordered</rdfs:label>
                </rdf:Description>
            </xsl:if>
        </rdf:RDF>
    </xsl:template>
    <!-- Naming first list node -->
    <xsl:template name="start_PT_list">
        <xsl:param name="prop_node_id"/>
        <sin:hasPropertyTemplate rdf:nodeID="{$prop_node_id}"/>
    </xsl:template>
</xsl:stylesheet>
