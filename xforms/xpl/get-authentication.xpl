<!--
    Copyright (C) 2007 Orbeon, Inc.

    This program is free software; you can redistribute it and/or modify it under the terms of the
    GNU Lesser General Public License as published by the Free Software Foundation; either version
    2.1 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU Lesser General Public License for more details.

    The full text of the license is available at http://www.gnu.org/copyleft/lesser.html
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline"
          xmlns:oxf="http://www.orbeon.com/oxf/processors">
	
	<p:param name="dump" type="input"/>
	<p:param name="data" type="output"/>

	<p:processor xmlns:xforms="http://www.w3.org/2002/xforms" name="oxf:request-security">
		<p:input name="config">
			<config>				
				<role>admin</role>
				<role>kittredge</role>
				<role>rrch</role>
				<role>papal</role>				
				<role>mantis</role>
				<role>egypt</role>
				<role>uva</role>
				<role>electrum</role>
				<role>ocre</role>
			</config>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>

</p:config>
