<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/" version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <!-- Include named templates -->
    <xsl:include href="rda_template.xsl"/>

    <!-- Store RDA Registry prop files in vars (just a couple for testing; 13 total for implementation later) -->
    <!-- TO DO iterate over these docs, don't repeat result-doc elements as below -->
    <xsl:variable name="rda_Work"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml')"/>
    <xsl:variable name="rda_Expression"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml')"/>
    <xsl:variable name="rda_Manifestation"
        select="document('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml')"/>

    <!-- TO DO iterate over the docs in vars (or something else?), don't repeat result-doc elements as below -->
    <xsl:template match="/">
        <xsl:result-document href="../../prop_set_rdacWork.xml">
            <prop_set xmlns="https://uwlib-cams.github.io/map_storage/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/ https://uwlib-cams.github.io/map_storage/map_storage.xsd">
                <xsl:call-template name="rda_properties">
                    <!-- what's the root param do again? -->
                    <xsl:with-param name="root" select="."/>
                    <xsl:with-param name="prop_set" select="'rdaWork'"/>
                    <xsl:with-param name="path_to_prop" select="
                            $rda_Work/rdf:RDF/rdf:Description
                            [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]"
                    />
                </xsl:call-template>
            </prop_set>
        </xsl:result-document>
        <xsl:result-document href="../../prop_set_rdacExpression.xml">
            <prop_set xmlns="https://uwlib-cams.github.io/map_storage/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/ https://uwlib-cams.github.io/map_storage/map_storage.xsd">
                <xsl:call-template name="rda_properties">
                    <xsl:with-param name="root" select="."/>
                    <xsl:with-param name="prop_set" select="'rdaExpression'"/>
                    <xsl:with-param name="path_to_prop" select="
                            $rda_Expression/rdf:RDF/rdf:Description
                            [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]"
                    />
                </xsl:call-template>
            </prop_set>
        </xsl:result-document>
        <xsl:result-document href="../../prop_set_rdacManifestation.xml">
            <prop_set xmlns="https://uwlib-cams.github.io/map_storage/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/ https://uwlib-cams.github.io/map_storage/map_storage.xsd">
                <xsl:call-template name="rda_properties">
                    <xsl:with-param name="root" select="."/>
                    <xsl:with-param name="prop_set" select="'rdaManifestation'"/>
                    <xsl:with-param name="path_to_prop" select="
                            $rda_Manifestation/rdf:RDF/rdf:Description
                            [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                            [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]"
                    />
                </xsl:call-template>
            </prop_set>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>