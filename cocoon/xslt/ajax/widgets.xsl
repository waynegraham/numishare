<?xml version="1.0" encoding="UTF-8"?>
<!-- this stylesheet contains widgets to interact with external systems for use throughout Numishare, 
for example pulling data from the coin-type triplestore and SPARQL endpoint, Metis -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:exsl="http://exslt.org/common" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:numishare="http://code.google.com/p/numishare/" xmlns:res="http://www.w3.org/2005/sparql-results#" exclude-result-prefixes="#all">

	<xsl:param name="template"/>
	<xsl:param name="uri"/>

	<!-- config variables -->
	<xsl:variable name="endpoint" select="/config/sparql_endpoint"/>
	<xsl:variable name="geonames-url">
		<xsl:text>http://api.geonames.org</xsl:text>
	</xsl:variable>
	<xsl:variable name="geonames_api_key" select="/config/geonames_api_key"/>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$template = 'results'">
				<xsl:call-template name="numishare:getImages"/>
			</xsl:when>
			<xsl:when test="$template = 'display'">
				<xsl:call-template name="numishare:associatedObjects"/>
			</xsl:when>
			<xsl:when test="$template = 'kml'">
				<xsl:call-template name="numishare:getFindspots"/>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="numishare:associatedObjects">
		<xsl:variable name="query">
			<![CDATA[PREFIX oac:      <http://www.openannotation.org/ns/>
			PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
			PREFIX dcterms:  <http://purl.org/dc/terms/>
			PREFIX nm:       <http://nomisma.org/id/>
			
			SELECT ?annotation ?uri ?title ?publisher ?weight ?axis ?obvThumb ?revThumb ?obvRef ?revRef ?findspot ?numismatic_term  WHERE {
			?annotation oac:hasBody <typeUri>.
			?annotation oac:hasTarget ?uri .
			?annotation dcterms:title ?title .
			?annotation dcterms:publisher ?publisher .
			OPTIONAL { ?annotation nm:weight ?weight }
			OPTIONAL { ?annotation nm:axis ?axis }
			OPTIONAL { ?annotation nm:obverseThumbnail ?obvThumb }
			OPTIONAL { ?annotation nm:reverseThumbnail ?revThumb }
			OPTIONAL { ?annotation nm:obverseReference ?obvRef }
			OPTIONAL { ?annotation nm:reverseReference ?revRef }
			OPTIONAL { ?annotation nm:findspot ?findspot }
			OPTIONAL { ?annotation nm:numismatic_term ?numismatic_term }}]]>
		</xsl:variable>
		<xsl:variable name="service" select="concat($endpoint, '?query=', encode-for-uri(normalize-space(replace($query, 'typeUri', $uri))), '&amp;output=xml')"/>

		<xsl:apply-templates select="document($service)/res:sparql" mode="display"/>
	</xsl:template>

	<xsl:template name="numishare:getFindspots">
		<xsl:variable name="query">
			<![CDATA[PREFIX oac:      <http://www.openannotation.org/ns/>
			PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
			PREFIX dcterms:  <http://purl.org/dc/terms/>
			PREFIX nm:       <http://nomisma.org/id/>
			
			SELECT ?annotation ?uri ?title ?publisher ?findspot ?numismatic_term ?burial WHERE {
			?annotation oac:hasBody <typeUri>.
			?annotation oac:hasTarget ?uri .
			?annotation dcterms:title ?title .
			?annotation dcterms:publisher ?publisher .
			?annotation nm:findspot ?findspot .
			OPTIONAL { ?annotation nm:numismatic_term ?numismatic_term }
			OPTIONAL { ?annotation nm:approximateburialdate ?burial }}]]>
		</xsl:variable>
		<xsl:variable name="service" select="concat($endpoint, '?query=', encode-for-uri(normalize-space(replace($query, 'typeUri', $uri))), '&amp;output=xml')"/>

		<xsl:apply-templates select="document($service)/res:sparql" mode="kml"/>
	</xsl:template>

	<xsl:template name="numishare:getImages">
		<xsl:variable name="query">
			<![CDATA[PREFIX oac:      <http://www.openannotation.org/ns/>
			PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
			PREFIX dcterms:  <http://purl.org/dc/terms/>
			PREFIX nm:       <http://nomisma.org/id/>
			
			SELECT ?annotation ?uri ?publisher ?weight ?axis ?obvThumb ?revThumb ?obvRef ?revRef ?findspot ?numismatic_term  WHERE {
			?annotation oac:hasBody <typeUri>.
			?annotation oac:hasTarget ?uri .
			?annotation dcterms:publisher ?publisher .
			OPTIONAL { ?annotation nm:weight ?weight }
			OPTIONAL { ?annotation nm:axis ?axis }
			OPTIONAL { ?annotation nm:obverseThumbnail ?obvThumb }
			OPTIONAL { ?annotation nm:reverseThumbnail ?revThumb }
			OPTIONAL { ?annotation nm:obverseReference ?obvRef }
			OPTIONAL { ?annotation nm:reverseReference ?revRef }
			OPTIONAL { ?annotation nm:findspot ?findspot }
			OPTIONAL { ?annotation nm:numismatic_term ?numismatic_term }}]]>
		</xsl:variable>
		<xsl:variable name="service" select="concat($endpoint, '?query=', encode-for-uri(normalize-space(replace($query, 'typeUri', $uri))), '&amp;output=xml')"/>

		<div>
			<xsl:apply-templates select="document($service)/res:sparql" mode="results"/>
		</div>

	</xsl:template>

	<xsl:template match="res:sparql" mode="display">
		<xsl:variable name="coin-count"
			select="count(descendant::res:result[contains(res:binding[@name='numismatic_term']/res:uri, 'coin')]) + count(descendant::res:result[not(child::res:binding[@name='numismatic_term'])])"/>

		<xsl:if test="$coin-count &gt; 0">
			<div class="objects">
				<h2>Examples of this type</h2>

				<!-- choose between between Metis (preferred) or internal links -->
				<xsl:apply-templates select="descendant::res:result[not(contains(res:binding[@name='numismatic_term'], 'hoard'))]" mode="display"/>
			</div>
		</xsl:if>

	</xsl:template>

	<xsl:template match="res:sparql" mode="results">
		<xsl:variable name="id" select="generate-id()"/>
		<xsl:variable name="count" select="count(descendant::res:result)"/>
		<xsl:variable name="coin-count"
			select="count(descendant::res:result[contains(res:binding[@name='numismatic_term']/res:uri, 'coin')]) + count(descendant::res:result[not(child::res:binding[@name='numismatic_term'])])"/>
		<xsl:variable name="hoard-count" select="count(descendant::res:result[contains(res:binding[@name='numismatic_term']/res:uri, 'hoard')])"/>

		<!-- get images -->
		<xsl:apply-templates select="descendant::res:result[res:binding[@name='obvThumb'] and res:binding[@name='obvThumb']]" mode="results">
			<xsl:with-param name="id" select="tokenize($uri, '/')[last()]"/>
		</xsl:apply-templates>
		<!-- object count -->
		<xsl:if test="$count &gt; 0">
			<br/>
			<xsl:if test="$count != $coin-count and $count != $hoard-count">
				<xsl:value-of select="concat($count, if($count = 1) then ' associated object' else ' associated objects')"/>
				<xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:if test="$coin-count &gt; 0">
				<xsl:value-of select="concat($coin-count, if($coin-count = 1) then ' coin' else ' coins')"/>
			</xsl:if>
			<xsl:if test="$coin-count &gt; 0 and $hoard-count &gt; 0">
				<xsl:text> and </xsl:text>
			</xsl:if>
			<xsl:if test="$hoard-count &gt; 0">
				<xsl:value-of select="concat($hoard-count, if($hoard-count = 1) then ' hoard' else ' hoards')"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:sparql" mode="kml">
		<xsl:apply-templates select="descendant::res:result/res:binding[@name='findspot']" mode="kml"/>
	</xsl:template>

	<xsl:template match="res:result" mode="display">
		<div class="g_doc">
			<span class="result_link">
				<a href="{res:binding[@name='uri']/res:uri}" target="_blank">
					<xsl:value-of select="res:binding[@name='title']/res:literal"/>
				</a>
			</span>
			<dl>
				<xsl:if test="res:binding[@name='publisher']/res:literal">
					<div>
						<dt>Publisher: </dt>
						<dd style="margin-left:125px;">
							<xsl:value-of select="res:binding[@name='publisher']/res:literal"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="string(res:binding[@name='axis']/res:literal)">
					<div>
						<dt>Axis: </dt>
						<dd style="margin-left:125px;">
							<xsl:value-of select="string(res:binding[@name='axis']/res:literal)"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="string(res:binding[@name='diameter']/res:literal)">
					<div>
						<dt>Diameter: </dt>
						<dd style="margin-left:125px;">
							<xsl:value-of select="string(res:binding[@name='diameter']/res:literal)"/>
						</dd>
					</div>
				</xsl:if>
				<xsl:if test="string(res:binding[@name='weight']/res:literal)">
					<div>
						<dt>Weight: </dt>
						<dd style="margin-left:125px;">
							<xsl:value-of select="string(res:binding[@name='weight']/res:literal)"/>
						</dd>
					</div>
				</xsl:if>
			</dl>
			<div class="gi_c">
				<xsl:choose>
					<xsl:when test="string(res:binding[@name='obvRef']/res:uri) and string(res:binding[@name='obvThumb']/res:uri)">
						<a class="thumbImage" rel="gallery" href="{res:binding[@name='obvRef']/res:uri}"
							title="Obverse of {res:binding[@name='identifier']/res:literal}: {res:binding[@name='publisher']/res:literal}">
							<img class="gi" src="{res:binding[@name='obvThumb']/res:uri}"/>
						</a>
					</xsl:when>
					<xsl:when test="not(string(res:binding[@name='obvRef']/res:uri)) and string(res:binding[@name='obvThumb']/res:uri)">
						<img class="gi" src="{res:binding[@name='obvThumb']/res:uri}"/>
					</xsl:when>
				</xsl:choose>
				<!-- reverse-->
				<xsl:choose>
					<xsl:when test="string(res:binding[@name='revRef']/res:uri) and string(res:binding[@name='revThumb']/res:uri)">
						<a class="thumbImage" rel="gallery" href="{res:binding[@name='revRef']/res:uri}"
							title="Reverse of {res:binding[@name='identifier']/res:literal}: {res:binding[@name='publisher']/res:literal}">
							<img class="gi" src="{res:binding[@name='revThumb']/res:uri}"/>
						</a>
					</xsl:when>
					<xsl:when test="not(string(res:binding[@name='revRef']/res:uri)) and string(res:binding[@name='revThumb']/res:uri)">
						<img class="gi" src="{res:binding[@name='revThumb']/res:uri}"/>
					</xsl:when>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="res:result" mode="results">
		<xsl:param name="id"/>
		<xsl:variable name="position" select="position()"/>
		<!-- obverse -->
		<xsl:choose>
			<xsl:when test="string(res:binding[@name='obvRef']/res:uri) and string(res:binding[@name='obvThumb']/res:uri)">
				<a class="thumbImage" rel="gallery" href="{res:binding[@name='obvRef']/res:uri}"
					title="Obverse of {res:binding[@name='identifier']/res:literal}: {res:binding[@name='publisher']/res:literal}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{res:binding[@name='obvThumb']/res:uri}"/>
				</a>
			</xsl:when>
			<xsl:when test="not(string(res:binding[@name='obvRef']/res:uri)) and string(res:binding[@name='obvThumb']/res:uri)">
				<img src="{res:binding[@name='obvThumb']/res:uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:when>
		</xsl:choose>
		<!-- reverse-->
		<xsl:choose>
			<xsl:when test="string(res:binding[@name='revRef']/res:uri) and string(res:binding[@name='revThumb']/res:uri)">
				<a class="thumbImage" rel="gallery" href="{res:binding[@name='revRef']/res:uri}"
					title="Reverse of {res:binding[@name='identifier']/res:literal}: {res:binding[@name='publisher']/res:literal}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{res:binding[@name='revThumb']/res:uri}"/>
				</a>
			</xsl:when>
			<xsl:when test="not(string(res:binding[@name='revRef']/res:uri)) and string(res:binding[@name='revThumb']/res:uri)">
				<img src="{res:binding[@name='revThumb']/res:uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="res:binding[@name='findspot']" mode="kml">
		<Placemark xmlns="http://earth.google.com/kml/2.0">
			<name>
				<xsl:value-of select="parent::node()/res:binding[@name='title']/res:literal"/>
			</name>
			<xsl:if test="string(parent::node()/res:binding[@name='burial']/res:literal)">
				<description>
					<xsl:value-of select="parent::node()/res:binding[@name='burial']/res:literal"/>
				</description>
			</xsl:if>

			<styleUrl>#mapped</styleUrl>
			<!-- add placemark -->
			<xsl:choose>
				<xsl:when test="contains(child::res:uri, 'geonames')">
					<xsl:variable name="geonameId" select="substring-before(substring-after(child::res:uri, 'geonames.org/'), '/')"/>
					<xsl:variable name="geonames_data" select="document(concat($geonames-url, '/get?geonameId=', $geonameId, '&amp;username=', $geonames_api_key, '&amp;style=full'))"/>
					<xsl:variable name="coordinates" select="concat(exsl:node-set($geonames_data)//lng, ',', exsl:node-set($geonames_data)//lat)"/>
					<Point>
						<coordinates>
							<xsl:value-of select="$coordinates"/>
						</coordinates>
					</Point>
				</xsl:when>
				<xsl:when test="string(res:literal)">
					<Point>
						<coordinates>
							<xsl:value-of select="res:literal"/>
						</coordinates>
					</Point>
				</xsl:when>
			</xsl:choose>
			<!-- add timespan -->
			<xsl:if test="string(parent::node()/res:binding[@name='burial']/res:literal)">
				<TimeStamp>
					<when>
						<xsl:value-of select="number(parent::node()/res:binding[@name='burial']/res:literal)"/>
					</when>
				</TimeStamp>
			</xsl:if>
		</Placemark>
	</xsl:template>

</xsl:stylesheet>