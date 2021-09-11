<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/" version="3.0">

    <!-- BMR: Started to write a key, but then didn't know how I would use it in this case -->
    <!-- key -->
    <xsl:key name="process_existing"
        match="mapstor:mapstorage/mapstor:propSet/mapstor:prop/mapstor:prop_iri" use="@iri"/>
    <!-- key var -->
    <!-- BMR: Should this path be from the location of this script, or from map_storage root dir, where build_update.py will run from?? -->
    <xsl:variable name="process_existing_xml" select="document('process_existing.xml')"/>

    <!-- Here's the template to use when pulling from RDA Registry data -->
    <xsl:template name="rda_prop_set">
        <xsl:param name="root"/>
        <xsl:param name="prop_set"/>
        <xsl:param name="path_to_prop"/>

        <propSet mapid_propSet="{$prop_set}" xmlns="https://uwlib-cams.github.io/map_storage/">
            <xsl:for-each select="$path_to_prop">
                <xsl:variable name="localid_prop"
                    select="concat($prop_set, '_', substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'))"/>
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
                    <!-- TO DO:
                        Bring in <prop_related_url> values
                        No Toolkit URLs available in current RDF/XML
                        Need to bring in from another source, see alignRDA2TK -->
                    <xsl:call-template name="copy_implementations">
                        <xsl:with-param name="data_source_iri" select="$path_to_prop/@rdf:about"/>
                        <xsl:with-param name="root" select="$root"/>
                    </xsl:call-template>
                </prop>
            </xsl:for-each>
        </propSet>
    </xsl:template>

    <!-- BMR: Attempting to carry forward existing implementations below -->
    <xsl:template name="copy_implementations">
        <xsl:param name="data_source_iri"/>
        <xsl:param name="root"/>
        <xsl:choose>
            <xsl:when test="$root/mapStorage/propSet/prop/prop_iri[@iri = $data_source_iri]/platformSet[node()]">
                <xsl:copy-of select="$root/mapStorage/propSet/prop/prop_iri[@iri = $data_source_iri]/platformSet"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>


    <!-- Add/call templates for pulling from additional data stores as needed -->

</xsl:stylesheet>
