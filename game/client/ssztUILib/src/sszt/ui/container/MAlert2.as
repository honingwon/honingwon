/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-5 下午3:40:50 
 * 
 */ 
package sszt.ui.container
{
	import fl.controls.CheckBox;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import sszt.ui.UIManager;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.styles.TextFormatType;
	import sszt.ui.styles.TextGlowFilterType;
	
	public class MAlert2 extends MAlert {
		
		private static var _closeHandler:Function;
		private static var priority:int = 1;
		
		private var _label:String;
		private var _noAlertCheckBox:CheckBox;
		private var _callBack:Function;
		private var _noAlertType:int;
		
		public function MAlert2(message:String="", title:String=null, flags:uint=4, parent:DisplayObjectContainer=null, closeHandler:Function=null, textAlign:String="center", width:Number=-1, closeAble:Boolean=true, appStyle:Boolean=true, checkBoxLabel:String="", mod:Number=0, toCenter:Boolean=true){
			_closeHandler = closeHandler;
			_label = checkBoxLabel;
			super(message, title, flags, parent, closeHandler, textAlign, width, closeAble, appStyle, mod, toCenter);
			_paddingTop = 25;
			_titleTopOffset = 6;
		}
		public static function show(message:String="", title:String=null, flags:uint=4, parent:DisplayObjectContainer=null, closeHandler:Function=null, textAlign:String="center", width:Number=-1, closeAble:Boolean=true, applyStyle:Boolean=true, checkBoxLabel:String="", mod:Number=0, toCenter:Boolean=true):MAlert{
			priority++;
			var alert:MAlert2 = new MAlert2(message, title, flags, parent, closeHandler, textAlign, width, closeAble, applyStyle, checkBoxLabel, mod, toCenter);
			if (parent){
				parent.addChild(alert);
			} 
			else {
				UIManager.PARENT.addChild(alert);
			}
			alert.listenKey();
			return (alert);
		}
		public static function getCurrentType(flag:uint):int{
			if (flag & MAlert.OK){
				return MAlert.OK;
			}
			if (flag & MAlert.YES){
				return MAlert.YES;
			}
			if (flag & MAlert.AGREE)
			{
				return (MAlert.AGREE);
			}
			if (flag & MAlert.GO_RIGHTNOW)
			{
				return (MAlert.GO_RIGHTNOW);
			}
			return 0;
		}
		
		override protected function drawLayout():void{
			_contentTxt.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,"center",null,null,null,8);
			_contentTxt.htmlText = _message;
			if(_applyStyle)
			{
				var contentTxtFormat:TextFormat = TextFormatType.cloneFormat1();
				contentTxtFormat.align = _textAlign;
//				_contentTxt.defaultTextFormat = contentTxtFormat;
			}
			if(_setWidth > MAX_TEXTWIDTH)
			{
				_contentTxt.width = _setWidth;
			}
			else
			{
				_contentTxt.width = Math.min(_contentTxt.textWidth,MAX_TEXTWIDTH);
				_contentTxt.width = Math.max(_contentTxt.width,(buttonWidth * 2 + _button_space),MIN_TEXTWIDTH);
			}
			_contentTxt.height = _contentTxt.textHeight + _paddingTop + 14;
			
			var bgWidth:Number = _paddingWidth*2 + _contentTxt.width + 40;
			var bgHeight:Number = _contentTxt.height + 50;  //buttonHeight + _titleHeight + 20;
			setContentSize(bgWidth,bgHeight);
			
			var count:int = _buttons.length;
			var buttonsWidth:int = buttonWidth * count + (count-1) * _button_space;
			if((buttonsWidth + _paddingWidth * 2) > bgWidth)
			{
				bgWidth = buttonsWidth + _paddingWidth * 2 + 30;
				_contentTxt.width = buttonsWidth;
				setContentSize(bgWidth,bgHeight);
			}
			_titleTxt.width = _titleTxt.textWidth + 20;
			_titleTxt.height = 22;
			//			_titleTxt.x = (bgWidth - _titleTxt.width) / 2 + 10;
			//			_titleTxt.y = _paddingTop;
			_contentTxt.x = _paddingWidth + 20;
			_contentTxt.y = _paddingTop ;
			var btnX:int = (bgWidth + _paddingWidth - buttonsWidth)/2;
			for each(var b:DisplayObject in _buttons)
			{
				b.x = btnX;
				btnX += buttonWidth + _button_space;
				b.y = _contentTxt.y + _contentTxt.height + 11;
				addContent(b);
			}
			
			_noAlertCheckBox = new CheckBox();
			_noAlertCheckBox.setStyle("textFormat",new TextFormat("SimSun",12,0xFF9900));
			_noAlertCheckBox.label = _label;
			_noAlertCheckBox.setSize(150, 17);
			_noAlertCheckBox.move(25,_contentTxt.y + _contentTxt.height-24);
//			_noAlertCheckBox.x = 12;
//			_noAlertCheckBox.y = _contentTxt.y + _contentTxt.height + 13;
			_noAlertCheckBox.drawNow();
			addContent(_noAlertCheckBox);
//			setToBackgroup([new BackgroundInfo(BackgroundType.BORDER_2, new Rectangle(12, 4, (_totalWidth - 36), (_contentTxt.textHeight + 22)))]);
			super.subFunction();
		}
		override public function doCallBack(flag:uint):void{
			if (_closeHandler != null){
				_closeHandler(new CloseEvent(CloseEvent.CLOSE, false, false, flag, _noAlertCheckBox.selected, [_callBack, _noAlertType]));
			}
		}
		public function setNoAlertData(callBack:Function, type:int):void{
			_callBack = callBack;
			_noAlertType = type;
		}
		override public function move(x:Number, y:Number):void{
			super.move(x, y);
//			x = x;
//			y = y;
		}
		
		override protected function keyUpHandler(evt:KeyboardEvent):void{
			if (_mode >= 0){
				evt.stopImmediatePropagation();
			}
			if (evt.keyCode == Keyboard.ENTER){
				doEnterHandler();
			} else {
				if (evt.keyCode == Keyboard.ESCAPE){
					doEscHandler();
				}
			}
		}
		override public function dispose():void{
			_noAlertCheckBox = null;
			super.dispose();
		}
		
	}
}