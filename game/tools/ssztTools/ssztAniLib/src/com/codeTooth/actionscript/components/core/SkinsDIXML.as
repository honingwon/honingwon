// 皮肤注入XML

private var _skinsDIXML:XML = new XML(
<data>
	<!-- 文本输入框 -->
	<item id="textInputBackgroundEnabled" type="com.codeTooth.actionscript.components.skins.textInput.TextInputBackgroundEnabled"/>
	<item id="textInputBackgroundDisabled" type="com.codeTooth.actionscript.components.skins.textInput.TextInputBackgroundDisabled"/>
	<!-- 标准按钮 -->
	<item id="buttonMouseOut" type="com.codeTooth.actionscript.components.skins.button.ButtonMouseOut"/>
	<item id="buttonMouseOver" type="com.codeTooth.actionscript.components.skins.button.ButtonMouseOver"/>
	<item id="buttonMouseDown" type="com.codeTooth.actionscript.components.skins.button.ButtonMouseDown"/>
	<item id="buttonDisabled" type="com.codeTooth.actionscript.components.skins.button.ButtonDisabled"/>
	<item id="buttonSelectedMouseOut" type="com.codeTooth.actionscript.components.skins.button.ButtonSelectedMouseOut"/>
	<item id="buttonSelectedMouseOver" type="com.codeTooth.actionscript.components.skins.button.ButtonSelectedMouseOver"/>
	<item id="buttonSelectedMouseDown" type="com.codeTooth.actionscript.components.skins.button.ButtonSelectedMouseDown"/>
	<item id="buttonSelectedDisabled" type="com.codeTooth.actionscript.components.skins.button.ButtonSelectedDisabled"/>
	<!-- 多选按钮 -->
	<item id="checkBoxMouseOut" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxMouseOut"/>
	<item id="checkBoxMouseOver" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxMouseOver"/>
	<item id="checkBoxMouseDown" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxMouseDown"/>
	<item id="checkBoxDisabled" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxDisabled"/>
	<item id="checkBoxSelectedMouseOut" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxSelectedMouseOut"/>
	<item id="checkBoxSelectedMouseOver" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxSelectedMouseOver"/>
	<item id="checkBoxSelectedMouseDown" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxSelectedMouseDown"/>
	<item id="checkBoxSelectedDisabled" type="com.codeTooth.actionscript.components.skins.checkBox.CheckBoxSelectedDisabled"/>
	<!-- 单选按钮 -->
	<item id="radioButtonMouseOut" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonMouseOut"/>
	<item id="radioButtonMouseOver" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonMouseOver"/>
	<item id="radioButtonMouseDown" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonMouseDown"/>
	<item id="radioButtonMouseDisabled" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonMouseDisabled"/>
	<item id="radioButtonSelectedMouseOut" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonSelectedMouseOut"/>
	<item id="radioButtonSelectedMouseOver" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonSelectedMouseOver"/>
	<item id="radioButtonSelectedMouseDown" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonSelectedMouseDown"/>
	<item id="radioButtonSelectedDisabled" type="com.codeTooth.actionscript.components.skins.radioButton.RadioButtonSelectedDisabled"/>
	<!-- 进度条 -->
	<item id="progressBarBackground" type="com.codeTooth.actionscript.components.skins.progressBar.ProgressBarBackground"/>
	<item id="progressBarBar" type="com.codeTooth.actionscript.components.skins.progressBar.ProgressBarBar"/>
	<!-- 滚动条 -->
	<item id="scrollBarUpArrowMouseOut" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarUpArrowMouseOut"/>
	<item id="scrollBarUpArrowMouseOver" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarUpArrowMouseOver"/>
	<item id="scrollBarUpArrowMouseDown" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarUpArrowMouseDown"/>
	<item id="scrollBarUpArrowDisabled" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarUpArrowDisabled"/>
	<item id="scrollBarDownArrowMouseOut" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarDownArrowMouseOut"/>
	<item id="scrollBarDownArrowMouseOver" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarDownArrowMouseOver"/>
	<item id="scrollBarDownArrowMouseDown" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarDownArrowMouseDown"/>
	<item id="scrollBarDownArrowDisabled" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarDownArrowDisabled"/>
	<item id="scrollBarTrackEnabled" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarTrackEnabled"/>
	<item id="scrollBarTrackDisabled" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarTrackDisabled"/>
	<item id="scrollBarBarMouseOut" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarBarMouseOut"/>
	<item id="scrollBarBarMouseOver" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarBarMouseOver"/>
	<item id="scrollBarBarMouseDown" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarBarMouseDown"/>
	<item id="scrollBarBarDisabled" type="com.codeTooth.actionscript.components.skins.scrollBar.ScrollBarBarDisabled"/>
	<!-- 文本区 -->
	<item id="textAreaBackgroundEnabled" type="com.codeTooth.actionscript.components.skins.textArea.TextAreaBackgroundEnabled"/>
	<item id="textAreaBackgroundDisabled" type="com.codeTooth.actionscript.components.skins.textArea.TextAreaBackgroundDisabled"/>
	<!-- 数字递增器 -->
	<item id="increaseButtonMouseOut" type="com.codeTooth.actionscript.components.skins.numericStepper.IncreaseButtonMouseOut"/>
	<item id="increaseButtonMouseOver" type="com.codeTooth.actionscript.components.skins.numericStepper.IncreaseButtonMouseOver"/>
	<item id="increaseButtonMouseDown" type="com.codeTooth.actionscript.components.skins.numericStepper.IncreaseButtonMouseDown"/>
	<item id="increaseButtonDisabled" type="com.codeTooth.actionscript.components.skins.numericStepper.IncreaseButtonDisabled"/>
	<item id="decreaseButtonMouseOut" type="com.codeTooth.actionscript.components.skins.numericStepper.DecreaseButtonMouseOut"/>
	<item id="decreaseButtonMouseOver" type="com.codeTooth.actionscript.components.skins.numericStepper.DecreaseButtonMouseOver"/>
	<item id="decreaseButtonMouseDown" type="com.codeTooth.actionscript.components.skins.numericStepper.DecreaseButtonMouseDown"/>
	<item id="decreaseButtonDisabled" type="com.codeTooth.actionscript.components.skins.numericStepper.DecreaseButtonDisabled"/>
</data>
)