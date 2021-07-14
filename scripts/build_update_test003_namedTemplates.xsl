<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" version="3.0">

    <!-- Here's the template to use when pulling from RDA Registry data -->
    <xsl:template name="rda_prop_set">
        <xsl:param name="prop_set"/>
        <xsl:param name="path_to_prop"/>

        <propSet mapid_propSet="{$prop_set}" xmlns="https://uwlib-cams.github.io/map_storage/">
            <xsl:for-each select="$path_to_prop">
                <xsl:variable name="localid_prop" select="concat($prop_set, '_', substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'))"/>
                <prop xmlns="https://uwlib-cams.github.io/map_storage/"
                    localid_prop="{$localid_prop}">
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
                    <platformSet>
                        <sinopia>
                            <xsl:choose>
                                <!-- if property has localid_implementationSet recorded in log, use that -->
                                <xsl:when test="document('../localid_log.xml')/localid_log/property/@localid_prop=$localid_prop">
                                    <xsl:variable name="localid_implementationSet" select="document('../localid_log.xml')/localid_log/property[@localid_prop=$localid_prop]/@localid_implementationSet"/>
                                    <implementationSet localid_implementationSet='{$localid_implementationSet}'></implementationSet>
                                </xsl:when>
                                <!-- else, generate new -->
                                <xsl:otherwise>
                                    <implementationSet localid_implementationSet='{generate-id()}'></implementationSet>
                                </xsl:otherwise>
                            </xsl:choose>
                        </sinopia>
                    </platformSet>
                    <!-- TO DO:
                        Bring in <prop_related_url> values
                        No Toolkit URLs available in current RDF/XML
                        Need to bring in from another source, see alignRDA2TK -->
                </prop>
            </xsl:for-each>
        </propSet>
    </xsl:template>

    <!-- Add/call templates for pulling from additional data stores as needed -->

</xsl:stylesheet>
