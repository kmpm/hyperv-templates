<xsl:stylesheet version="1.0"
            xmlns="http://www.w3.org/1999/xhtml"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
            xmlns:u="urn:schemas-microsoft-com:unattend">

  <xsl:output method="xml" indent="yes" />

  <xsl:strip-space elements="*"/>

  <xsl:param name="productKey"/>
  <xsl:param name="inputLocale"/>
  <xsl:param name="userLocale"/>


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  
  <!-- add windows prouct key -->
  <xsl:template match='u:unattend/u:settings/u:component[@name="Microsoft-Windows-Setup"]/u:UserData/u:ProductKey'>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:if test="$productKey">
          <xsl:element name="Key" namespace="{namespace-uri()}">
            <xsl:value-of select="$productKey"/>
          </xsl:element>
          <xsl:element name="WillShowUI" namespace="{namespace-uri()}">OnError</xsl:element>
      </xsl:if>
      <xsl:if test="not($productKey)">
        <xsl:apply-templates select="node()"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- input locale -->
  <xsl:template match='u:unattend/u:settings/u:component[@name="Microsoft-Windows-International-Core-WinPE"]/u:InputLocale'>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="$inputLocale">
            <xsl:value-of select="$inputLocale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- user locale -->
  <xsl:template match='u:unattend/u:settings/u:component[@name="Microsoft-Windows-International-Core-WinPE"]/u:UserLocale'>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="$userLocale">
            <xsl:value-of select="$userLocale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- SystemLocale same as UserLocale -->
  <xsl:template match='u:unattend/u:settings/u:component[@name="Microsoft-Windows-International-Core-WinPE"]/u:SystemLocale'>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="$userLocale">
            <xsl:value-of select="$userLocale"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
  
  

  <!-- <xsl:template match="comment()"/> -->
</xsl:stylesheet>