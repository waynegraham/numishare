<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:numishare="http://code.google.com/p/numishare/" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all"
	version="2.0">
	<xsl:template name="header">

		<!-- if displaying a coin or artifact record, the path to the other sections should be {$display_path} ; otherwise nothing -->
		<div id="hd">
			<div class="banner align-right ui-widget-content" style="border:0">
				<xsl:if test="string(/content/config/banner_text)">
					<div class="banner_text">
						<xsl:value-of select="/content/config/banner_text"/>
					</div>
				</xsl:if>
				<xsl:if test="string(//config/banner_image/@xlink:href)">
					<img src="{$display_path}images/{//config/banner_image/@xlink:href}" alt="banner image"/>
				</xsl:if>
			</div>
			<ul role="menubar" id="menu">
				<xsl:call-template name="menubar"/>
			</ul>
			<div id="log"/>
		</div>
	</xsl:template>

	<xsl:template name="menubar">
		<xsl:choose>
			<xsl:when test="$lang='ar'">
				<xsl:if test="count(//config/descendant::language[@enabled='true']) &gt; 1">
					<li role="presentation">
						<a href="#Language">
							<xsl:value-of select="numishare:normalizeLabel('header_language', $lang)"/>
						</a>
						<ul role="menu">
							<xsl:for-each select="//config/descendant::language[@enabled='true']">
								<li role="presentation">
									<a role="menuitem" href="?lang={@code}">
										<xsl:value-of select="if (string(label[@xml:lang=$lang])) then label[@xml:lang=$lang] else label[@xml:lang='en']"/>
									</a>
								</li>
							</xsl:for-each>
						</ul>
					</li>
				</xsl:if>
				<xsl:for-each select="//config/pages/page[public = '1']" >
					<li role="presentation">
						<a href="{$display_path}pages/{@stub}{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="short-title"/>
						</a>
					</li>
				</xsl:for-each>
				<xsl:if test="//config/pages/visualize/@enabled= true()">
					<li role="presentation">
						<a href="{$display_path}visualize{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="numishare:normalizeLabel('header_visualize', $lang)"/>
						</a>
					</li>
				</xsl:if>
				<xsl:if test="//config/pages/analyze/@enabled= true()">
					<li role="presentation">
						<a href="{$display_path}analyze{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="numishare:normalizeLabel('header_analyze', $lang)"/>
						</a>
					</li>
				</xsl:if>
				<xsl:if test="//config/pages/compare/@enabled= true()">
					<li role="presentation">
						<a href="{$display_path}compare{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="numishare:normalizeLabel('header_compare', $lang)"/>
						</a>
					</li>
				</xsl:if>
				<li role="presentation">
					<a href="{$display_path}maps{if (string($lang)) then concat('?lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_maps', $lang)"/>
					</a>
				</li>
				<li role="presentation">
					<a href="{$display_path}search{if (string($lang)) then concat('?lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_search', $lang)"/>
					</a>
				</li>
				<li role="presentation">
					<a href="{$display_path}results?q=*:*{if (string($lang)) then concat('&amp;lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_browse', $lang)"/>
					</a>
				</li>
				<li role="presentation">
					<a href="{$display_path}.{if (string($lang)) then concat('?lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_home', $lang)"/>
					</a>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li role="presentation">
					<a href="{$display_path}.{if (string($lang)) then concat('?lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_home', $lang)"/>
					</a>
				</li>
				<li role="presentation">
					<a href="{$display_path}results?q=*:*{if (string($lang)) then concat('&amp;lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_browse', $lang)"/>
					</a>
				</li>
				<li role="presentation">
					<a href="{$display_path}search{if (string($lang)) then concat('?lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_search', $lang)"/>
					</a>
				</li>
				<li role="presentation">
					<a href="{$display_path}maps{if (string($lang)) then concat('?lang=', $lang) else ''}">
						<xsl:value-of select="numishare:normalizeLabel('header_maps', $lang)"/>
					</a>
				</li>
				<xsl:if test="//config/pages/compare/@enabled= true()">
					<li role="presentation">
						<a href="{$display_path}compare{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="numishare:normalizeLabel('header_compare', $lang)"/>
						</a>
					</li>
				</xsl:if>
				<xsl:if test="//config/pages/analyze/@enabled= true()">
					<li role="presentation">
						<a href="{$display_path}analyze{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="numishare:normalizeLabel('header_analyze', $lang)"/>
						</a>
					</li>
				</xsl:if>
				<xsl:if test="//config/pages/visualize/@enabled= true()">
					<li role="presentation">
						<a href="{$display_path}visualize{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="numishare:normalizeLabel('header_visualize', $lang)"/>
						</a>
					</li>
				</xsl:if>
				<xsl:for-each select="//config/pages/page[public = '1']">
					<li role="presentation">
						<a href="{$display_path}pages/{@stub}{if (string($lang)) then concat('?lang=', $lang) else ''}">
							<xsl:value-of select="short-title"/>
						</a>
					</li>
				</xsl:for-each>
				<!-- display the language switching menu when 2 or more languages are enabled -->
				<xsl:if test="count(//config/descendant::language[@enabled='true']) &gt; 1">
					<li role="presentation">
						<a href="#Language">
							<xsl:value-of select="numishare:normalizeLabel('header_language', $lang)"/>
						</a>
						<ul role="menu">
							<xsl:for-each select="//config/descendant::language[@enabled='true']">
								<xsl:sort select="@code"/>
								<li role="presentation">
									<a role="menuitem" href="?lang={@code}">
										<xsl:value-of select="if (string(label[@xml:lang=$lang])) then label[@xml:lang=$lang] else label[@xml:lang='en']"/>
									</a>
								</li>
							</xsl:for-each>
						</ul>
					</li>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
</xsl:stylesheet>
