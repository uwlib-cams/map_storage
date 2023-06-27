<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs rdf reg rdfs"
    version="2.0">

    <xsl:output method="html"/>
    <xsl:include href="https://uwlib-cams.github.io/webviews/xsl/CC0-footer.xsl"/>

    <xsl:template match="/">
        <xsl:result-document href="../html/RDA_hierarchy.html">
            <html>
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>RDA hierarchy</title>
                    <link href="https://uwlib-cams.github.io/webviews/css/RDA_hierarchy.css"
                        rel="stylesheet"/>
                    <link href="https://uwlib-cams.github.io/webviews/images/book.png" rel="icon"
                        type="image/png"/>
                </head>
                <body>
                    <h1 id="profile" class="h1">Overview of Canonical RDA/RDF Properties</h1>
                    <p><i>Note: RDA Toolkit links require an RDA Toolkit account to access</i></p>
                    <div class="list-container">
                        <ul id="BT">
                            <li>
                                <span class="caret">RDA Work Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'w'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Expression Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'e'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Manifestation Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'m'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Item Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'i'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Agent Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'a'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Person Properties</span>
                                <xsl:call-template name="sub_a">
                                    <xsl:with-param name="domain" select="'C10004'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Collective Agent Properties</span>
                                <xsl:call-template name="sub_a">
                                    <xsl:with-param name="domain" select="'C10011'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Corporate Body Properties</span>
                                <xsl:call-template name="sub_a">
                                    <xsl:with-param name="domain" select="'C10005'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Family Properties</span>
                                <xsl:call-template name="sub_a">
                                    <xsl:with-param name="domain" select="'C10008'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Nomen Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'n'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Place Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'p'"/>
                                </xsl:call-template>
                            </li>
                            <li>
                                <span class="caret">RDA Timespan Properties</span>
                                <xsl:call-template name="wemi_anpt">
                                    <xsl:with-param name="entity" select="'t'"/>
                                </xsl:call-template>
                            </li>
                        </ul>
                    </div>
                    <div>
                        <script src="https://uwlib-cams.github.io/webviews/js/RDA_hierarchy.js"/>
                    </div>
                </body>
                <xsl:call-template name="CC0-footer-rda-pages">
                    <xsl:with-param name="resource_title"
                        select="'Overview of Canonical RDA/RDF Properties'"/>
                    <xsl:with-param name="org" select="'cams'"/>
                </xsl:call-template>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="wemi_anpt">
        <xsl:param name="entity"/>
        <xsl:variable name="props" select="doc(concat('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/', $entity, '.xml'))"/>  
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each select="
                    $props/rdf:RDF/rdf:Description
                    [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                    [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- If listed ONLY as a subproperty of something not this entity, this is top-level term -->
                        <!-- if it is something else, it is a subproperty -->
                        <xsl:if test="(count(rdfs:subPropertyOf) = 1) and (rdfs:subPropertyOf[not(matches(@rdf:resource, concat('http:..rdaregistry.info.Elements.', $entity, '.P\d\d\d\d\d')))])"> 
                            <li>
                                <xsl:variable name="last_8_characters"
                                    select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                <xsl:variable name="prop_id"
                                    select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                <xsl:variable name="prop_id_end"
                                    select="substring-after($prop_id, ':')"/>
                                <xsl:variable name="subprops" select="reg:hasSubproperty[matches(@rdf:resource, concat('http:..rdaregistry.info.Elements.', $entity, '.P\d\d\d\d\d'))]"/>
                                <!-- check_deprecated returns true if property has non-deprecated subprops -->
                                <xsl:variable name="check_deprecated" select="
                                    if (every $subprop in $subprops
                                    satisfies $props/rdf:RDF/rdf:Description[@rdf:about = $subprop/@rdf:resource]
                                    [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]) then 'true' else 'false'"/>
                                <xsl:choose>
                                    <xsl:when test="(boolean($subprops) and boolean($check_deprecated = 'true')) = true()">
                                        <span class="caret">
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            <xsl:text> (</xsl:text>
                                            <a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}">
                                                <xsl:value-of select="$prop_id"/> RDA Toolkit</a>
                                            <xsl:text>)</xsl:text>
                                            <xsl:text> (</xsl:text>
                                            <a
                                                href="http://www.rdaregistry.info/Elements/{$entity}/#{$prop_id_end}">
                                                <xsl:value-of select="$prop_id"/> RDA Registry</a>
                                            <xsl:text>)</xsl:text>
                                        </span>
                                        <xsl:call-template name="find_subprops">
                                            <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                            <xsl:with-param name="entity" select="$entity"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                        (<a
                                            href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                            ><xsl:value-of select="$prop_id"/> RDA Toolkit</a>)
                                        (<a
                                            href="http://www.rdaregistry.info/Elements/{$entity}/#{$prop_id_end}">
                                            <xsl:value-of select="$prop_id"/> RDA Registry</a>)
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:variable name="prop_id_end"
                                select="substring-after($prop_id, ':')"/>
                            
                            <!-- subprops -->
                            <xsl:variable name="subprops" select="reg:hasSubproperty[matches(@rdf:resource, concat('http:..rdaregistry.info.Elements.', $entity, '.P\d\d\d\d\d'))]"/>
                            <!-- check_deprecated returns true if property has non-deprecated subprops -->
                            <xsl:variable name="check_deprecated" select="
                                if (every $subprop in $subprops
                                satisfies $props/rdf:RDF/rdf:Description[@rdf:about = $subprop/@rdf:resource]
                                [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]) then 'true' else 'false'"/>
                            <xsl:choose>
                                <xsl:when test="(boolean($subprops) and boolean($check_deprecated = 'true')) = true()">
                                    <span class="caret">
                                        <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                        <xsl:text> (</xsl:text>
                                        <a
                                            href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}">
                                            <xsl:value-of select="$prop_id"/> RDA Toolkit</a>
                                        <xsl:text>)</xsl:text>
                                        <xsl:text> (</xsl:text>
                                        <a
                                            href="http://www.rdaregistry.info/Elements/{$entity}/#{$prop_id_end}">
                                            <xsl:value-of select="$prop_id"/> RDA Registry</a>
                                        <xsl:text>)</xsl:text>
                                    </span>
                                    <xsl:call-template name="find_subprops">
                                        <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                        <xsl:with-param name="entity" select="$entity"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                    (<a
                                        href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                        ><xsl:value-of select="$prop_id"/> RDA Toolkit</a>)
                                    (<a
                                        href="http://www.rdaregistry.info/Elements/{$entity}/#{$prop_id_end}">
                                        <xsl:value-of select="$prop_id"/> RDA Registry</a>)
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template name="sub_a">
        <xsl:param name="domain"/>
        <xsl:variable name="props" 
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <xsl:variable name="prop_domain_list" select="$props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:domain/@rdf:resource = concat('http://rdaregistry.info/Elements/c/', $domain)]"/>
        <ul class="nested">
            <xsl:for-each
                select="$props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:domain/@rdf:resource = concat('http://rdaregistry.info/Elements/c/', $domain)]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <!-- if not a subprop of an element w/this domain, top level -->
                    <xsl:when test="rdfs:subPropertyOf">
                        <xsl:variable name="check_domain" select="if (every $resource in rdfs:subPropertyOf satisfies $props/rdf:RDF/rdf:Description[@rdf:about = $resource/@rdf:resource][not(rdfs:domain[@rdf:resource = concat('http://rdaregistry.info/Elements/c/', $domain)])]) then 'true' else 'false'"/>
                        <xsl:if test="$check_domain = 'true'"> 
                            <li>
                                <xsl:variable name="last_8_characters"
                                    select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                <xsl:variable name="prop_id"
                                    select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                <xsl:variable name="element_type"
                                    select="substring($last_8_characters, 1, 1)"/>
                                <xsl:variable name="prop_id_end"
                                    select="substring-after($prop_id, ':')"/>
                                <xsl:choose>
                                    <xsl:when test="reg:hasSubproperty[matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.P\d\d\d\d\d')]">
                                        <span class="caret">
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            <xsl:text> (</xsl:text>
                                            <a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}">
                                                <xsl:value-of select="$prop_id"/> RDA Toolkit</a>
                                            <xsl:text>)</xsl:text>
                                            <xsl:text> (</xsl:text>
                                            <a
                                                href="http://www.rdaregistry.info/Elements/{$element_type}/#{$prop_id_end}">
                                                <xsl:value-of select="$prop_id"/> RDA Registry</a>
                                            <xsl:text>)</xsl:text>
                                        </span>
                                        <xsl:call-template name="find_subprops">
                                            <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                            <xsl:with-param name="entity" select="'a'"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                        (<a
                                            href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                            ><xsl:value-of select="$prop_id"/> RDA Toolkit</a>)
                                        (<a
                                            href="http://www.rdaregistry.info/Elements/{$element_type}/#{$prop_id_end}">
                                            <xsl:value-of select="$prop_id"/> RDA Registry</a>)
                                    </xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:variable name="element_type"
                                select="substring($last_8_characters, 1, 1)"/>
                            <xsl:variable name="prop_id_end"
                                select="substring-after($prop_id, ':')"/>
                            <xsl:choose>
                                <xsl:when test="reg:hasSubproperty[matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.P\d\d\d\d\d')]">
                                    <span class="caret">
                                        <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                        <xsl:text> (</xsl:text>
                                        <a
                                            href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}">
                                            <xsl:value-of select="$prop_id"/> RDA Toolkit</a>
                                        <xsl:text>)</xsl:text>
                                        <xsl:text> (</xsl:text>
                                        <a
                                            href="http://www.rdaregistry.info/Elements/{$element_type}/#{$prop_id_end}">
                                            <xsl:value-of select="$prop_id"/> RDA Registry</a>
                                        <xsl:text>)</xsl:text>
                                    </span>
                                    <xsl:call-template name="find_subprops">
                                        <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                        <xsl:with-param name="entity" select="'a'"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                    (<a
                                        href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                        ><xsl:value-of select="$prop_id"/> RDA Toolkit</a>)
                                    (<a
                                        href="http://www.rdaregistry.info/Elements/{$element_type}/#{$prop_id_end}">
                                        <xsl:value-of select="$prop_id"/> RDA Registry</a>)
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template name="find_subprops">
        <xsl:param name="prop_uri"/>
        <xsl:param name="entity"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
            <ul class="nested">
                <xsl:for-each select="
                    doc(concat('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/', $entity, '.xml'))/
                    rdf:RDF/rdf:Description
                    [rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']]
                    [not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                    <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                    <xsl:variable name="subprop_uri" select="@rdf:about"/>
                    <!-- if this is a subprop of the current prop -->
                    <xsl:if test="rdfs:subPropertyOf[@rdf:resource = $prop_uri]">
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($subprop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:variable name="element_type"
                                select="substring($last_8_characters, 1, 1)"/>
                            <xsl:variable name="prop_id_end"
                                select="substring-after($prop_id, ':')"/>
                            <xsl:choose>
                                <!-- when subprop also has subprops, recursively call find_subprops -->
                                <xsl:when test="reg:hasSubproperty[matches(@rdf:resource, concat('http:..rdaregistry.info.Elements.', $entity, '.P\d\d\d\d\d'))]">
                                    <span class="caret">
                                        <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                        <xsl:text> (</xsl:text>
                                        <a
                                            href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}">
                                            <xsl:value-of select="$prop_id"/> RDA Toolkit
                                        </a>
                                        <xsl:text>)</xsl:text>
                                        <xsl:text> (</xsl:text>
                                        <a
                                            href="http://www.rdaregistry.info/Elements/{$element_type}/#{$prop_id_end}">
                                            <xsl:value-of select="$prop_id"/> RDA Registry
                                        </a>
                                        <xsl:text>)</xsl:text>
                                    </span>
                                    <xsl:call-template name="find_subprops">
                                        <xsl:with-param name="prop_uri" select="$subprop_uri"/>
                                        <xsl:with-param name="entity" select="$entity"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <!-- if it does not have subprops -->
                                <xsl:otherwise>
                                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                    <xsl:text> (</xsl:text>
                                    <a
                                        href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}">
                                        <xsl:value-of select="$prop_id"/> RDA Toolkit</a>
                                    <xsl:text>)</xsl:text>
                                    <xsl:text> (</xsl:text>
                                    <a
                                        href="http://www.rdaregistry.info/Elements/{$element_type}/#{$prop_id_end}">
                                        <xsl:value-of select="$prop_id"/> RDA Registry</a>
                                    <xsl:text>)</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
    </xsl:template>
</xsl:stylesheet>

