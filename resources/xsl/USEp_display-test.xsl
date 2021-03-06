<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs xd t"
    version="2.0">

    <!-- ******************************************************************************
        Takes an inscription marked up in Epidoc (US Ep version, Winter 2011) and
        transforms it to HTML for display. This is based on the US Ep proofreading
        XSL and on the original USEp display XSL.

        **Change Log
        2011-11-8 EM Begun
        2011-11-29 EM adding edition handling
        2014-09-25 EM many changes including: 

        ******************************************************************************   -->
    <xsl:import href="epidoc-xsl-p5/start-edition.xsl"/>
 
    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:variable name="imageDir" select="'../../../../usep_images'"/>

    <!-- Output is not complete HTML file, because in our case, most of the page, header and so on are handled by django.
        This script takes care of anything beneath the title of the inscription (handled by django) down to the bibliographic
        citations and the images. -->
        
    <xsl:template match="/">
        <xsl:result-document href="container">
            <div>

                <!-- This outputs the full text description at the top of the page, after checking that there are descriptions to output. -->
                <div class="titleBlurb">
                    <xsl:if test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/*">
                     <h3>Summary</h3>
                        <p><xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/t:p"/>.<br />
                            <xsl:value-of select="normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:p)"/>.
                        </p>
                 </xsl:if>
                </div>

<!-- enclosing div so that metadata and images can be side by side -->
                <div class="topDivs">
    <!-- This outputs the inscription metadata, after checking that there is some. -->
                    <xsl:if test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/*">
                    <div class="metadata">
                        <h3>Attributes</h3>

<table>
    <tr><td class="label">Inscription Type</td><td class="value"><xsl:value-of select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/@class, '#'))/t:catDesc"/></td></tr>
    <tr><td class="label">Object Type</td><td class="value"><xsl:value-of select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/@ana, '#'))/t:catDesc"/></td></tr>
    <tr><td class="label">Material</td><td class="value"><xsl:value-of select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/@ana, '#'))/t:catDesc"/></td></tr>
    <tr><td class="label">Place of Origin</td><td class="value"><xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:placeName"/>, <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:date"/></td></tr>
    <xsl:for-each select="//t:provenance">
        <tr><td class="label">Subsequent Location</td><td class="value"><xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:provenance/t:placeName"/>, <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:provenance/t:date"/></td></tr>
    </xsl:for-each>
    <tr><td class="label">Acquired</td><td class="value"><xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:acquisition/t:p"/>, <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:acquisition/t:date"/></td></tr>
    <!-- check for existence of controlled and full text values here. -->
    <tr><td class="label">Layout</td><td class="value"><xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:layoutDesc/t:layout/@columns"/> columns, <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:layoutDesc/t:layout/@writtenLines"/> lines</td></tr>
    <tr><td class="label">Writing</td><td class="value"><xsl:value-of select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:handDesc/t:handNote/@ana, '#'))/t:catDesc"/> <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:handDesc/t:handNote"/></td></tr>
    <tr><td class="label">Condition</td><td class="value"><xsl:value-of select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:condition/@ana, '#'))/t:catDesc"/>, <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:condition/t:p"/></td></tr>
    <tr><td class="label inactive">Decoration</td><td class="value"><xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:decoDesc/t:decoNote/@ana"/> <xsl:value-of select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:decoDesc/t:decoNote"/></td></tr>
                        </table>
                        </div>
                </xsl:if>

                <!-- Output the images (hope to format these at upper  right perhaps?), again, first checking to see if there are any. -->
                    <xsl:result-document href="images">
                            <xsl:for-each select="/t:TEI/t:facsimile/t:surface">
                                <xsl:for-each select="t:graphic">
                                    <a class="highslide" href="{concat($imageDir, '/',@url)}" onclick="return hs.expand(this)">
                                        <img src="{concat($imageDir, '/',@url)}" alt="" width="200"/>
                                    </a>
                                </xsl:for-each>
                            </xsl:for-each>
                   </xsl:result-document>
                </div>

                <!-- This outputs the text using Epidoc stylesheets, checks to see if there is a transcription. -->
                <xsl:if test="/t:TEI/t:text/t:body/t:div[@type='edition']/t:ab">
                    <style id="transcription_style">
                        .linenumber {
                            display: block;
                            float: left;
                            margin-left: -2em;
                        }
                    </style>
                    <xsl:call-template name="default-body-structure">
                        <xsl:with-param name="parm-leiden-style" tunnel="yes">panciera</xsl:with-param>
                        <xsl:with-param name="parm-line-inc" tunnel="yes" as="xs:double">5</xsl:with-param>
                        <xsl:with-param name="parm-bib" tunnel="yes">none</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

      <!-- This outputs the bibliography. No need to check, there is always bibliography. -->
                <div class="bibl">
                    <h3>Bibliography</h3>
                    <xsl:call-template name="bibl"/>

                        <!-- this should be enclosed in a bibl and put into the bibliography script,
                            it should also check that link is descendant of div type=bib -->

                </div>
             
            <xsl:choose>
                <xsl:when test="/t:TEI/t:text/t:body/t:div[@type='edition']/t:ab">
                    <!-- transcribed folder -->
                    <p><a href="{concat('https://github.com/Brown-University-Library/usep-data/blob/master/xml_inscriptions/transcribed/',/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id,'.xml')}">View XML source file</a></p>
                </xsl:when>
                <xsl:when test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem[@class]">
                    <!-- bib only folder -->
                    <p><a href="{concat('https://github.com/Brown-University-Library/usep-data/blob/master/xml_inscriptions/metadata_only/',/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id,'.xml')}">View XML source file</a></p>
                </xsl:when>
                <xsl:otherwise>
                    <!-- only option left is metadata only -->
                    <p><a href="{concat('https://github.com/Brown-University-Library/usep-data/blob/master/xml_inscriptions/bib_only/',/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id,'.xml')}">View XML source file</a></p>
                </xsl:otherwise>
            </xsl:choose>
                
            
            
            
            </div>
            
        </xsl:result-document>
    </xsl:template>

    <!-- ****************** This outputs the bibliography ******************** -->

    <xsl:template name="bibl">

        <xsl:for-each select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:listBibl/t:bibl">
            <xsl:variable name="myID" select="substring-after(t:ptr/@target, '#')"/>
            <p>
                <!-- Note: I'm not handling cases where articles are directly in the monograph. Only where they
                    are in a volume. We don't have any, so let's do it later.
                -->
                <!-- Output the author, if there is one. Right now, assumption is that there is an
                    potentially an author on the bibl if it's an article, or on the outermost bibl if
                    it's a corpus or monograph.
                -->

                <xsl:choose>
                    <xsl:when test="id($myID)/t:author/t:persName[@type='sort']">
                        <xsl:value-of select="concat(id($myID)/t:author/t:persName[@type='sort'], ', ')"/>
                    </xsl:when>
                    <xsl:when test="id($myID)/t:author/t:persName">
                        <xsl:value-of select="concat(id($myID)/t:author/t:persName, ', ')"/>
                    </xsl:when>
                </xsl:choose>

                <!-- output title or abbreviation. if it's a monograph, output the title. If  corpus or a journal
                    output the abbreviation if there is one. I am not outputting titles for volumes or articles, as
                    we don't have any. If it's an abbreviation, link it back to the bibliography. This was changed. Code
                    left in.
                -->

                <xsl:choose>
                    <xsl:when test="id($myID)/ancestor-or-self::t:bibl[@type='m' or @type='u']/t:title">
                        <i>
                            <xsl:value-of select="id($myID)/ancestor-or-self::t:bibl[@type='m' or @type='u']/t:title"/>
                        </i>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="id($myID)/ancestor-or-self::t:bibl[@type='c' or @type='j']/t:abbr">
                                <!-- I  have commented out the code that made an abbreviation into a link to the actual bibliographic entry -->
                                <!-- <a href="../refList.html#{//bibl[@id=$myID]/ancestor-or-self::bibl[@type='c' or @type='j']/@id}"> -->
                                <i>
                                    <xsl:value-of select="id($myID)/ancestor-or-self::t:bibl[@type='c' or @type='j']/t:abbr[@type='primary']"/>
                                </i>
                                <!-- </a> -->
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="id($myID)/ancestor-or-self::t:bibl[@type='c' or @type='j']/t:title"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- output the volume, if there is one. with a space before it. -->

                <xsl:if test="id($myID)/ancestor-or-self::t:bibl[@type='v']">
                    <xsl:value-of select="concat(' ', id($myID)/ancestor-or-self::t:bibl[@type='v']/t:biblScope)"/>
                </xsl:if>

                <!-- output the year, if there is one. with a space before it and inside parentheses. -->

                <xsl:choose>
                    <xsl:when test="id($myID)/t:date">
                        <xsl:value-of select="concat(' (',id($myID)/t:date, ')')"/>
                    </xsl:when>
                    <xsl:when test="id($myID)/ancestor-or-self::t:bibl[@type='v' or type='m']/t:date">
                        <xsl:value-of select="concat(' (',id($myID)/ancestor-or-self::t:bibl[@type='v' or type='m']/t:date, ')')"/>
                    </xsl:when>
                </xsl:choose>

                <!-- everything has a reference except for unpub. but put a space before it. -->

                <xsl:if test="t:biblScope">
                    <xsl:value-of select="concat(': ', t:biblScope)"/>
                </xsl:if>

                 <xsl:if test="id($myID)/t:author">
                    <xsl:value-of select="concat(' [', id($myID)/t:author, ']')"/>
                </xsl:if> 

                <!-- This prints the jstor link   -->
                <xsl:if test="id($myID)/t:ref[@type='jstor']">
                    <br />
                    (<a href="{id($myID)/t:ref/@target}" class="biblink"><xsl:value-of select="id($myID)/t:ref[@type='jstor']"/></a> (external link; access to JSTOR required)
                </xsl:if>

               <xsl:if test="t:ref">
                    <a href="{t:ref/@target}"><xsl:value-of select="t:ref"/></a> (external link)
                </xsl:if>

            </p>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
