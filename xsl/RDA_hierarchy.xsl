<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="xs rdf reg rdfs"
    version="2.0">
    <xsl:template match="/">
        <div>
            <link href="RDA_hierarchy.css" rel="stylesheet"/>
            <ul id="BT">
                <li>
                    <span class="caret">RDA Work Properties</span>
                    <xsl:call-template name="work"/>
                </li>
                <li>
                    <span class="caret">RDA Expression Properties</span>
                    <xsl:call-template name="expression"/>
                </li>
                <li>
                    <span class="caret">RDA Manifestation Properties</span>
                    <xsl:call-template name="manifestation"/>
                </li>
                <li>
                    <span class="caret">RDA Item Properties</span>
                    <xsl:call-template name="item"/>
                </li>
                <li>
                    <span class="caret">RDA Agent Properties</span>
                    <xsl:call-template name="agent"/>
                </li>
                <li>
                    <span class="caret">RDA Person Properties</span>
                    <xsl:call-template name="person"/>
                </li>
                <li>
                    <span class="caret">RDA Collective Agent Properties</span>
                    <xsl:call-template name="collective_agent"/>
                </li>
                <li>
                    <span class="caret">RDA Corporate Body Properties</span>
                    <xsl:call-template name="corporate_body"/>
                </li>
                <li>
                    <span class="caret">RDA Family Properties</span>
                    <xsl:call-template name="family"/>
                </li>
                <li>
                    <span class="caret">RDA Nomen Properties</span>
                    <xsl:call-template name="nomen"/>
                </li>
                <li>
                    <span class="caret">RDA Place Properties</span>
                    <xsl:call-template name="place"/>
                </li>
                <li>
                    <span class="caret">RDA Timespan Properties</span>
                    <xsl:call-template name="timespan"/>
                </li>
            </ul>
        </div>
        <div>
            <script type="text/javascript" src="RDA_hierarchy.js">
&amp;#160;</script>
        </div>
    </xsl:template>
    <xsl:template name="work">
        <xsl:variable name="work_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/w.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$work_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.w.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.w.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$work_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                  select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                  href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                  ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'w'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                                (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                  ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                    ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                name="find_subprops">
                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                <xsl:with-param name="entity" select="'w'"/>
                            </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="expression">
        <xsl:variable name="expression_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/e.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$expression_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.e.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.e.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$expression_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                  select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                  href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                  ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'e'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                                (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                  ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                    ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                name="find_subprops">
                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                <xsl:with-param name="entity" select="'e'"/>
                            </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="manifestation">
        <xsl:variable name="manifestation_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/m.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$manifestation_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.m.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.m.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$manifestation_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'m'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'m'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="item">
        <xsl:variable name="item_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/i.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$item_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.i.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.i.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$item_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'i'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'i'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="agent">
        <xsl:variable name="agent_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$agent_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$agent_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'a'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'a'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="person">
        <xsl:variable name="person_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$person_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10004']">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, X property, or agent property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$person_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10004']">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'a'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'a'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="collective_agent">
        <xsl:variable name="collective_agent_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$collective_agent_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10011']">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, X property, or agent property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$collective_agent_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10011']">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'a'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'a'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="corporate_body">
        <xsl:variable name="corporate_body_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$corporate_body_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10005']">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, X property, or agent property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$corporate_body_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10005']">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'a'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'a'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="family">
        <xsl:variable name="family_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/a.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$family_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10008']">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, X property, or agent property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$family_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]][rdfs:domain/@rdf:resource='http://rdaregistry.info/Elements/c/C10008']">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'a'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'a'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="nomen">
        <xsl:variable name="nomen_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/n.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$nomen_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$nomen_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'n'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'n'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="place">
        <xsl:variable name="place_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/p.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$place_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$place_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'p'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'p'"/>
                                </xsl:call-template>
                        </li>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="timespan">
        <xsl:variable name="timespan_props"
            select="doc('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/t.xml')"/>
        <xsl:variable name="toolkit_URLs" select="doc('../xml/RDA_alignments.xml')"/>
        <ul class="nested">
            <xsl:for-each
                select="$timespan_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                <xsl:variable name="prop_uri" select="@rdf:about"/>
                <xsl:choose>
                    <xsl:when test="rdfs:subPropertyOf">
                        <!-- Listed as a subproperty of something -->
                        <xsl:choose>
                            <xsl:when
                                test="rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.datatype.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.a.object.P\d\d\d\d\d'))] and rdfs:subPropertyOf[not(matches(@rdf:resource, 'http:..rdaregistry.info.Elements.x.P\d\d\d\d\d'))]">
                                <!-- Listed as a subproperty of something that is not a datatype, object, or X property -->
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Only listed as a subproperty of one of these matches; top-level term -->
                                <li>
                                    <xsl:variable name="last_8_characters"
                                        select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                                    <xsl:variable name="prop_id"
                                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                                    <xsl:choose>
                                        <xsl:when
                                            test="$timespan_props/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $prop_uri]]">
                                            <span class="caret"><xsl:value-of
                                                select="rdfs:label[@xml:lang = 'en']"/> (<a
                                                    href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                    ><xsl:value-of select="$prop_id"/></a>)</span>
                                            <xsl:call-template name="find_subprops">
                                                <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                                <xsl:with-param name="entity" select="'t'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/>
                                            (<a
                                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Not a subproperty of anything; top-level term -->
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($prop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                ><xsl:value-of select="$prop_id"/></a>) <xsl:call-template
                                    name="find_subprops">
                                    <xsl:with-param name="prop_uri" select="$prop_uri"/>
                                    <xsl:with-param name="entity" select="'t'"/>
                                </xsl:call-template>
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
        <xsl:if
            test="doc(concat('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/', $entity, '.xml'))/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]/rdfs:subPropertyOf[@rdf:resource = $prop_uri]">
            <ul class="nested">
                <xsl:for-each
                    select="doc(concat('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/', $entity, '.xml'))/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])]">
                    <xsl:sort select="rdfs:label[@xml:lang = 'en']"/>
                    <xsl:variable name="subprop_uri" select="@rdf:about"/>
                    <xsl:if test="rdfs:subPropertyOf[@rdf:resource = $prop_uri]">
                        <li>
                            <xsl:variable name="last_8_characters"
                                select="substring-after($subprop_uri, 'http://rdaregistry.info/Elements/')"/>
                            <xsl:variable name="prop_id"
                                select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                            <xsl:choose>
                                <xsl:when
                                    test="doc(concat('https://github.com/RDARegistry/RDA-Vocabularies/raw/master/xml/Elements/', $entity, '.xml'))/rdf:RDF/rdf:Description[rdf:type[@rdf:resource = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property']][not(reg:status[@rdf:resource = 'http://metadataregistry.org/uri/RegStatus/1008'])][rdfs:subPropertyOf[@rdf:resource = $subprop_uri]]">
                                    <span class="caret"><xsl:value-of
                                            select="rdfs:label[@xml:lang = 'en']"/> (<a
                                            href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                                ><xsl:value-of select="$prop_id"/></a>)</span>
                                    <xsl:call-template name="find_subprops">
                                        <xsl:with-param name="prop_uri" select="$subprop_uri"/>
                                        <xsl:with-param name="entity" select="$entity"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="rdfs:label[@xml:lang = 'en']"/> (<a
                                        href="{$toolkit_URLs/alignmentPairs/alignmentPair[rdaPropertyNumber=$prop_id]/rdaToolkitURL/@uri}"
                                            ><xsl:value-of select="$prop_id"/></a>) </xsl:otherwise>
                            </xsl:choose>
                        </li>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
