<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    exclude-result-prefixes="xs mapstor"
    version="2.0">
    <xsl:template match="/">
        <xsl:result-document href="../localid_log.xml">
            <localid_log>
                <xsl:for-each select="document('../map_storage_test003.xml')//mapstor:prop">
                    <property iri="{mapstor:prop_iri/@iri}" localid_prop="{@localid_prop}" localid_implementationSet="{mapstor:platformSet/mapstor:sinopia/mapstor:implementationSet/@localid_implementationSet}"/>
                </xsl:for-each>
            </localid_log>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>