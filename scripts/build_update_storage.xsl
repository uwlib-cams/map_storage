<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>

    <!-- Include named templates -->
    <xsl:include href="build_update_storage_namedTemplates.xsl"/>

    <!-- Store RDA Registry prop files in vars (just a couple for testing; 13 total for implementation later) -->
    <xsl:variable name="rda_Work"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/v4.0.7/xml/Elements/w.xml')"/>
    <xsl:variable name="rda_Expression"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/v4.0.7/xml/Elements/e.xml')"/>
    <xsl:variable name="rda_Manifestation"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml')"/>

    <xsl:template match="/">
        <!-- BMR: href filepath is built from command-line location (map_storage root directory, to run build_update.py) -->
        <xsl:result-document href="build_update_output.xml">
            <mapStorage xmlns="https://uwlib-cams.github.io/map_storage/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/ https://uwlib-cams.github.io/map_storage/map_storage.xsd"
                mapid_institution="WAU">

                <!-- RDA Registry prop set - Work props -->
                <xsl:call-template name="rda_prop_set">
                    <xsl:with-param name="root" select="."/>
                    <xsl:with-param name="prop_set" select="'rda_Work'"/>
                    <xsl:with-param name="path_to_prop"
                        select="
                            $rda_Work/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]"
                    />
                </xsl:call-template>

                <!-- RDA Registry prop set - Expression props
                <xsl:call-template name="rda_prop_set">
                    <xsl:with-param name="root" select="."/>
                    <xsl:with-param name="prop_set" select="'rda_Expression'"/>
                    <xsl:with-param name="path_to_prop"
                        select="
                            $rda_Expression/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]"
                    />
                </xsl:call-template>
                
                RDA Registry prop set - Manifestation props
                <xsl:call-template name="rda_prop_set">
                    <xsl:with-param name="root" select="."/>
                    <xsl:with-param name="prop_set" select="'rda_Manifestation'"/>
                    <xsl:with-param name="path_to_prop"
                        select="
                        $rda_Manifestation/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                        [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]"
                    />
                </xsl:call-template> -->

            </mapStorage>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
