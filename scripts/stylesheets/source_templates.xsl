<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/" xmlns:dcam="http://purl.org/dc/dcam/"
    version="3.0">

    <!-- get RDA props -->
    <xsl:template name="get_rda">
        <xsl:param name="get_set"/>
        <xsl:variable name="start_localid"
            select="concat('map_storage_', $get_set/mapstor:set_name, '_')"/>
        <xsl:for-each select="
                document($get_set/mapstor:set_source)/rdf:RDF/rdf:Description
                [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
            <prop xmlns="https://uwlib-cams.github.io/map_storage/"
                localid_prop="{concat($start_localid, 
                    substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'))}">
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
                <!-- TO DO:
                        Bring in <prop_related_url> values
                        No Toolkit URLs available in current RDF/XML
                        Need to bring in from another source, see alignRDA2TK -->
            </prop>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get_dcTerms">
        <xsl:param name="get_set"/>
        <xsl:variable name="start_localid"
            select="concat('map_storage_', $get_set/mapstor:set_name, '_')"/>
        <xsl:for-each-group select="document($get_set/mapstor:set_source)/rdf:RDF/rdf:Description"
            group-by="@rdf:about">
            <xsl:for-each
                select="current-group()[rdf:type/@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']">
                <prop xmlns="https://uwlib-cams.github.io/map_storage/"
                    localid_prop="{concat($start_localid, 
                    substring-after(@rdf:about, 'http://purl.org/dc/terms/'))}">
                    <prop_iri iri="{@rdf:about}"/>
                    <prop_label xml:lang="en">
                        <xsl:value-of select="current-group()/rdfs:label[@xml:lang = 'en']"/>
                    </prop_label>
                    
                    <!-- NOT FUNCTIONING FROM HERE DOWN -->
                    
                    <xsl:if test="current-group()/../rdf:Description/rdfs:domain/node()">
                        <xsl:for-each select="current-group()/../rdf:Description/rdfs:domain/@rdf:resource">
                            <prop_domain iri="{.}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="dcam:domainIncludes">
                        <!-- need change to map_storage schema for this -->
                        <xsl:for-each select="dcam:domainIncludes/@rdf:resource">
                            <prop_domain_includes iri="{.}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="rdfs:range = node()">
                        <xsl:for-each select="rdfs:range/@rdf:resource">
                            <prop_range iri="{.}"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="dcam:rangeIncludes/@rdf:resource">
                        <xsl:for-each select="dcam:rangeIncludes/@rdf:resource">
                            <prop_range_includes iri="{.}"/>
                        </xsl:for-each>
                    </xsl:if>
                </prop>
            </xsl:for-each>
        </xsl:for-each-group>
    </xsl:template>

</xsl:stylesheet>
