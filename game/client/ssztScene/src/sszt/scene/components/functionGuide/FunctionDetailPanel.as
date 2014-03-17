package sszt.scene.components.functionGuide
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.functionGuide.FunctionGuideItemInfo;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class FunctionDetailPanel extends MPanel
	{
		private static var _pattern:RegExp = /\{[^\}]*\}/g;
		private var _bg:IMovieWrapper;
		private var _info:FunctionGuideItemInfo;
		private var _detailBitmap:Bitmap;
		private var _detailField:RichTextField;
		
		public function FunctionDetailPanel(item:FunctionGuideItemInfo)
		{
			super(new MCacheTitle1(item.title),true,-1,true,true);
			info = item;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(425,420);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,425,420)),
				new BackgroundInfo(BackgroundType.BAR_6, new Rectangle(8,9,410,312)),
				new BackgroundInfo(BackgroundType.BAR_6, new Rectangle(8,326,410,87))
			]);
			addContent(_bg as DisplayObject);
		}
		
		public function set info(item:FunctionGuideItemInfo):void
		{
			if(_info == item)
				return;
			else
			{
				if(_detailBitmap && _detailBitmap.parent)_detailBitmap.parent.removeChild(_detailBitmap);
				if(_detailField)
				{
					_detailField.dispose();
				}
				_info = item;
//				_detailBitmap = new Bitmap(new BitmapData());
				var descriptStr:String = _info.descript.split("\\n").join("\n").split("{enter}").join("\n");
				
				var list:Array = descriptStr.match(_pattern);
				var formatList:Array = [];
				var deployList:Array = [];
				if(list != null && list.length > 0)  
				{
					for(var j:int = 0; j < list.length; j++)
					{
						var str:String = list[j] as String;
						var subStr:String = str.substr(1,str.length-2);
						var parms:Array = subStr.split("-");
						var deploy:DeployItemInfo;
						var formatInfo:RichTextFormatInfo;
						switch(parms[0])
						{
							case "#":
								formatInfo = new RichTextFormatInfo();
								formatInfo.index = descriptStr.indexOf(str);
								formatInfo.length = parms[1].length;
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,parseInt("0x"+parms[2]));
								formatList.push(formatInfo);
								descriptStr = descriptStr.replace(str,parms[1]);
								break;
							case "$":
								deploy = new DeployItemInfo();
								deploy.descript = parms[1];
								deploy.type = parms[2];
								deploy.param1 = parms[3];
								deploy.param2 = parms[4];
								deploy.param3 = parms[5];
								deploy.param4 = descriptStr.indexOf(str);
								descriptStr = descriptStr.replace(str,deploy.descript);
								deployList.push(deploy);
								break;
							case "T":
								deploy = new DeployItemInfo();
								deploy.descript = parms[1];
								deploy.type = parms[2];
								deploy.param1 = parms[3];
								deploy.param2 = parms[4];
								deploy.param3 = parms[5];
								deploy.param4 = descriptStr.indexOf(str);
								descriptStr = descriptStr.replace(str,"    ");
								deployList.push(deploy);
								break;
						}
					}
				}
				_detailField = new RichTextField(405);
				_detailField.x = 11;
				_detailField.y = 330;
				_detailField.appendMessage(descriptStr,deployList,formatList);
				addContent(_detailField);
			}
			var picPath:String = GlobalAPI.pathManager.getFunctionGuidePath(_info.propagandisticPicPath);
			GlobalAPI.loaderAPI.getPicFile(picPath,createPicComplete,SourceClearType.CHANGESCENE_AND_TIME,5000);
		}
		
		private function getLayerType():String
		{
			return LayerType.ICON;
		}
		
		private function createPicComplete(data:BitmapData):void
		{
			_detailBitmap = new Bitmap(data);
			_detailBitmap.x = 12;
			_detailBitmap.y = 12;
			addContent(_detailBitmap);
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_detailBitmap && _detailBitmap.parent)
			{
				_detailBitmap.parent.removeChild(_detailBitmap);
				_detailBitmap = null;
			}
			if(_detailField)
			{
				_detailField.dispose();
				_detailField = null;
			}
			super.dispose();
		}
	}
}