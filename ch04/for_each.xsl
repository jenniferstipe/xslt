
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

   <xsl:output method="html" encoding="UTF-8"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
   

   <xsl:param name="identifier" select="reference/@xml:id"/>
   <xsl:param name="resourcelist"
      select="document(concat('reslist_',reference/@scheme,'.xml'))"/>
   <xsl:param name="meta" select="$resourcelist//entry[@xml:id eq $identifier]"/>
   <xsl:param name="title" select="$meta/title"/>
   <xsl:param name="style">reference.css</xsl:param>
   
   <xsl:attribute-set name="col">
      <xsl:attribute name="scope">col</xsl:attribute>
   </xsl:attribute-set>
   
   <xsl:attribute-set name="row">
      <xsl:attribute name="scope">row</xsl:attribute>
   </xsl:attribute-set>
   
   <xsl:attribute-set name="th_first" use-attribute-sets="col">
      <xsl:attribute name="class" >firsthdr</xsl:attribute>    
   </xsl:attribute-set>
   
   <xsl:attribute-set name="td_first" use-attribute-sets="row">
      <xsl:attribute name="class">firstcell</xsl:attribute>     
   </xsl:attribute-set>
   
   <xsl:template match="/">
      <html>
         <xsl:call-template name="head">
            <xsl:with-param name="title" select="$title"/>
            <xsl:with-param name="style" select="$style"/>
         </xsl:call-template>
         <body>
            <h1>
               <xsl:value-of select="$title"/>
            </h1>
            <xsl:apply-templates select="reference/body"/>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="head">
      <xsl:param name="title"/>
      <xsl:param name="style"/>
      <head>
         <meta http-equiv="Content-Type" content="text/xml;charset=UTF-8"/>
         <title>
            <xsl:value-of select="$title"/>
         </title>
         <link rel="stylesheet" type="text/css">
            <xsl:attribute name="href">
               <xsl:value-of select="$style"/>
            </xsl:attribute>
         </link>
      </head>
   </xsl:template>
   <xsl:template match="purpose">
      <h2>Purpose</h2>
      <xsl:apply-templates select="p"/>
   </xsl:template>

   <xsl:template match="usage">
      <h2>Usage</h2>
      <xsl:apply-templates select="p"/>
   </xsl:template>

   <xsl:template match="contains | containedby">
      <h2>
         <xsl:choose>
            <xsl:when test="@label='contains'">Contains</xsl:when>
            <xsl:otherwise>Contained by</xsl:otherwise>
         </xsl:choose>
      </h2>
      <p>
         <xsl:for-each select="link">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() ne last()">
               <xsl:text> | </xsl:text>
            </xsl:if>         
         </xsl:for-each>
      </p>
   </xsl:template>
   <xsl:template match="properties">
      <xsl:call-template name="attribute"/>
   </xsl:template>

   <xsl:template name="attribute">
      <h2>Attribute<xsl:if test="count(//property) gt 1">s</xsl:if>
      </h2>
      <table cellspacing="0">
         <tr>
            <th xsl:use-attribute-sets="th_first">Name</th>
            <th xsl:use-attribute-sets="col">Description</th>
            <th xsl:use-attribute-sets="col">Type</th>
            <th xsl:use-attribute-sets="col">Default</th>
            <th xsl:use-attribute-sets="col">Options</th>
            <th xsl:use-attribute-sets="col">Use</th>
         </tr>
         <xsl:for-each select="//property">
            <xsl:sort select="name"/>
            <tr>
               <th xsl:use-attribute-sets="td_first">
                  <xsl:value-of select="name"/>
                  <!--<xsl:value-of select="concat('[',position(),'] ',name)"/>-->
               </th>
               <td xsl:use-attribute-sets="row">
                  <xsl:apply-templates select="description"/>
               </td>
               <td xsl:use-attribute-sets="row">
                  <xsl:apply-templates select="type"/>
               </td>
               <td xsl:use-attribute-sets="row">
                  <xsl:value-of select="default"/>&#160;</td>
               <td xsl:use-attribute-sets="row">
                  <xsl:value-of select="values"/>&#160;</td>
               <td xsl:use-attribute-sets="row">
                  <xsl:value-of select="required/@state"/>&#160;</td>
               
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>

   <xsl:template match="p">
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>

   <xsl:template match="attr | element">
      <code>
         <xsl:value-of select="."/>
      </code>
   </xsl:template>

   <xsl:template match="attr | element" mode="index">
      <code>
         <xsl:value-of select="."/>
      </code>
   </xsl:template>

   <xsl:template match="code">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="link">
      <xsl:variable name="linkID" select="@href"/>
      <xsl:variable name="linkmeta"
         select="$resourcelist//entry[@xml:id=$linkID]"/>
      <a>
         <xsl:attribute name="href">
            <xsl:value-of
               select="concat($linkmeta/content/@src,$linkID,'.html')"/>
         </xsl:attribute>
         <xsl:value-of select="$linkmeta/title"/>
      </a>
   </xsl:template>
   
   <xsl:template match="examples">
      <h2>Example<xsl:if test="count(codeblock) gt 1">s</xsl:if>
      </h2>
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="codeblock">
      <pre class="code">
         <xsl:value-of select="."/>
      </pre>  
   </xsl:template>

</xsl:stylesheet>
