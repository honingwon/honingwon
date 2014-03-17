package sszt.core.view.paopao
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.FaceManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.interfaces.tick.ITick;

	public class PaopaoPanel implements ITick
	{
		private static var _pattern:RegExp = /\{[A-Z][^\}]*\}/g;
		
		private var _field:RichTextField;
		private var _bg:DisplayObject;
		private var _beginTime:int;
		
		public function PaopaoPanel()
		{
			_field = new RichTextField(140);
		}
		
		public function show(message:String,parent:DisplayObjectContainer):void
		{
			var list:Array = message.match(_pattern);
			var index:int = 0;
			var rect:Rectangle;
			var parms:Array = [];
			var formatInfo:RichTextFormatInfo;
			var deployInfo:DeployItemInfo;
			var formatList:Array = [];
			var deployList:Array = [];
			var field:TextField = new TextField();
			if(list != null && list.length > 0)
			{
				for(var i:int = 0; i < list.length; i++)
				{
					field.text = message;
					index = field.text.indexOf(list[i]);
					parms = String(list[i]).slice(2,String(list[i]).length-1).split("-");
					rect = getCharBoundaries(field,index);
					switch(field.text.charAt(index+1))
					{
						case "F":
							if(rect.x + 30 > 150)
							{
								message = message.slice(0,index) + "\n" + message.slice(index);
//								field.text = field.text.slice(0,index) + "\n" + field.text.slice(index);
								index++;
							}
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index + 1;
							formatInfo.length = 1;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),16);
							formatList.push(formatInfo);
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.FACE;
							deployInfo.param4 = index;
							deployInfo.param1 = int(parms[0]);
							deployList.push(deployInfo);
							message = message.replace(list[i],"   ");
							break;
						case "I":
							var name:String;
							if(int(parms[3]) > 0)
							{
								name = ItemTemplateList.getTemplate(int(parms[2])).name + " +" + parms[3];
								message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name + " +" + parms[3] + " "));
							}
							else
							{
								name = ItemTemplateList.getTemplate(int(parms[2])).name;
								message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name + " "));
							}
							if(rect.x + 12*name.length + 10 > 135)
							{
								message = message.slice(0,index) + "\n" + message.slice(index);
//								field.text = field.text.slice(0,index) + "\n" + field.text.slice(index);
								index++;
							}
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index + 1;
							formatInfo.length = name.length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(parms[2]).quality),null,null,true);
							formatList.push(formatInfo);
							break;
						case "P":
							name = LanguageManager.getWord("ssztl.common.pet")+":"+ parms[3];
							message = message.replace(list[i]," " + name + " ");
							if(rect.x + 12*name.length + 20 > 135)
							{
								message = message.slice(0,index) + "\n" + message.slice(index);
//								field.text = field.text.slice(0,index) + "\n" + field.text.slice(index);
								index++;
							}
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index + 1;
							formatInfo.length = name.length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(parms[2]).quality),null,null,true);
							formatList.push(formatInfo);
							break;
						case "M":
							name = LanguageManager.getWord("ssztl.common.munts")+":"+ parms[3];
							message = message.replace(list[i]," " + name + " ");
							if(rect.x + 12*name.length + 20 > 135)
							{
								message = message.slice(0,index) + "\n" + message.slice(index);
//								field.text = field.text.slice(0,index) + "\n" + field.text.slice(index);
								index++;
							}
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index + 1;
							formatInfo.length = name.length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(parms[2]).quality),null,null,true);
							formatList.push(formatInfo);
							break;
					}
				}
			}
			_field.clear();
			_field.appendMessage(message,deployList,formatList);
			
			if(!_bg)
			{
				if(_field.height < 48)_bg = new Bitmap(GlobalData.paopaoSource.bgAsset1);
				else if(_field.height < 70)_bg = new Bitmap(GlobalData.paopaoSource.bgAsset2);
				else if(_field.height < 105)_bg = new Bitmap(GlobalData.paopaoSource.bgAsset3);
				else _bg = new Bitmap(GlobalData.paopaoSource.bgAsset4);
			}
			else
			{
				if(_field.height < 48)Bitmap(_bg).bitmapData = GlobalData.paopaoSource.bgAsset1;
				else if(_field.height < 70)Bitmap(_bg).bitmapData = GlobalData.paopaoSource.bgAsset2;
				else if(_field.height < 105)Bitmap(_bg).bitmapData = GlobalData.paopaoSource.bgAsset3;
				else Bitmap(_bg).bitmapData = GlobalData.paopaoSource.bgAsset4;
			}
			
			_bg.x = -70;
			_bg.y = -170 - _bg.height;
			_field.x = _bg.x + 6;
			_field.y = _bg.y + 5;
			_beginTime = getTimer();
			if(parent)
			{
				parent.addChild(_bg);
				parent.addChild(_field);
				GlobalAPI.tickManager.addTick(this);
			}
		}
		
		public function hide():void
		{
			if(_field.parent)_field.parent.removeChild(_field);
			if(_bg.parent)_bg.parent.removeChild(_bg);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - _beginTime > 5000)
			{
				hide();
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		private function getCharBoundaries(field:TextField,index:int):Rectangle
		{
			var result:Rectangle = field.getCharBoundaries(index);
			if(!result)
			{
				var n:int = field.getLineIndexOfChar(index);
				if(field.bottomScrollV < n)
				{
					var t:int = field.scrollV;
					field.scrollV = n;
					result = field.getCharBoundaries(index);
					field.scrollV = t;
				}
			}
			return result;
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			if(_bg && _bg.parent)
			{
				_bg.parent.removeChild(_bg);
				_bg = null;
			}
			if(_field)
			{
				_field.dispose();
				_field = null;
			}
		}
	}
}