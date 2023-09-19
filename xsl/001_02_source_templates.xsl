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
    xmlns:schema="https://schema.org/"
    exclude-result-prefixes="uwmaps xs rdf reg rdfs dcam prov owl"
    version="3.0">

    <!-- get RDA Registry properties -->
    <xsl:template name="get_rda">
        <xsl:param name="get_set"/>
        <source_version xmlns="https://uwlib-cams.github.io/map_storage/xsd/">
            <xsl:value-of
                select="document($get_set/uwmaps:set_source)/rdf:RDF/owl:Ontology/owl:versionInfo"/>
        </source_version>
        <xsl:for-each select="
                document($get_set/uwmaps:set_source)/rdf:RDF/rdf:Description
                [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                (: Don't select deprecated properties :)
                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
            <prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                localid_prop="{concat('uwmaps_', $get_set/uwmaps:set_name, '_',
                    translate(substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'), '/', ''))}">
                <prop_iri iri="{@rdf:about}"/>
                <prop_label xml:lang="en">
                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                </prop_label>
                <!-- assumes max one domain/range for RDA properties -->
                <xsl:if test="rdfs:domain = node()">
                    <prop_domain iri="{rdfs:domain/@rdf:resource}"/>
                </xsl:if>
                <xsl:if test="rdfs:range = node()">
                    <prop_range iri="{rdfs:range/@rdf:resource}"/>
                </xsl:if>
            </prop>
        </xsl:for-each>
    </xsl:template>

    <!-- get RDA Extension properties -->
    <xsl:template name="get_uwRdaExtension">
        <xsl:param name="get_set"/>
        <source_version xmlns="https://uwlib-cams.github.io/map_storage/xsd/">
            <xsl:value-of
                select="document($get_set/uwmaps:set_source)/rdf:RDF/rdf:Description/schema:version"
            />
        </source_version>
        <xsl:for-each select="document($get_set/uwmaps:set_source)/rdf:RDF/rdf:Description[rdf:type/@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']">
                <prop xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                    localid_prop="{concat('uwmaps_', $get_set/uwmaps:set_name, '_',
                    substring-after(@rdf:about, 'https://doi.org/10.6069/uwlib.55.d.4#'))}">
                    <prop_iri iri="{@rdf:about}"/>
                    <prop_label xml:lang="en">
                        <xsl:value-of select="./rdfs:label[@xml:lang = 'en']"/>
                    </prop_label>
                    <xsl:if test="./rdfs:domain">
                        <xsl:for-each select="./rdfs:domain">
                            <prop_domain iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="./rdfs:range">
                        <xsl:for-each select="./rdfs:range">
                            <prop_range iri="{@rdf:resource}"/>
                        </xsl:for-each>
                    </xsl:if>
                </prop>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
