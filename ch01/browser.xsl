<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output
      method="xml"
      encoding="UTF-8"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
	  
   <xsl:template match="/">
      <html>
      <head>
         <title>
            <xsl:value-of select="reference/body/title"/>
         </title>
      </head>
      <body>
         <p>The body goes here</p>
      </body>
   </html>
   </xsl:template>	  
	  
</xsl:stylesheet>