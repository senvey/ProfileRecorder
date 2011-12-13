<!--

	ProfileRecorder, record user's info so that it could be browsed offline.
	Copyright 2007 Senvey Lee
	Email me at senvey@gmail.com

	This file is part of ProfileRecorder.

	ProfileRecorder is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	ProfileRecorder is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with ProfileRecorder; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

-->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="
http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="
http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
	<xsl:template match="/">
		<html>
			<head>
				<title>My Profile</title>
				<link rel="stylesheet" type="text/css" href="css/Default.css"/>
				<link rel="stylesheet" type="text/css" href="css/ToolTips.css"/>
				<link rel="stylesheet" type="text/css" href="css/Doll.css"/>
				<link rel="stylesheet" type="text/css" href="css/Containers.css"/>
				<script type="text/javascript" src="scripts/Default.js"/>
				<script type="text/javascript" src="scripts/ToolTips.js"/>
				<script type="text/javascript" src="scripts/Bag.js"/>
			</head>
			<body>
				<div id="ToolTips"/>
				<p class="Info">
					Collected Time: <xsl:value-of select="//Time"/>
				</p>
				<p class="Info">
					Game Server Time: <xsl:value-of select="//GameTime"/>
				</p>
				<div id="ProfileInfo">
					<div id="MainInfo">
						<div id="WoWIcon">
							<img src="images/World_of_Warcraft.png"/>
						</div>
						<div id="TextInfo">
							<h3>
								Realm: <xsl:value-of select="//Realm"/>
							</h3>
							<h3>
								Faction: <xsl:value-of select="//Faction/Localized"/>
							</h3>
							<xsl:call-template name="GetBasicInfoIcons">
								<xsl:with-param name="enFaction" select="//Faction/En"/>
								<xsl:with-param name="localizedFaction" select="//Faction/Localized"/>
								<xsl:with-param name="enClass" select="//BasicInfo/Class/En"/>
								<xsl:with-param name="localizedClass" select="//BasicInfo/Class/Localized"/>
								<xsl:with-param name="enSex" select="//BasicInfo/Sex/En"/>
								<xsl:with-param name="localizedSex" select="//BasicInfo/Sex/Localized"/>
							</xsl:call-template>
						</div>
					</div>
					<div id="Doll">
						<div id="BasicInfo">
							<div id="Portrait">
								<xsl:call-template name="GetPortrait">
									<xsl:with-param name="race" select="//BasicInfo/Race/En"/>
									<xsl:with-param name="sex" select="//BasicInfo/Sex/En"/>
								</xsl:call-template>
							</div>
							<div id="TextInfo">
								<xsl:variable name="color">
									<xsl:call-template name="GetColor">
										<xsl:with-param name="class" select="//BasicInfo/Class/En"/>
									</xsl:call-template>
								</xsl:variable>
								<font color="{$color}">
									<xsl:value-of select="//BasicInfo/Name"/>
								</font>
								<div id="Misc"  class="CharacterInfoText">
									Level <xsl:value-of select="//BasicInfo/Level"/>&#160;<xsl:value-of select="//BasicInfo/Race/Localized"/>&#160;<xsl:value-of select="//BasicInfo/Class/Localized"/>
									<br/>
									<xsl:if test="count(//GuildInfo/GuildName)&gt;0">
										<xsl:value-of select="//GuildInfo/GuildName"/>&#160;-&#160;<xsl:value-of select="//GuildInfo/GuildRankName"/>
									</xsl:if>
								</div>
							</div>
						</div>
						<div id="Character">
							<div id="CharacterLeft">
								<xsl:apply-templates select=".//Character/InventoryItems">
									<xsl:with-param name="position" select="'left'"/>
								</xsl:apply-templates>
							</div>
							<div id="CharacterCenter">
								<div id="Info">
									<div id="HpAndMp">
										<div class="HpMpUnit">
											<xsl:variable name="HpPercentage" select=".//HP/Percentage"/>
											<xsl:variable name="HpBorderWidth">
												<xsl:choose>
													<xsl:when test=".//HP/Percentage='0' or .//HP/Percentage='100'">0</xsl:when>
													<xsl:otherwise>2</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<div class="MaxValue">
												<font color="Green">
													<xsl:value-of select=".//HP/Max"/>
												</font>
											</div>
											<div class="FullUnit">
												<div style="background-color: Green; width: {$HpPercentage}%; text-align: center; border-right: solid {$HpBorderWidth}px #cccccc;">
													<xsl:if test="$HpPercentage&gt;30">
														<font class="TextOnBar">
															<xsl:value-of select="concat($HpPercentage, '%')"/>
														</font>
													</xsl:if>
												</div>
											</div>
											<div style="float: right;">
												<font class="CharacterInfoText">HP:</font>
											</div>
										</div>
										<div class="HpMpUnit">
											<xsl:variable name="PowerColor">
												<xsl:call-template name="GetColor">
													<xsl:with-param name="power" select="//Power/Type"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="MpPercentage" select=".//Power/Value/Percentage"/>
											<xsl:variable name="MpBorderWidth">
												<xsl:choose>
													<xsl:when test=".//Power/Value/Percentage='100'">0</xsl:when>
													<xsl:otherwise>2</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<div class="MaxValue">
												<font color="{$PowerColor}">
													<xsl:value-of select=".//Power/Value/Max"/>
												</font>
											</div>
											<div class="FullUnit">
												<div style="background-color: {$PowerColor}; width: {$MpPercentage}%; text-align: center; border-right: solid {$MpBorderWidth}px #cccccc;">
													<xsl:if test="$MpPercentage&gt;30">
														<font class="TextOnBar">
															<xsl:value-of select="concat($MpPercentage, '%')"/>
														</font>
													</xsl:if>
												</div>
											</div>
											<div style="float: right;">
												<font class="CharacterInfoText">
													<xsl:value-of select=".//Power/Type"/>:
												</font>
											</div>
										</div>
									</div>
									<div id="Resistance">
										<xsl:apply-templates select="//Character/Resistance"/>
									</div>
								</div>
								<div style="width: 200px; height: 270px;"/>
								<div id="Weapon">
									<xsl:apply-templates select="//Character/InventoryItems">
										<xsl:with-param name="position" select="'bottom'"/>
									</xsl:apply-templates>
								</div>
							</div>
							<div id="CharacterRight">
								<xsl:apply-templates select="//Character/InventoryItems">
									<xsl:with-param name="position" select="'right'"/>
								</xsl:apply-templates>
							</div>
						</div>
					</div>
				</div>
				<div id="BankAndPortableBags">
					<div id="Bank">
						<div id="Head">Bank</div>
						<div id="Content">
							<xsl:apply-templates select="//Bank"/>
						</div>
						<div id="BankBags">
							<xsl:for-each select="//Bags/node()">
								<xsl:sort select="BagId" data-type="number"/>
								<xsl:if test="starts-with(name(), 'BankBag')">
									<xsl:apply-templates select="Bag">
										<xsl:with-param name="bagName" select="name()"/>
										<xsl:with-param name="bagId" select="BagId"/>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:for-each>
						</div>
					</div>
					<div id="PortableBagsContainer">
						<div id="PortableBags">
							<xsl:for-each select="//Bags/node()">
								<xsl:sort select="BagId" data-type="number" order="descending"/>
								<xsl:if test="starts-with(name(), 'Bag')">
									<xsl:apply-templates select="Bag">
										<xsl:with-param name="bagName" select="name()"/>
										<xsl:with-param name="bagId" select="BagId"/>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:for-each>
							<img id="Backpack" class="Bag" src="images/{substring-before(//Bags/DefaultTexture/Backpack, '.blp')}.png" width="38" height="38"
									 onclick="showBag(this);"/>
						</div>
					</div>
					<div id="PortableBagContent">
						<xsl:for-each select="//Bags/node()">
							<xsl:sort select="BagId" data-type="number"/>
							<xsl:if test="name()='Backpack' or starts-with(name(), 'Bag')">
								<xsl:apply-templates select="Content">
									<xsl:with-param name="bagName" select="name()"/>
								</xsl:apply-templates>
							</xsl:if>
						</xsl:for-each>
					</div>
				</div>
				<div id="BankBagContent">
					<xsl:for-each select="//Bags/node()">
						<xsl:sort select="BagId" data-type="number"/>
						<xsl:if test="starts-with(name(), 'BankBag')">
							<xsl:apply-templates select="Content">
								<xsl:with-param name="bagName" select="name()"/>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:for-each>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Resistance">
		<xsl:for-each select="node()">
			<xsl:if test="name()='Fire'">
				<xsl:call-template name="GetResistanceUnit">
					<xsl:with-param name="base" select="Base"/>
					<xsl:with-param name="total" select="Total"/>
					<xsl:with-param name="bonus" select="Bonus"/>
					<xsl:with-param name="minus" select="Minus"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="node()">
			<xsl:if test="name()='Nature'">
				<xsl:call-template name="GetResistanceUnit">
					<xsl:with-param name="base" select="Base"/>
					<xsl:with-param name="total" select="Total"/>
					<xsl:with-param name="bonus" select="Bonus"/>
					<xsl:with-param name="minus" select="Minus"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="node()">
			<xsl:if test="name()='Arcane'">
				<xsl:call-template name="GetResistanceUnit">
					<xsl:with-param name="base" select="Base"/>
					<xsl:with-param name="total" select="Total"/>
					<xsl:with-param name="bonus" select="Bonus"/>
					<xsl:with-param name="minus" select="Minus"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="node()">
			<xsl:if test="name()='Frost'">
				<xsl:call-template name="GetResistanceUnit">
					<xsl:with-param name="base" select="Base"/>
					<xsl:with-param name="total" select="Total"/>
					<xsl:with-param name="bonus" select="Bonus"/>
					<xsl:with-param name="minus" select="Minus"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="node()">
			<xsl:if test="name()='Shadow'">
				<xsl:call-template name="GetResistanceUnit">
					<xsl:with-param name="base" select="Base"/>
					<xsl:with-param name="total" select="Total"/>
					<xsl:with-param name="bonus" select="Bonus"/>
					<xsl:with-param name="minus" select="Minus"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="InventoryItems">
		<xsl:param name="position"/>
		<xsl:choose>
			<xsl:when test="$position='left'">
				<xsl:for-each select="node()">
					<xsl:if test="name()='HeadSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='NeckSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='ShoulderSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='BackSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='ChestSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='ShirtSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='TabardSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='WristSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$position='right'">
				<xsl:for-each select="node()">
					<xsl:if test="name()='HandsSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='WaistSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='LegsSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='FeetSlot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='Finger0Slot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='Finger1Slot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='Trinket0Slot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="node()">
					<xsl:if test="name()='Trinket1Slot'">
						<div class="InventoryItem">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'38'"/>
							</xsl:apply-templates>
						</div>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$position='bottom'">
				<div id="MainWeapons">
					<xsl:for-each select="node()">
						<xsl:if test="name()='RangedSlot'">
							<div class="WeaponItem">
								<xsl:apply-templates select="Item">
									<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
									<xsl:with-param name="size" select="'38'"/>
								</xsl:apply-templates>
							</div>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="node()">
						<xsl:if test="name()='SecondaryHandSlot'">
							<div class="WeaponItem">
								<xsl:apply-templates select="Item">
									<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
									<xsl:with-param name="size" select="'38'"/>
								</xsl:apply-templates>
							</div>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="node()">
						<xsl:if test="name()='MainHandSlot'">
							<div class="WeaponItem">
								<xsl:apply-templates select="Item">
									<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
									<xsl:with-param name="size" select="'38'"/>
								</xsl:apply-templates>
							</div>
						</xsl:if>
					</xsl:for-each>
				</div>
				<div id="Ammo">
					<xsl:for-each select="node()">
						<xsl:if test="name()='AmmoSlot'">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="DefaultTexture"/>
								<xsl:with-param name="size" select="'32'"/>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:for-each>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Item">
		<xsl:param name="defaultTexture"/>
		<xsl:param name="size"/>
		<xsl:param name="itemCount"/>
		<xsl:choose>
			<xsl:when test="count(Texture)=0">
				<xsl:choose>
					<xsl:when test="$defaultTexture!=''">
						<img src="images/{substring-before($defaultTexture, '.blp')}.png" width="{$size}" height="{$size}"/>
					</xsl:when>
					<xsl:otherwise>
						<div class="BlankSlot"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="texture" select="Texture"/>
				<xsl:variable name="equipInfo">
					<xsl:apply-templates select="Tooltip"/>
				</xsl:variable>
				<xsl:variable name="qualityColor">
					<xsl:call-template name="GetColor">
						<xsl:with-param name="quality" select="Quality"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tooltips" select="concat(
					'&lt;div id=&quot;EquipInfo&quot;&gt;',
						$equipInfo,
						'&lt;br/&gt;&lt;font color=&quot;', $qualityColor, '&quot;&gt;Item Level:', Level, '&lt;/font&gt;',
					'&lt;/div&gt;')"/>
				<div onmouseover="showToolTips();" onmouseout="hideToolTips();" onmousemove="updateToolTips(event, '{$tooltips}');">
					<img src="images/{$texture}.png" width="{$size}" height="{$size}"/>
					<xsl:if test="$itemCount!='' and $itemCount&gt;1">
						<div class="ItemCount" style="top: {$size - 18}; left: {$size - 28}">
							<xsl:variable name="itemCountDisplay">
								<xsl:choose>
									<xsl:when test="$itemCount&lt;10">
										<xsl:value-of select="concat('&#160;&#160;&#160;&#160;', $itemCount)"/>
									</xsl:when>
									<xsl:when test="$itemCount&gt;9 and $itemCount&lt;100">
										<xsl:value-of select="concat('&#160;&#160;', $itemCount)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$itemCount"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$itemCountDisplay"/>
						</div>
					</xsl:if>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Tooltip">
		<xsl:for-each select="node()">
			<xsl:sort select="Line" data-type="number"/>
			<!-- Avoid to parse empty node, such as plan text "/n/n/t". -->
			<xsl:if test="count(node())&gt;0">
				<xsl:variable name="leftText">
					<xsl:variable name="textColor">
						<xsl:call-template name="GetColor">
							<xsl:with-param name="r" select="Left/Color/R"/>
							<xsl:with-param name="g" select="Left/Color/G"/>
							<xsl:with-param name="b" select="Left/Color/B"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="GetFormattedText">
						<xsl:with-param name="line" select="Line"/>
						<xsl:with-param name="color" select="$textColor"/>
						<xsl:with-param name="alpha" select="Left/Color/Alpha"/>
						<xsl:with-param name="text" select="Left/Text"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="rightText">
					<xsl:variable name="textColor">
						<xsl:call-template name="GetColor">
							<xsl:with-param name="r" select="Right/Color/R"/>
							<xsl:with-param name="g" select="Right/Color/G"/>
							<xsl:with-param name="b" select="Right/Color/B"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="GetFormattedText">
						<xsl:with-param name="line" select="Line"/>
						<xsl:with-param name="color" select="$textColor"/>
						<xsl:with-param name="alpha" select="Right/Color/Alpha"/>
						<xsl:with-param name="text" select="Right/Text"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="icon">
					<xsl:if test="count(Left/Texture)&gt;0">
						<xsl:value-of select="concat('&lt;img id=&quot;Icon&quot; src=&quot;images/', Left/Texture/Path, '.png&quot;/&gt;')"/>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat(
					'&lt;p&gt;',
						'&lt;div id=&quot;TextLine&quot;&gt;',
							'&lt;div id=&quot;LeftText&quot;&gt;', $icon, $leftText, '&lt;/div&gt;',
							'&lt;div id=&quot;RightText&quot;&gt;', $rightText, '&lt;/div&gt;',
						'&lt;/div&gt;',
					'&lt;/p&gt;')"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="Bank">
		<xsl:for-each select="node()">
			<xsl:sort select="SlotId" data-type="number"/>
			<xsl:if test="count(node())&gt;0">
				<div class="ContainerItem">
					<xsl:apply-templates select="Item">
						<xsl:with-param name="size" select="'38'"/>
						<xsl:with-param name="itemCount" select="ItemCount"/>
					</xsl:apply-templates>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="Bag">
		<xsl:param name="bagName"/>
		<xsl:param name="bagId"/>
		<xsl:choose>
			<xsl:when test="count(Texture)=0">
				<img id="{concat('BlankBankBag', $bagId)}" class="BlankBagSlot" src="images/{substring-before(//Bags/DefaultTexture/BagSlot, '.blp')}.png" width="38" height="38"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="texture" select="Texture"/>
				<xsl:variable name="equipInfo">
					<xsl:apply-templates select="Tooltip"/>
				</xsl:variable>
				<xsl:variable name="qualityColor">
					<xsl:call-template name="GetColor">
						<xsl:with-param name="quality" select="Quality"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tooltips" select="concat(
					'&lt;div id=&quot;EquipInfo&quot;&gt;',
						$equipInfo,
						'&lt;br/&gt;&lt;font color=&quot;', $qualityColor, '&quot;&gt;Item Level:', Level, '&lt;/font&gt;',
					'&lt;/div&gt;')"/>
				<img id="{$bagName}" class="Bag" src="images/{Texture}.png" width="38" height="38" onclick="showBag(this);" 
						 onmouseover="showToolTips();" onmouseout="hideToolTips();" onmousemove="updateToolTips(event, '{$tooltips}');"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Content">
		<xsl:param name="bagName"/>
		<xsl:variable name="defaultSlotTexture" select="../../DefaultTexture/ItemSlot"/>
		<div id="{concat($bagName, 'Content')}" class="BagContent">
			<div class="BagTitle">
				<div class="BagName">
					<xsl:value-of select="$bagName"/>
				</div>
				<div class="CloseBag" onclick="this.parentElement.parentElement.style.display='none';">
					<img src="images/Close.png" width="15px" height="15px"/>
				</div>
			</div>
			<xsl:for-each select="node()">
				<xsl:sort select="SlotId" data-type="number"/>
				<xsl:if test="count(node())&gt;0">
					<div class="ContainerItem">
						<xsl:if test="SlotId&gt;0">
							<xsl:apply-templates select="Item">
								<xsl:with-param name="defaultTexture" select="$defaultSlotTexture"/>
								<xsl:with-param name="size" select="'38'"/>
								<xsl:with-param name="itemCount" select="ItemCount"/>
							</xsl:apply-templates>
						</xsl:if>
					</div>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template name="GetBasicInfoIcons">
		<xsl:param name="enFaction"/>
		<xsl:param name="localizedFaction"/>
		<xsl:param name="enClass"/>
		<xsl:param name="localizedClass"/>
		<xsl:param name="enSex"/>
		<xsl:param name="localizedSex"/>
		<img src="images/Factions/{$enFaction}.png" alt="{$localizedFaction}" width="32" height="32"/>&#160;
		<img src="images/Classes/{$enClass}.png" alt="{$localizedClass}" width="32" height="32"/>&#160;
		<img src="images/Gender/{$enSex}.png" alt="{$localizedSex}" width="32" height="32"/>
	</xsl:template>
	<xsl:template name="GetPortrait">
		<xsl:param name="race"/>
		<xsl:param name="sex"/>
		<xsl:variable name="path" select="concat($race, '-', $sex)" />
		<img src="images/Races/{$path}.png"/>
	</xsl:template>
	<xsl:template name="GetColor">
		<xsl:param name="class"/>
		<xsl:param name="power"/>
		<xsl:param name="quality"/>

		<xsl:param name="r"/>
		<xsl:param name="g"/>
		<xsl:param name="b"/>

		<xsl:choose>
			<xsl:when test="$class='DRUID'">#FF7D0A</xsl:when>
			<xsl:when test="$class='HUNTER'">#ABD473</xsl:when>
			<xsl:when test="$class='MAGE'">#69CCF0</xsl:when>
			<xsl:when test="$class='PALADIN'">#F58CBA</xsl:when>
			<xsl:when test="$class='PRIEST'">#FFFFFF</xsl:when>
			<xsl:when test="$class='ROGUE'">#FFF569</xsl:when>
			<xsl:when test="$class='SHAMAN'">#2459FF</xsl:when>
			<xsl:when test="$class='WARLOCK'">#9482CA</xsl:when>
			<xsl:when test="$class='WARRIOR'">#C79C6E</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$power='Rage'">Red</xsl:when>
			<xsl:when test="$power='Energy'">Yellow</xsl:when>
			<xsl:when test="$power='Mana'">#000FFF</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$quality='0'">Gray</xsl:when>
			<xsl:when test="$quality='1'">White</xsl:when>
			<xsl:when test="$quality='2'">#1EFF00</xsl:when>
			<xsl:when test="$quality='3'">#0080ff</xsl:when>
			<xsl:when test="$quality='4'">#b048f8</xsl:when>
			<xsl:when test="$quality='5'">#F07902</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="$r!='' and $g!='' and $b!=''">
				<xsl:value-of select="concat('#', $r, $g, $b)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetResistanceUnit">
		<xsl:param name="base"/>
		<xsl:param name="total"/>
		<xsl:param name="bonus"/>
		<xsl:param name="minus"/>
		<xsl:variable name="bonusSnippet">
			<xsl:choose>
				<xsl:when test="$bonus!='0'">
					<xsl:value-of select="concat('&lt;font color=Green&gt;+', $bonus)"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="minusSnippet">
			<xsl:choose>
				<xsl:when test="$minus!='0'">
					<xsl:value-of select="concat('&lt;font color=Red&gt;-', $minus, '&lt;/font&gt;')"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="toolTips" select="concat('&lt;b&gt;&lt;font color=white&gt;', $base, '&lt;/font&gt;', $bonusSnippet, $minusSnippet, '&lt;/b&gt;')"/>
		<div class="ResistanceItem" onmouseover="showToolTips();" onmouseout="hideToolTips();" onmousemove="updateToolTips(event, '{$toolTips}');">
			<xsl:value-of select="$total"/>
		</div>
	</xsl:template>
	<xsl:template name="GetFormattedText">
		<xsl:param name="line"/>
		<xsl:param name="color"/>
		<xsl:param name="alpha"/>
		<xsl:param name="text"/>
		<xsl:variable name="preBoldText">
			<xsl:choose>
				<xsl:when test="$line='1'">
					<xsl:value-of select="concat('&lt;b&gt;', $text, '&lt;/b&gt;')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat('&lt;div style=&quot;color: ', $color, ';filter: Alpha(opacity=0);&quot;&gt;', $preBoldText, '&lt;/div&gt;')"/>
	</xsl:template>
	<!-- TEST -->
	<xsl:template name="MyTest">
		<xsl:param name="param"/>
		<xsl:param name="another"/>
		<xsl:value-of select="'$param' mul '$another'"/>
	</xsl:template>
</xsl:stylesheet>