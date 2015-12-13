<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:ae="http://purl.org/atom/ext/"
  xmlns:th="http://dp-net.com/2013/th">

<xsl:template name="common-html-head-tags">
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href='https://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'/>
  <link href='https://fonts.googleapis.com/css?family=Baumans' rel='stylesheet' type='text/css'/>
  <link rel="stylesheet" href="/css/reset.css" type="text/css" media="screen" />
  <link type="text/css" href="/css/lightbox.css" rel="stylesheet" />
  <script src="http://yui.yahooapis.com/3.7.3/build/yui/yui-min.js" type="text/javascript"></script>
  <script src="/js/modernizr.js"></script>
  <!--<script src="/js/respond.min.js"></script>-->

  <!-- todo: include extern jQuery file but fall back to local file if extern one fails to load 
  <script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>-->

  <script src="/js/prefixfree.min.js"></script>
  <!--<script src="/js/lightbox-plus-jquery.min.js"></script>-->
  <style>
@import url("/css/reset.css");
@import url("/css/main.css");
@import url("/css/phone.css") (max-width: 600px);
a.previous, a.next {
  position: fixed;
  display: none;
  top: 50%;
}
a.previous {
  left: 1px;
}
a.next {
  right: 1px;
}
  </style>
  <link href='http://fonts.googleapis.com/css?family=Open+Sans:300&amp;subset=latin,cyrillic' rel='stylesheet' type='text/css'/>
</xsl:template>

<xsl:template match="atom:link" mode="head">
  <link rel="{@rel}" href="{@href}" class="navigation" title="{@title}"/>
</xsl:template>

<xsl:template name="top-navigatoin-bar">
 <header>
  <nav id="breadcrumbs">
    <xsl:apply-templates select="atom:link[@rel='up']" mode="navigation-link"/>
  </nav>
  <xsl:apply-templates select="atom:link[@rel='previous']" mode="navigation-link">
    <xsl:with-param name="label" select="'&lt;'"/>
  </xsl:apply-templates>
<!--
  <xsl:apply-templates select="atom:link[@rel='index']" mode="navigation-link">
    <xsl:with-param name="label" select="'icon-grid-view'"/>
  </xsl:apply-templates>
-->
  <xsl:apply-templates select="atom:link[@rel='next']" mode="navigation-link">
    <xsl:with-param name="label" select="'&gt;'"/>
  </xsl:apply-templates>
  <h1><xsl:value-of select="atom:title"/></h1>
  </header>
  <p class="clear"></p>
</xsl:template>

<xsl:template match="atom:link" mode="navigation-link">
  <xsl:param name="label"/>
  <a href="{@href}" class="{@rel}" style="font-size: 20pt;"><xsl:value-of select="$label"/><!-- <xsl:value-of select="@rel"/>  --></a>
</xsl:template>
 
<xsl:template match="atom:link[@rel='up']" mode="navigation-link">
  <xsl:if test="ae:inline/atom:feed/atom:title">
    <xsl:apply-templates select="ae:inline/atom:feed/atom:link[@rel='up']" mode="navigation-link"/>
    <a href="{@href}"><xsl:value-of select="ae:inline/atom:feed/atom:title"/></a> / 
  </xsl:if>
</xsl:template>

<xsl:template mode="image-thumbnail" match="atom:link[@rel='alternate' and @type='image/jpg']">
  <xsl:param name="size"/>
  <xsl:param name="class"/>
  <xsl:param name="alt"/>
  <xsl:choose>
    <xsl:when test="@width and @height"> <!-- WORKAROUND: maybe this should be simplified and check removed -->
      <xsl:variable name="th" select="th:th_size($size, number(@width), number(@height))"/>
      <img class="{$class}" src="{@href}?px={$th[1]}">
        <xsl:if test="$alt">
          <xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
        </xsl:if>
      </img>
    </xsl:when>
    <xsl:otherwise>
      <img class="{$class}" src="{@href}?size={$size}">
        <xsl:if test="$alt">
          <xsl:attribute name="alt"><xsl:value-of select="$alt"/></xsl:attribute>
        </xsl:if>
      </img>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="footer">
   <p class="clear"></p>
   <footer>
    <h3 class="hidden"> Footer</h3>
    <hr width="300px" align="left" style="margin-top: 1em; clear: both"/>
    <section id="copyright-notice">
      <h3 class="hidden">Copyright Notice</h3>
      &#169; 1999&#150;2013 Dmitri Popov
    </section>
  </footer> 
  <script src="/js/lightbox-plus-jquery.js"></script>
</xsl:template>
</xsl:stylesheet>
