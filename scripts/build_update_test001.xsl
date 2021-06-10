<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    version="3.0">

    <!-- Process XML source document propSet_tree.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:result-document href="../map_storage_test001.xml">
            <mapStorage xmlns="https://uwlib-cams.github.io/map_storage/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/ https://uwlib-cams.github.io/map_storage/map_storage.xsd">
                <ap_id>WAU</ap_id>
                <xsl:apply-templates select="propSets/set"/>
            </mapStorage>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="propSets/set">
        <xsl:param name="set" select="."/>
        <!-- VARIABLE for document URLs -->
        <xsl:variable name="docURL">
            <xsl:choose>
                <xsl:when test="$set = 'rda_Work'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml</xsl:when>
                <xsl:when test="$set = 'rda_Expression'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml</xsl:when>
                <xsl:when test="$set = 'rda_Manifestation'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml</xsl:when>
                <xsl:when test="$set = 'rda_Item'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/i.xml</xsl:when>
                <xsl:when test="$set = 'rda_Agent'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml</xsl:when>
                <xsl:when test="$set = 'rda_Nomen'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/n.xml</xsl:when>
                <xsl:when test="$set = 'rda_Place'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/p.xml</xsl:when>
                <xsl:when test="$set = 'rda_Rda/OnixFrameworkElementSet'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/rof.xml</xsl:when>
                <xsl:when test="$set = 'rda_Timespan'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/t.xml</xsl:when>
                <xsl:when test="$set = 'rda_Unconstrained'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/u.xml</xsl:when>
                <xsl:when test="$set = 'rda_Entity'"
                    >https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/x.xml</xsl:when>
                <xsl:otherwise>
                    <!-- Is there some way to get Saxon to throw an error here? 
                        Otherwise I don't know what good this otherwise will do; I believe that any other $set value would just result in an empty propSet -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Start result elements -->
        <propSet xmlns="https://uwlib-cams.github.io/map_storage/">
            <propSet_id>
                <xsl:value-of select="."/>
            </propSet_id>
            <!-- Filter deprecated props -->
            <xsl:for-each select="document($docURL)/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <!-- Generate property ID -->
                <prop pid="{concat($set, '_', substring-after(@rdf:about, 'http://rdaregistry.info/Elements/'))}">
                    <prop_iri>
                        <xsl:value-of select="@rdf:about"/>
                    </prop_iri>
                    <prop_label xml:lang="en">
                        <xsl:value-of select="rdfs:label[@xml:lang='en']"/>
                    </prop_label>
                    <xsl:if test="rdfs:domain = node()">
                        <prop_domain iri="{rdfs:domain/@rdf:resource}"/>
                    </xsl:if>
                    <xsl:if test="rdfs:range = node()">
                        <prop_range iri="{rdfs:range/@rdf:resource}"/>
                    </xsl:if>
                    <!-- 
                        TO DO
                        Bring in <prop_related_url> values
                        No Toolkit URLs available in current RDF/XML
                        Need to bring in from another resource, see alignRDA2TK 
                    -->
                </prop>
            </xsl:for-each>
        </propSet>
    </xsl:template>
    
    <!-- The problem which remains is:
                For building propSets in the future, different XPath formulations may be needed to access the desired information;
                certain XPath formulations will need to be associated with different sources
                (for example, pulling schema.org props from a schema.org source, BF props from a BF source, etc. -->
</xsl:stylesheet>
