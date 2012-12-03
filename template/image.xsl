<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:exif="http://dp-net.com/2012/Exif">

<xsl:include href="config.xsl"/>
<xsl:include href="date.xsl"/>

<xsl:template match="atom:entry">
  <html>
    <head>
      <xsl:call-template name="common-html-head-tags"/>
      <title><xsl:value-of select="atom:title"/></title>
      <xsl:apply-templates select="atom:link[@rel='previous' or @rel='next' or @rel='index']" mode="head"/>
      <style>
aimg.main { margin-top: 2em }
      </style>
    </head>
    <body>
      <xsl:call-template name="top-navigatoin-bar"/>
      <h1 style="margin-bottom: 0.5em"><xsl:value-of select="atom:title"/></h1>
      
      <figure style="imargin: 0em;">
        <img class="main" src="{atom:link[@rel='alternate' and @type='image/jpg']/@href}?px=1000" style="display: inline-block; float: left; margin-bottom: 1em; margin-right: 1em"/>
        <figcaption style="display: inline-block; vertical-align: top">
          <xsl:call-template name="date"/> 
        </figcaption>
      </figure>
    </body>
  </html>
</xsl:template>

<xsl:template name="date">
  <xsl:choose>
    <xsl:when test="exif:date">
      <xsl:apply-templates select="exif:date"/>
    </xsl:when>
    <xsl:when test="atom:updated">
      <xsl:apply-templates select="atom:updated"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="atom:updated">
  <div class="date"><xsl:call-template name="iso-date"/></div>
</xsl:template>

<xsl:template match="exif:date">
  <div class="date"><xsl:call-template name="exif-date"/></div>
</xsl:template>

</xsl:stylesheet>
