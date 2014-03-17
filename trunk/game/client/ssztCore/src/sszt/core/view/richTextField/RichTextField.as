package sszt.core.view.richTextField
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.FaceManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.events.ChatModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	
	public class RichTextField extends Sprite
	{
		private var _textField:TextField;
		private var _width:Number;
		private var _canSelect:Boolean;
		/**
		 * 事件链接内容
		 */	
		private var _links:Array;
		private var _faces:Array;
		
		public function RichTextField(width:Number = 250,canSelect:Boolean = false)
		{
			_width = width;
			_canSelect = canSelect;
			super();
			init();
		}
		
		private function init():void
		{
			mouseEnabled = false;
			_textField = new TextField();
			addChild(_textField);
			_textField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
			_textField.mouseWheelEnabled = false;
			_textField.filters = [new GlowFilter(0,1,2,2,10)];
			_textField.width = _width;
			_textField.height = 14;
			_textField.mouseEnabled  = _textField.selectable = _textField.doubleClickEnabled = _canSelect;
			_textField.wordWrap = true;
			_links = [];
			_faces = [];
		}
		
		public function get text():String
		{
			if(!_textField)return "";
			return _textField.text;
		}
		
		public function appendMessage(mes:String,deployList:Array,format:Array):void
		{
			var transferBtn:TransferBitmapBtn;
			var quickCompleteTaskBtn:QuickCompleteTaskBtn;
			var rect:Rectangle;
			var i:int = 0;
			var offset:int = 0;
			var index:int;
			var linkField:LinkTextField;
			var formatInfo:RichTextFormatInfo;
			var formatList:Array = format.slice();
			var indexList:Array = [];
			var faceLines:Array = [];
			
			_textField.text = mes;
			
			//组织文本内容
			for(i = 0; i < deployList.length; i++)
			{
				index = deployList[i].param4 + offset;
				switch(deployList[i].type)
				{
					case DeployEventType.FACE:
						if(getCharBoundaries(index) && (getCharBoundaries(index).x + 30 > _width + 10))
						{
							_textField.text = _textField.text.slice(0,index) + "\n" + _textField.text.slice(index);
							offset++;
							index++;
						}
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index + 1;
						formatInfo.length = 1;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),16);
						formatList.push(formatInfo);
						if(faceLines.indexOf(_textField.getLineIndexOfChar(index)) == -1)faceLines.push(_textField.getLineIndexOfChar(index));
						break;
					case DeployEventType.ITEMTIP:
						var name:String = deployList[i].descript;
						if(getCharBoundaries(index) && (getCharBoundaries(index).x + 12*name.length + 20 > _width - 5))
						{
							_textField.text = _textField.text.slice(0,index) + "\n" + _textField.text.slice(index);
							offset++;
							index++;
							formatList[deployList[i].formatIndex].index ++;
						}
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index + 1;
						formatInfo.length = name.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(deployList[i].param3).quality),null,null,true);
						formatList.push(formatInfo);
						break;
					case DeployEventType.SHOW_MOUNT:
						name = deployList[i].descript;
						if(getCharBoundaries(index) && (getCharBoundaries(index).x + 12*name.length + 20 > _width - 5))
						{
							_textField.text = _textField.text.slice(0,index) + "\n" + _textField.text.slice(index);
							offset++;
							index++;
						}
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index + 1;
						formatInfo.length = name.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(deployList[i].param3).quality),null,null,true);
						formatList.push(formatInfo);
						break;
					case DeployEventType.SHOW_PET:
						name = deployList[i].descript;
						if(getCharBoundaries(index) && (getCharBoundaries(index).x + 12*name.length + 20 > _width - 5))
						{
							_textField.text = _textField.text.slice(0,index) + "\n" + _textField.text.slice(index);
							offset++;
							index++;
						}
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index + 1;
						formatInfo.length = name.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(ItemTemplateList.getTemplate(deployList[i].param3).quality),null,null,true);
						formatList.push(formatInfo);
						break;
					case DeployEventType.ITEM_TEMPLATE_TIP:
						break;
					case DeployEventType.PLAYER_MENU:
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = deployList[i].descript.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFCA79,null,null,true);
						formatList.push(formatInfo);
						break;
					case DeployEventType.TASK_TIP:
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = deployList[i].descript.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFCC00,null,null,null,null,null,null,null,null,null,3);
						formatList.unshift(formatInfo);
						break;
					case DeployEventType.LINK:
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = deployList[i].descript.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00FF00,null,null,true);
						formatList.push(formatInfo);
						break;
					case DeployEventType.TASK_TRANSFER:
						if(getCharBoundaries(index) && (getCharBoundaries(index).x + 30 > _width + 15))
						{
							_textField.text = _textField.text.slice(0,index) + "\n" + _textField.text.slice(index);
							offset++;
							index++;
						}
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = 1;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12);
						formatList.push(formatInfo);
						break;
					case DeployEventType.QUICK_COMPLETE_TASK:
						if(getCharBoundaries(index) && (getCharBoundaries(index).x + 30 > _width + 15))
						{
							_textField.text = _textField.text.slice(0,index) + "\n" + _textField.text.slice(index);
							offset++;
							index++;
						}
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = 1;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12);
						formatList.push(formatInfo);
						break;
					case DeployEventType.TEXT_COLOR:
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = deployList[i].param2;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, deployList[i].param1);
						formatList.push(formatInfo);
						break;
					default:
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = index;
						formatInfo.length = deployList[i].descript.length;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFCC00,null,null,true);
						formatList.unshift(formatInfo);
				}
				indexList.push(index);
			}
			
			//设置文本样式
			if(_textField.text != "")
			{
				for(i = 0; i < formatList.length; i++)
				{
					try
					{
						if(formatList[i].length != -1)
							_textField.setTextFormat(formatList[i].textFormat,formatList[i].index,formatList[i].index+formatList[i].length);
						else
							_textField.setTextFormat(formatList[i].textFormat,formatList[i].index,_textField.length);
					}
					catch(e:Error)
					{
						trace("sdf");
					}
				}
			}
			
			//添加功能模块
			for(i = 0; i < deployList.length; i++)
			{
				index = indexList[i];
				rect = getCharBoundaries(index);
				if(rect)
				{
					switch(deployList[i].type)
					{
						case DeployEventType.FACE:
							var face:BaseEffect = FaceManager.getFace(FaceManager["FACE" + deployList[i].param1]);
							if(face)
							{
								face.move(rect.x + _textField.x - 2,rect.y + _textField.y - 3);
								addChild(face as DisplayObject);
								_faces.push(face);
							}
							break;
						case DeployEventType.ITEMTIP:
							var rr:Rectangle = getCharBoundaries(index+ItemTemplateList.getTemplate(deployList[i].param3).name.length+1);
							if(rr)
							{
								linkField = new LinkTextField(rr.x - rect.x - rect.width);
								linkField.x = rect.x + rect.width + _textField.x;
								linkField.y = rect.y + _textField.y;
								linkField.line = _textField.getLineIndexOfChar(index);
								linkField.deployInfo = deployList[i];
								addChild(linkField);
								_links.push(linkField);
							}
							break;
						case DeployEventType.SHOW_MOUNT:
							rr = getCharBoundaries(index+ItemTemplateList.getTemplate(deployList[i].param3).name.length+1);
							if(rr)
							{
								linkField = new LinkTextField(rr.x - rect.x - rect.width);
								linkField.x = rect.x + rect.width + _textField.x;
								linkField.y = rect.y + _textField.y;
								linkField.line = _textField.getLineIndexOfChar(index);
								linkField.deployInfo = deployList[i];
								addChild(linkField);
								_links.push(linkField);
							}
							break;
						case DeployEventType.SHOW_PET:
							rr = getCharBoundaries(index+ deployList[i].param.length+4);
							if(rr)
							{
								linkField = new LinkTextField(rr.x - rect.x - rect.width);
								linkField.x = rect.x + rect.width + _textField.x;
								linkField.y = rect.y + _textField.y;
								linkField.line = _textField.getLineIndexOfChar(index);
								linkField.deployInfo = deployList[i];
								addChild(linkField);
								_links.push(linkField);
							}
							break;
						case DeployEventType.TASK_TRANSFER:
							
							transferBtn = new TransferBitmapBtn();
							transferBtn.move(rect.x + this._textField.x, rect.y + this._textField.y -3 );
							addChild(transferBtn);
							transferBtn.info = deployList[i];
							
//							var bmp:Bitmap = new Bitmap(AssetSource.getTransferShoes());
//							bmp.x = rect.x + _textField.x;
//							bmp.y = rect.y + _textField.y;
//							addChild(bmp);
//							linkField = new LinkTextField(bmp.width);
//							linkField.x = rect.x + _textField.x;
//							linkField.y = rect.y + _textField.y;
//							linkField.line = _textField.getLineIndexOfChar(index);
//							linkField.deployInfo = deployList[i];
//							addChild(linkField);
//							_links.push(linkField);
							break;
						case DeployEventType.QUICK_COMPLETE_TASK:
							
							quickCompleteTaskBtn = new QuickCompleteTaskBtn();
							quickCompleteTaskBtn.move(0 + this._textField.x, rect.y + this._textField.y +17 );
							addChild(quickCompleteTaskBtn);
							quickCompleteTaskBtn.info = deployList[i];
							break;
						case DeployEventType.TEXT_COLOR:
							break;
						default:
							var r:Rectangle = getCharBoundaries(index+deployList[i].descript.length-1);
							if(r)
							{
								linkField = new LinkTextField(r.x + r.width - rect.x);
								linkField.x = rect.x + _textField.x;
								linkField.y = rect.y + _textField.y;
								linkField.line = _textField.getLineIndexOfChar(index);
								linkField.deployInfo = deployList[i];
								addChild(linkField);
								_links.push(linkField);
							}
					}
				}
			}
			
			for(i = 0; i < faceLines.length; i++)
			{
				for(var j:int = 0; j < _links.length; j++)
				{
					if(_links[j].line == faceLines[i])_links[j].y += 10;
				}
			}
			
			_textField.height = _textField.textHeight + 10;
		}
		
		public function clear():void
		{
			for each(var i:BaseEffect in _faces)
			{
				if(i)i.dispose();
			}
			_faces = [];
			for each(var linkText:LinkTextField in _links)
			{
				linkText.dispose();
			}
			_links = [];
			if(_textField && _textField.parent)_textField.parent.removeChild(_textField);
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
			_textField.mouseWheelEnabled = false;
			_textField.filters = [new GlowFilter(0,1,2,2,10)];
			_textField.width = _width;
			_textField.height = 14;
			_textField.mouseEnabled  = _textField.selectable = _textField.doubleClickEnabled = _canSelect;
			_textField.wordWrap = true;
			addChildAt(_textField,0);
		}
		
		private function getCharBoundaries(index:int):Rectangle
		{
			var result:Rectangle = _textField.getCharBoundaries(index);
			if(!result)
			{
				var n:int = _textField.getLineIndexOfChar(index);
				if(_textField.bottomScrollV < n)
				{
					var t:int = _textField.scrollV;
					_textField.scrollV = n;
					result = _textField.getCharBoundaries(index);
					_textField.scrollV = t;
				}
			}
			return result;
		}
		
		public function dispose():void
		{
			for each(var linkText:LinkTextField in _links)
			{
				linkText.dispose();
			}
			_links = null;
			for each(var i:BaseEffect in _faces)
			{
				if(i)i.dispose();
			}
			_faces = null;
			if(parent)parent.removeChild(this);
		}
	}
}