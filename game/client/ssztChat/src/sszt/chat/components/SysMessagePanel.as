package sszt.chat.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.ColorUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	public class SysMessagePanel implements ITick
	{
		private var _container:DisplayObjectContainer;
		
		private static var _pattern:RegExp = /\{[^\}]*\}/g;
		
		private var _poses:Array;
		private var _showList:Array;
		private var _hideList:Array;
		private var _startTime:Number;
		private var _bgList:Array;
		
		
		public function SysMessagePanel(container:DisplayObjectContainer)
		{
			_container = container;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_poses = [];
			_showList = [];
			_hideList = [];
			for(var i:int = 0; i < 3; i++)
			{
				var textfield:TextField = new TextField();
				textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFF00,true,null,null,null,null,TextFormatAlign.CENTER);
				textfield.filters = [new GlowFilter(0x1D250E,1,2,2,4.5)];
				textfield.cacheAsBitmap = true;
				textfield.width = CommonConfig.GAME_WIDTH - 300;
				textfield.height = 24;
				textfield.mouseEnabled = textfield.mouseWheelEnabled = false;
				_poses.push(new Point(CommonConfig.GAME_WIDTH / 2 - 320,i * 25 + 90));
				_hideList.push(textfield);
			}
			gameSizeChangeHandler(null);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			var i:TextField;
			var j:TextField;
			var p:Point;
			var bg:Bitmap;
			for each (i in this._showList) {
				i.width = CommonConfig.GAME_WIDTH;
			}
			for each (j in this._hideList) {
				j.width = CommonConfig.GAME_WIDTH;
			}
			for each (p in this._poses) {
				p.x = 0;
			}
			for each (bg in this._bgList) {
				if (bg){
					bg.x = ((CommonConfig.GAME_WIDTH * 0.5) - 274);
				}
			}
			
//			for each(var i:TextField in _showList)
//			{
////				i.x = CommonConfig.GAME_WIDTH / 2 - 320;
////				i.width = CommonConfig.GAME_WIDTH - 350;
//			}
//			for each(var p:Point in _poses)
//			{
//				p.x = CommonConfig.GAME_WIDTH / 2 - 320;
//			}
		}
		
//		public function appendMessage(mes:String):void
//		{
//			var list:Array = mes.match(_pattern);
//			var colors:Array = [];
//			if(list != null && list.length > 0)
//			{
//				for(var p:int = 0; p < list.length; p++)
//				{
//					var parms:Array = String(list[p]).slice(3,String(list[p]).length-1).split("-");
//					if(parms[1])
//					{
//						var formatInfo:RichTextFormatInfo = new RichTextFormatInfo();
//						formatInfo.index = mes.indexOf(list[p]);
//						formatInfo.length = parms[1].length;
//						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,int(parms[0]));
//						colors.push(formatInfo);
//					}
//					mes = mes.replace(list[p],parms[1]);
//				}
//			}
//			var field:TextField = getTextField();
//			field.text = mes;
//			for each(var info:RichTextFormatInfo in colors)
//			{
//				field.setTextFormat(info.textFormat,info.index,info.index + info.length);
//			}
//			_showList.push(field);
//			for(var i:int = 0; i < _showList.length; i++)
//			{
//				_showList[i].x = _poses[i].x;
//				_showList[i].y = _poses[i].y;
//			}
//			_startTime = getTimer();
//			GlobalAPI.tickManager.addTick(this);
//		}
		
		
		public function appendMessage(message:String):void{
			var parms:Array;
			var formatInfo:RichTextFormatInfo;
			var formatInfo1:RichTextFormatInfo;
			var colorValue:String;
			var replaceText:String;
			var template:ItemTemplateInfo;
			var info:RichTextFormatInfo;
			var j:int;
			var i:int;
			var str1:String;
			var str2:String;
			var str3:String;
			var templen:int;
			var templen1:int;
//			var _local18:int;
//			var _local19:String;
//			var _local20:uint;
//			var _local21:uint;
//			var _local22:uint;
//			var _local23:uint;
			var list:Array = message.match(_pattern);
			var colors:Array = [];
			var index:int;
			parms = [];
			var formatList:Array = [];
			if(list != null && list.length > 0){
				i = 0;
				while (i < list.length) {
					index = message.indexOf(list[i]);
					parms = String(list[i]).slice(2, (String(list[i]).length - 1)).split("-");
					switch (message.charAt(index + 1))
					{
						case "N": //人物名称
							str1 = "【" + parms[0] + "】";
							str2 = GlobalData.selfPlayer.nick;
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = str1.length;
							if (parms[0] == str2){
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0x8FD947);
							} 
							else {
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0x35C3F7);
							}
							formatList.push(formatInfo);
							message = message.replace(list[i], str1);
							break;
						case "I": //物品
							template = ItemTemplateList.getTemplate(int(parms[0]));
							replaceText = template.name;
							if (int(parms[1]) > 0){
								replaceText = ((template.name + " +") + parms[1]);
							}
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							message = message.replace(list[i], replaceText);
							break;
						case "A": //强化
							template = ItemTemplateList.getTemplate(int(parms[2]));
							replaceText = "【" +  template.name + "】";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							replaceText += "强化到完美";
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							if (int(parms[3]) > 0){
								replaceText += "【+" +  parms[3] + "】";
							}
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0xFF0000 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "B": //强化
							template = ItemTemplateList.getTemplate(int(parms[2]));
							replaceText = "【" +  template.name + "】";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							replaceText += "升级到";
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							if (int(parms[3]) > 0){
								replaceText += "【" +  parms[3] + "】级";
							}
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0xFF0000 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "E":
							template = ItemTemplateList.getTemplate(int(parms[2]));
							replaceText = "【" +  template.name + "】";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							replaceText += "精炼到";
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							if (int(parms[3]) > 0){
								replaceText += "[橙色]品质";
							}
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0xFF6600 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "G":
							template = ItemTemplateList.getTemplate(int(parms[2]));
							replaceText = "【" +  template.name + "】";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							message = message.replace(list[i], replaceText);
							break;
						case "D": //挑战副本
							replaceText =  "【" +  parms[0] + "】";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0x00FF00);
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							
							if (int(parms[1]) > 0){
								replaceText += "【" +  parms[1] + "波】";
							}
							
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, 0xFF0000 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "S":
							replaceText =  "[" +  parms[2] + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, parms[1]);
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							message = message.replace(list[i], replaceText);
							break;
						
						
//						case "T":
//							_local18 = parseInt(parms[0]);
//							_local19 = BoxType.getBoxNameByType(_local18);
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.index = index;
//							formatInfo.length = _local19.length;
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, BoxType.getColorByType(_local18));
//							formatList.push(formatInfo);
//							message = message.replace(list[i], _local19);
//							break;
//						case "C":
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.index = index;
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, parms[0]);
//							formatInfo.length = parms[1].length;
//							formatList.push(formatInfo);
//							message = message.replace(list[i], parms[1]);
//							break;
//						case "D":
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.index = 0;
//							formatInfo.length = -1;
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, list[i].slice(2, (String(list[i]).length - 1)));
//							formatList.push(formatInfo);
//							message = message.replace(list[i], "");
//							break;
						
//						case "P":
//							replaceText = parms[3];
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor(parms[2]));
//							formatInfo.index = index;
//							formatInfo.length = replaceText.length;
//							formatList.push(formatInfo);
//							message = message.replace(list[i], replaceText);
//							break;
//						case "M":
//							mountsTemplate = MountsBornTemplateList.getByTemplateId(parms[2]);
//							replaceText = parms[3];
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, CategoryType.getQualityColor((mountsTemplate.qualityLevel + 1)));
//							formatInfo.index = index;
//							formatInfo.length = replaceText.length;
//							formatList.push(formatInfo);
//							message = message.replace(list[i], replaceText);
//							break;
//						case "U":
//							replaceText = parms[1];
//							message = message.replace(list[i], replaceText);
//							break;
//						case "J":
//							replaceText = parms[0];
//							_local20 = parms[3];
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.index = index;
//							formatInfo.length = replaceText.length;
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, _local20, null, null, true);
//							formatList.push(formatInfo);
//							message = message.replace(list[i], replaceText);
//							break;
//						case "Q":
//							_local21 = parms[0];
//							replaceText = (("【" + parms[1]) + "】");
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, _local21);
//							formatInfo.index = index;
//							formatInfo.length = replaceText.length;
//							formatList.push(formatInfo);
//							message = message.replace(list[i], replaceText);
//							message = message.replace(list[i], parms[1]);
//							break;
//						case "G":
//							_local22 = parms[3];
//							replaceText = parms[0];
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, _local22);
//							formatInfo.index = index;
//							formatInfo.length = replaceText.length;
//							formatList.push(formatInfo);
//							message = message.replace(list[i], replaceText);
//							break;
//						case "H":
//							_local23 = ColorUtils.getQualityColorInt(ColorUtils.getCardQualityColorIndex(parms[3]));
//							replaceText = parms[1];
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 14, _local23);
//							formatInfo.index = index;
//							formatInfo.length = replaceText.length;
//							formatList.push(formatInfo);
//							message = message.replace(list[i], replaceText);
//							break;
						default:
							message = message.replace(list[i], "");
					}
					i++;
				}
			}
			var field:TextField = this.getTextField();
			field.text = message;
			for each (info in formatList) {
				if (info.length == -1){
					field.setTextFormat(info.textFormat, info.index, message.length);
				} 
				else {
					field.setTextFormat(info.textFormat, info.index, (info.index + info.length));
				}
			}
			_showList.push(field);
			j = 0;
			while (j < _showList.length) {
				_showList[j].x = _poses[j].x;
				_showList[j].y = _poses[j].y;
				j++;
			}
			_startTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function getTextField():TextField
		{
			if(_hideList.length > 0)
			{
				var t:TextField = _hideList.shift() as TextField;
				_container.addChild(t);
				return t;
			}
			return _showList.shift();
		}
		private function collectTextField(field:TextField):void
		{
			for(var i:int = 0; i < _showList.length; i++)
			{
				if(_showList[i] == field)
				{
					_showList.splice(i,1);
				}
			}
			if(field.parent)field.parent.removeChild(field);
			_hideList.push(field);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - _startTime > 5000)
			{
				if(_showList.length > 0)
				{
					collectTextField(_showList[0]);
				}
				for(var i:int = 0; i < _showList.length; i++)
				{
					_showList[i].x = _poses[i].x;
					_showList[i].y = _poses[i].y;
				}
				_startTime = getTimer();
			}
		}
		
		public function dispose():void
		{
			_bgList = null;
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
		}
	}
}