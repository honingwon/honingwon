// 组件注入XML

private var _componentsDIXML:XML = new XML(
<data>
	<!-- 标签 -->
	<item id="label" type="com.codeTooth.actionscript.components.controls.Label">
		<content method="this.setStylesManager">
			<parameter property1="stylesManager"/>
		</content>
		<content property1="this.styleName" string="labelStyle"/>
		<content method="this.updateStyle"/>
	</item>
	<!-- 文本输入框 -->
	<item id="textInput" type="com.codeTooth.actionscript.components.controls.TextInput">
		<content method="this.setStylesManager">
			<parameter property1="stylesManager"/>
		</content>
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.styleName" string="textInputStyle"/>
		<content property1="this.skinNameBackgroundEnabled" string="textInputBackgroundEnabled"/>
		<content property1="this.skinNameBackgroundDisabled" string="textInputBackgroundDisabled"/>
		<content method="this.updateSkin"/>
		<content method="this.updateStyle"/>
	</item>
	<!-- 标准按钮 -->
	<item id="button" type="com.codeTooth.actionscript.components.controls.Button">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content method="this.setStylesManager">
			<parameter property1="stylesManager"/>
		</content>
		<content property1="this.styleName" string="buttonStyle"/>
		<content property1="this.skinNameMouseOut" string="buttonMouseOut"/>
		<content property1="this.skinNameMouseOver" string="buttonMouseOver"/>
		<content property1="this.skinNameMouseDown" string="buttonMouseDown"/>
		<content property1="this.skinNameDisabled" string="buttonDisabled"/>
		<content property1="this.skinNameSelectedMouseOut" string="buttonSelectedMouseOut"/>
		<content property1="this.skinNameSelectedMouseOver" string="buttonSelectedMouseOver"/>
		<content property1="this.skinNameSelectedMouseDown" string="buttonSelectedMouseDown"/>
		<content property1="this.skinNameSelecedDisabled" string="buttonSelectedDisabled"/>
		<content method="this.updateSkin"/>
		<content method="this.updateStyle"/>
	</item>
	<!-- 多选按钮 -->
	<item id="checkBox" type="com.codeTooth.actionscript.components.controls.CheckBox">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content method="this.setStylesManager">
			<parameter property1="stylesManager"/>
		</content>
		<content property1="this.styleName" string="checkBoxStyle"/>
		<content property1="this.skinNameMouseOut" string="checkBoxMouseOut"/>
		<content property1="this.skinNameMouseOver" string="checkBoxMouseOver"/>
		<content property1="this.skinNameMouseDown" string="checkBoxMouseDown"/>
		<content property1="this.skinNameDisabled" string="checkBoxDisabled"/>
		<content property1="this.skinNameSelectedMouseOut" string="checkBoxSelectedMouseOut"/>
		<content property1="this.skinNameSelectedMouseOver" string="checkBoxSelectedMouseOver"/>
		<content property1="this.skinNameSelectedMouseDown" string="checkBoxSelectedMouseDown"/>
		<content property1="this.skinNameSelecedDisabled" string="checkBoxSelectedDisabled"/>
		<content method="this.updateSkin"/>
		<content method="this.updateStyle"/>
	</item>
	<!-- 进度条 -->
	<item id="progressBar" type="com.codeTooth.actionscript.components.controls.ProgressBar">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameBackground" string="progressBarBackground"/>
		<content property1="this.skinNameBar" string="progressBarBar"/>
		<content method="this.updateSkin"/>
	</item>
	<!-- V滚动条 -->
	<item id="vScrollBar" type="com.codeTooth.actionscript.components.controls.VScrollBar">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameTrackEnabled" string="scrollBarTrackEnabled"/>
		<content property1="this.skinNameTrackDisabled" string="scrollBarTrackDisabled"/>
		<content method="this.updateSkin"/>
	</item>
	<item id="scrollBarUpArrow" type="com.codeTooth.actionscript.components.controls.scrollBarClasses.ScrollBarUpArrow">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameMouseOut" string="scrollBarUpArrowMouseOut"/>
		<content property1="this.skinNameMouseOver" string="scrollBarUpArrowMouseOver"/>
		<content property1="this.skinNameMouseDown" string="scrollBarUpArrowMouseDown"/>
		<content property1="this.skinNameDisabled" string="scrollBarUpArrowDisabled"/>
		<content method="this.updateSkin"/>
	</item>
	<item id="scrollBarDownArrow" type="com.codeTooth.actionscript.components.controls.scrollBarClasses.ScrollBarDownArrow">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameMouseOut" string="scrollBarDownArrowMouseOut"/>
		<content property1="this.skinNameMouseOver" string="scrollBarDownArrowMouseOver"/>
		<content property1="this.skinNameMouseDown" string="scrollBarDownArrowMouseDown"/>
		<content property1="this.skinNameDisabled" string="scrollBarDownArrowDisabled"/>
		<content method="this.updateSkin"/>
	</item>
	<item id="scrollBarBar" type="com.codeTooth.actionscript.components.controls.scrollBarClasses.ScrollBarBar">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameMouseOut" string="scrollBarBarMouseOut"/>
		<content property1="this.skinNameMouseOver" string="scrollBarBarMouseOver"/>
		<content property1="this.skinNameMouseDown" string="scrollBarBarMouseDown"/>
		<content property1="this.skinNameDisabled" string="scrollBarBarDisabled"/>
		<content method="this.updateSkin"/>
	</item>
	<!-- 单选按钮 -->
	<item id="radioButton" type="com.codeTooth.actionscript.components.controls.RadioButton">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content method="this.setStylesManager">
			<parameter property1="stylesManager"/>
		</content>
		<content property1="this.styleName" string="radioButtonStyle"/>
		<content property1="this.skinNameMouseOut" string="radioButtonMouseOut"/>
		<content property1="this.skinNameMouseOver" string="radioButtonMouseOver"/>
		<content property1="this.skinNameMouseDown" string="radioButtonMouseDown"/>
		<content property1="this.skinNameDisabled" string="radioButtonMouseDisabled"/>
		<content property1="this.skinNameSelectedMouseOut" string="radioButtonSelectedMouseOut"/>
		<content property1="this.skinNameSelectedMouseOver" string="radioButtonSelectedMouseOver"/>
		<content property1="this.skinNameSelectedMouseDown" string="radioButtonSelectedMouseDown"/>
		<content property1="this.skinNameSelecedDisabled" string="radioButtonSelectedDisabled"/>
		<content method="this.updateSkin"/>
		<content method="this.updateStyle"/>
	</item>
	<!-- 文本区 -->
	<item id="textArea" type="com.codeTooth.actionscript.components.controls.TextArea">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content method="this.setStylesManager">
			<parameter property1="stylesManager"/>
		</content>
		<content property1="this.styleName" string="textAreaStyle"/>
		<content property1="this.skinNameBackgroundDisabled" string="textAreaBackgroundDisabled"/>
		<content property1="this.skinNameBackgroundEnabled" string="textAreaBackgroundEnabled"/>
		<content method="this.updateStyle"/>
		<content method="this.updateSkin"/>
	</item>
	<!-- 数字递增器 -->
	<item id="numericStepper" type="com.codeTooth.actionscript.components.controls.NumericStepper"/>
	<item id="increaseButton" type="com.codeTooth.actionscript.components.controls.numericStepperClasses.IncreaseButton">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameMouseOut" string="increaseButtonMouseOut"/>
		<content property1="this.skinNameMouseOver" string="increaseButtonMouseOver"/>
		<content property1="this.skinNameMouseDown" string="increaseButtonMouseDown"/>
		<content property1="this.skinNameDisabled" string="increaseButtonDisabled"/>
		<content method="this.updateSkin"/>
	</item>
	<item id="decreaseButton" type="com.codeTooth.actionscript.components.controls.numericStepperClasses.DecreaseButton">
		<content method="this.setSkinsManager">
			<parameter property1="skinsManager"/>
		</content>
		<content property1="this.skinNameMouseOut" string="decreaseButtonMouseOut"/>
		<content property1="this.skinNameMouseOver" string="decreaseButtonMouseOver"/>
		<content property1="this.skinNameMouseDown" string="decreaseButtonMouseDown"/>
		<content property1="this.skinNameDisabled" string="decreaseButtonDisabled"/>
		<content method="this.updateSkin"/>
	</item>
</data>
);