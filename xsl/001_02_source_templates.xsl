<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:dcam="http://purl.org/dc/dcam/" xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:owl="http://www.w3.org/2002/07/owl#" version="3.0">

    <!-- get RDA Registry properties -->
    <xsl:template name="get_rda">
        <xsl:param name="get_set"/>
            <source_version>
                <xsl:value-of select="document($get_set/uwmaps:set_source)/rdf:RDF/owl:Ontology/owl:versionInfo"/>     
            </source_version>
        <xsl:for-each select="
                document($get_set/uwmaps:set_source)/rdf:RDF/rdf:Description
                [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
            <prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                localid_prop="{concat('uwmaps_', $get_set/uwmaps:set_name,
                    translate(substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'), '/', '_'),
                    '_prop_', generate-id())}">
                <prop_iri iri="{@rdf:about}"/>
                <prop_label xml:lang="en">
                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                </prop_label>
                <!-- should domain and range be for-each? -->
                <xsl:if test="rdfs:domain = node()">
                    <prop_domain iri="{rdfs:domain/@rdf:resource}"/>
                </xsl:if>
                <xsl:if test="rdfs:range = node()">
                    <prop_range iri="{rdfs:range/@rdf:resource}"/>
                </xsl:if>
                <!-- TO DO:
                        Bring in <prop_related_url> values
                        No Toolkit URLs available in current RDF/XML
                        Need to bring in from another source, see alignRDA2TK -->
            </prop>
        </xsl:for-each>
    </xsl:template>

    <!-- get RDA Extension properties -->
    <xsl:template name="get_uwRdaExtension">
        <xsl:param name="get_set"/>
        <xsl:for-each-group select="document($get_set/uwmaps:set_source)/rdf:RDF/rdf:Description"
            group-by="@rdf:about">
            <xsl:for-each select="
                    current-group()
                    [rdf:type/@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']">
                <prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                    localid_prop="{concat('uwmaps_', $get_set/uwmaps:set_name, '_',
                    substring-after(@rdf:about, 'https://doi.org/10.6069/uwlib.55.d.4#'),
                    '_prop_', generate-id())}">
                    <prop_iri iri="{@rdf:about}"/>
                    <prop_label xml:lang="en">
                        <xsl:value-of select="current-group()/rdfs:label[@xml:lang = 'en']"/>
                    </prop_label>
                    <xsl:if test="current-group()/rdfs:domain">
                        <xsl:for-each select="current-group()/rdfs:domain">
                            <prop_domain iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="current-group()/rdfs:range">
                        <xsl:for-each select="current-group()/rdfs:range">
                            <prop_range iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                </prop>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>

    <!-- get Dublin Core Terms -->
    <xsl:template name="get_dcTerms">
        <xsl:param name="get_set"/>
        <xsl:for-each-group select="document($get_set/uwmaps:set_source)/rdf:RDF/rdf:Description"
            group-by="@rdf:about">
            <xsl:for-each select="
                    current-group()
                    [rdf:type/@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']">
                <prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                    localid_prop="{concat('uwmaps_', $get_set/uwmaps:set_name, '_',
                    substring-after(@rdf:about, 'http://purl.org/dc/terms/'),
                    '_prop_', generate-id())}">
                    <prop_iri iri="{@rdf:about}"/>
                    <prop_label xml:lang="en">
                        <xsl:value-of select="current-group()/rdfs:label[@xml:lang = 'en']"/>
                    </prop_label>
                    <xsl:if test="current-group()/rdfs:domain">
                        <xsl:for-each select="current-group()/rdfs:domain">
                            <prop_domain iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="current-group()/dcam:domainIncludes">
                        <xsl:for-each select="current-group()/dcam:domainIncludes">
                            <prop_domain_includes iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="current-group()/rdfs:range">
                        <xsl:for-each select="current-group()/rdfs:range">
                            <prop_range iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="current-group()/dcam:rangeIncludes">
                        <xsl:for-each select="current-group()/dcam:rangeIncludes">
                            <prop_range_includes iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                </prop>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>

    <!-- get PROV object properties -->
    <!-- [!] only retrieves object properties! -->
    <xsl:template name="get_prov">
        <xsl:param name="get_set"/>
        <xsl:for-each select="document($get_set/uwmaps:set_source)/rdf:RDF/owl:ObjectProperty">
            <prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                localid_prop="{concat('uwmaps_', $get_set/uwmaps:set_name, '_',
                substring-after(@rdf:about, 'http://www.w3.org/ns/prov#'),
                '_prop_', generate-id())}">
                <prop_iri iri="{@rdf:about}"/>
                <prop_label xml:lang="en">
                    <xsl:value-of select="rdfs:label"/>
                </prop_label>
                <xsl:if test="rdfs:domain/@rdf:resource">
                    <xsl:for-each select="rdfs:domain[@rdf:resource]">
                        <prop_domain iri="{@rdf:resource}"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="rdfs:range/@rdf:resource">
                    <xsl:for-each select="rdfs:range[@rdf:resource]">
                        <prop_range iri="{@rdf:resource}"/>
                    </xsl:for-each>
                </xsl:if>
            </prop>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
