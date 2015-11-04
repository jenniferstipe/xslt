
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xd="http://www.pnp-software.com/XSLTdoc" version="2.0">

   <xd:doc type="stylesheet">
      <xd:author>ianw</xd:author>
      <xd:copyright>Ian Williams 2002-2009</xd:copyright>
      <xd:short>This is the main stylesheet.</xd:short>
   </xd:doc>
   <xsl:output method="html" encoding="UTF-8"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>

   <xsl:include href="params.xsl"/>
   <xsl:include href="head.xsl"/>
   <xsl:include href="table.xsl"/>
   <xd:doc>
      <xd:short>Specifies the identifier in the <code>entry</code> element as a
         key.</xd:short>
   </xd:doc>
   <xsl:key name="identifier" match="entry" use="@xml:id"/>

   <xd:doc>
      <xd:short>Defines the CSS stylesheet for reference pages.</xd:short>
   </xd:doc>
   <xsl:param name="style">reference.css</xsl:param>

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
   <xd:doc>
      <xd:short>Generates a heading and selects the content of the paragraphs
            <code>purpose</code> element.</xd:short>
   </xd:doc>
   <xsl:template match="purpose">
      <h2>Purpose</h2>
      <xsl:apply-templates select="p"/>
   </xsl:template>
   <xd:doc>
      <xd:short>Generates a heading and selects the content of the paragraphs
            <code>usage</code> element.</xd:short>
   </xd:doc>
   <xsl:template match="usage">
      <h2>Usage</h2>
      <xsl:apply-templates select="p"/>
   </xsl:template>
   <xd:doc>
      <xd:short>Generates a heading based on the <code>label</code> attribute.
         Processes contained <code>link</code> elements.</xd:short>
   </xd:doc>
   <xsl:template match="contains | containedby | related">
      <h2>
         <xsl:choose>
            <xsl:when test="@label='contains'">Contains</xsl:when>
            <xsl:when test="@label='related'">Related topic</xsl:when>
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
   <xd:doc>
      <xd:short>Processes the attributes of the element.</xd:short>
   </xd:doc>
   <xsl:template match="properties">
      <xsl:call-template name="attribute"/>
   </xsl:template>
   <xd:doc>
      <xd:short>Generates a heading and lists the element attributes in a
         table.</xd:short>
      <xd:detail>A plural of the label is generated if the count of
            <code>property</code> elements is greater than 1. The table elements
         make use of attribute sets specified in <code>table.xsl</code>. A
         non-breaking space in each table cell ensures that table style is
         maintained.</xd:detail>
   </xd:doc>
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
   <xd:doc>
      <xd:short>Processes paragraphs in sections.</xd:short>
   </xd:doc>
   <xsl:template match="p">
      <p>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xd:doc>
      <xd:short>element and attribute names are enclosed in a <code>code</code>
         element.</xd:short>
   </xd:doc>
   <xsl:template match="attr | element">
      <code>
         <xsl:value-of select="."/>
      </code>
   </xsl:template>

   <xd:doc>
      <xd:short><code>code</code> elements are copied as is.</xd:short>
   </xd:doc>
   <xsl:template match="code">
      <xsl:copy-of select="."/>
   </xsl:template>
   <xd:doc>
      <xd:short>Link values are obtained by selecting metadata with the
            <code>key</code> function. The document title and the relative path
         are generated.</xd:short>
   </xd:doc>
   <xsl:template match="link">
      <xsl:variable name="linkID" select="@href"/>
      <xsl:variable name="linkmeta"
         select="key('identifier',$linkID,$resourcelist)"/>
      <a>
         <xsl:attribute name="href">
            <xsl:value-of
               select="concat($linkmeta/content/@src,$linkID,'.html')"/>
         </xsl:attribute>
         <xsl:value-of select="$linkmeta/title"/>
      </a>
   </xsl:template>
   <xd:doc>
      <xd:short>Container for examples.</xd:short>
   </xd:doc>
   <xsl:template match="examples">
      <h2>Example<xsl:if test="count(codeblock) gt 1">s</xsl:if>
      </h2>
      <xsl:apply-templates/>
   </xsl:template>
   <xd:doc>
      <xd:short>Sample code is copied inside a <code>pre</code>
         element.</xd:short>
   </xd:doc>
   <xsl:template match="codeblock">
      <pre class="code">
         <xsl:copy-of select="."/>
      </pre>
   </xsl:template>

</xsl:stylesheet>
