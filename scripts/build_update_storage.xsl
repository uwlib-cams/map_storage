<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    version="3.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:result-document href="../map_storage.xml">
            <!-- QUESTION/TO-DO: Is a namespace needed for mapStorage elements? Related to schema considerations?? -->
            <mapStorage>
                <id_ap>WAU</id_ap>
                <xsl:apply-templates select="propSets/set"/>
            </mapStorage>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="propSets/set">
        <xsl:param name="set" select="."/>
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
        <xsl:variable name="id_propSet">
            <xsl:choose>
                <xsl:when
                    test="$set = 'rda_Work' or 'rda_Expression' or 'rda_Manifestation' or 'rda_Item' or 'rda_Agent' or 'rda_Nomen' or 'rda_Place' or 'rda_Rda/OnixFrameworkElementSet' or 'rda_Timespan' or 'rda_Unconstrained' or 'rda_Entity'"
                    >rda</xsl:when>
                <!-- Not sure whether this otherwise functions -->
                <xsl:otherwise>
                    <xsl:text>ERROR: Unexpected &lt;set&gt;value in propSet.xml</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <propSet>
            <id_propSet>
                <xsl:value-of select="$id_propSet"/>
            </id_propSet>
            <!-- Filter deprecated props here? -->
            <xsl:for-each select="document($docURL)/rdf:RDF/rdf:Description[rdf:type[@rdf:resource='http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]">
                <prop lid="lidToDo">
                    <prop_iri>
                        <xsl:value-of select="@rdf:about"/>
                    </prop_iri>
                    <prop_label>
                        <!-- Need to add lang tag to output here -->
                        <xsl:value-of select="rdfs:label[@xml:lang='en']"/>
                    </prop_label>
                    <!-- Need to account for domain OR no domain here -->
                    <prop_domain></prop_domain>
                    <!-- Need to account for range OR no range here -->
                    <prop_range></prop_range>
                    <!-- Need to account for TK URL *or* not TK URL here -->
                    <prop_related_url>
                        <!-- Need to bring in from another resource, see alignRDA2TK -->
                    </prop_related_url>
                </prop>
            </xsl:for-each>
        </propSet>
    </xsl:template>
    <!-- The problem which remains is:
                For building propSets in the future, different XPath formulations may be needed to access the desired information;
                certain XPath formulations will need to be associated with different sources
                (for example, pulling schema.org props from a schema.org source, BF props from a BF source, etc. -->
</xsl:stylesheet>
