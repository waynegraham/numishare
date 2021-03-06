<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs exsl xs xi" version="2.0"
	xmlns:xi="http://www.w3.org/2001/XInclude" xmlns="http://www.w3.org/1999/xhtml" xmlns:exsl="http://exslt.org/common">
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:param name="q"/>
	<xsl:param name="century"/>
	<xsl:variable name="century_int" select="number(translate($century, '\', ''))"/>

	<xsl:template match="/">
		<!--<xsl:copy-of select="*"/>-->		
		<xsl:apply-templates select="descendant::lst[@name='decade_num']"/>
	</xsl:template>

	<xsl:template match="lst[@name='decade_num']">
		<xsl:for-each select="int">
			<xsl:choose>
				<xsl:when test="$century_int &lt; 0">
					<xsl:if test="$century_int * 100 &lt; number(@name) and ($century_int + 1) * 100 &gt;= number(@name)">
						<xsl:call-template name="generate-list"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$century_int &gt; 0">
					<xsl:if test="$century_int * 100 &gt; number(@name) and ($century_int - 1) * 100 &lt;= number(@name)">
						<xsl:call-template name="generate-list"/>
					</xsl:if>
				</xsl:when>
			</xsl:choose>			
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="generate-list">
		<xsl:choose>
			<xsl:when test="number(@name) &lt; 0">
				<li>
					<xsl:choose>
						<xsl:when test="contains($q, concat('decade_num:\', @name))">
							<input type="checkbox" value="{@name}" checked="checked" class="decade_checkbox"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="checkbox" value="{@name}" class="decade_checkbox"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="concat(if(@name = '0') then '00' else @name, 's')"/>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:choose>
						<xsl:when test="contains($q, concat('decade_num:', @name))">
							<input type="checkbox" value="{@name}" checked="checked" class="decade_checkbox"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="checkbox" value="{@name}" class="decade_checkbox"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="concat(if(@name = '0') then '00' else @name, 's')"/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
