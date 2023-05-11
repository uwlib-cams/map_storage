<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs uwmaps uwsinopia" version="3.0">

    <xsl:output method="xml" indent="1"/>
    <xsl:mode on-no-match="shallow-copy"/>

    <!-- TO DO : double-check 001_02 and then delete this 
        a 'one-off' template for updating prop @localid_prop values to align with 
    changes in prop localid generation in 001_02_source_templates.xsl -->
    
    <xsl:template match="uwmaps:prop_set/uwmaps:prop">
        <xsl:variable name="get_set" select="../uwmaps:prop_set_label"/>
                <xsl:choose>
                    <xsl:when test="matches($get_set, 'rda')">
                        <uwmaps:prop
                            localid_prop="{concat('uwmaps_', $get_set, '_',
                            translate(substring-after(uwmaps:prop_iri/@iri, 
                            'http://rdaregistry.info/Elements/'), '/', ''))}">
                            <xsl:copy-of select="node()"/>
                        </uwmaps:prop>
                    </xsl:when>
                    <xsl:when test="matches($get_set, 'uwRdaExtension')">
                        <uwmaps:prop
                            localid_prop="{concat('uwmaps_', $get_set, '_',
                            substring-after(uwmaps:prop_iri/@iri, 
                            'https://doi.org/10.6069/uwlib.55.d.4#'))}">
                            <xsl:copy-of select="node()"/>
                        </uwmaps:prop>
                    </xsl:when>
                    <xsl:otherwise>ERROR</xsl:otherwise>
                </xsl:choose>
                
    </xsl:template>

</xsl:stylesheet>
