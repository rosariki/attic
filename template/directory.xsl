<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:th="http://dp-net.com/2013/th">

<xsl:include href="config.xsl"/>

<xsl:template match="atom:feed">
  <html>
    <head>
      <link rel='stylesheet' href='/css/directory.css'/>
      <title><xsl:value-of select="atom:title"/></title>
      <xsl:call-template name="common-html-head-tags"/>
      <script src="/js/row-grid.js"></script>
      <script>
        $(document).ready(function(){
        if(!$("#subdirectories").length)
            { $("#preview").css("max-width", "100%")};

          $(window).load(function(){
             var options = {minMargin: 5, maxMargin: 10, itemSelector: ".image"};
$("#preview").rowGrid(options);

});

            });
      </script>
    </head>
    <body>
      <xsl:call-template name="top-navigatoin-bar"/>
      <main>
      <!--<h1><xsl:value-of select="atom:title"/></h1> -->
      <xsl:if test="atom:entry[atom:category/@term='image' or atom:category/@term='video']">
<!--        <section id="preview">
          <h2 class="hidden">Previews:</h2> -->
          <section  id="preview"> 
          <h2 class="hidden">Previews:</h2>
          <xsl:apply-templates select="atom:entry[atom:category/@term='image' or atom:category/@term='video']"/>
          </section>
    <!--    </section> -->
      </xsl:if>
      <xsl:if test="atom:entry[atom:category/@term='directory']">
        <nav id="subdirectories">
          <h2>More:</h2>
          <ul class="links"> 
            <xsl:apply-templates select="atom:entry[atom:category/@term='directory']"/>
          </ul>
        </nav>

      </xsl:if>
      </main>  
      <xsl:call-template name="footer"/>
    </body>
  </html>
</xsl:template>

<xsl:template match="/atom:feed/atom:entry[atom:category/@term='directory']">
  <li><a href="{atom:link/@href}"><xsl:value-of select="atom:title"/></a></li>
</xsl:template>

<xsl:template match="/atom:feed/atom:entry[atom:category/@term='image']">
  <article class='image'> 
   <a href="{atom:link/@href}"> 
     <xsl:apply-templates select="atom:link[@rel='alternate' and @type='image/jpg']" mode="image-thumbnail">
       <xsl:with-param name="size" select="'small'"/>
       <xsl:with-param name="height" select="'th'"/>
     </xsl:apply-templates>
   </a>
  </article>
</xsl:template>

<xsl:template match="/atom:feed/atom:entry[atom:category/@term='video']">
  <a href="{atom:link/@href}"><img class="th"  src="{atom:link[@rel='alternate' and @type='image/jpg']/@href}?type=image"/></a>
</xsl:template>

</xsl:stylesheet>
