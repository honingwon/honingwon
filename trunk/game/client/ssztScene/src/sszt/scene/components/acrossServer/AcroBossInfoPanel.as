package sszt.scene.components.acrossServer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.bossWar.BossWarTemplateInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class AcroBossInfoPanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _info:BossWarTemplateInfo;
		private var _despritionLabel:MAssetLabel;
		private var _fallDownLabel:MAssetLabel;
		private var _bgPic:Bitmap;
		private var _pic:Bitmap;
		private var _bgPath:String;
		private var _path:String = "";
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		public function AcroBossInfoPanel()
		{
			super();
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			mouseEnabled = false;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(-3,-2,224,22)),
			]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.character"),MAssetLabel.LABELTYPE14);
			label1.move(90,0);
			addChild(label1);
			
			_despritionLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_despritionLabel.move(5,26);
			_despritionLabel.width = 208;
			_despritionLabel.wordWrap = true;
			_despritionLabel.multiline = true;
			_despritionLabel.defaultTextFormat = LABEL_FORMAT;
			_despritionLabel.setTextFormat(LABEL_FORMAT);
			addChild(_despritionLabel);
			
			_fallDownLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_fallDownLabel.move(5,100);
			_fallDownLabel.width = 208;
			_fallDownLabel.selectable = false;
			_fallDownLabel.mouseEnabled = _fallDownLabel.mouseWheelEnabled = true;
			_fallDownLabel.wordWrap = true;
			_fallDownLabel.multiline = true;
			_fallDownLabel.defaultTextFormat = LABEL_FORMAT;
			_fallDownLabel.setTextFormat(LABEL_FORMAT);
			addChild(_fallDownLabel);
			
			_bgPath = GlobalAPI.pathManager.getAssetPath("bossInfoPanelBg.jpg");
			GlobalAPI.loaderAPI.getPicFile(_bgPath,bgPicComplete,SourceClearType.NEVER);
			
		}
		
		private function bgPicComplete(data:BitmapData):void
		{
			_bgPic = new Bitmap(data);
			_bgPic.x = -7;
			_bgPic.y = -5;
			addChildAt(_bgPic,0);
		}
		
		private function initEvents():void
		{
			addEventListener(TextEvent.LINK,linkClickHandler);
		}
		
		private function removeEvents():void
		{
			removeEventListener(TextEvent.LINK,linkClickHandler);
		}
		
		private var _timeoutIndex:int = -1;
		
		private function linkClickHandler(e:TextEvent):void
		{
			for(var i:int = 0;i < _info.dropList.length;i++)
			{
				if(e.text ==  _info.dropList[i])
				{
					var localPoint:Point = this.localToGlobal(new Point(this.mouseX,this.mouseY));
					_timeoutIndex = setTimeout(showHandler,50);
					function showHandler():void
					{
						TipsUtil.getInstance().show(ItemTemplateList.getTemplate(_info.dropList[i]),null,new Rectangle(localPoint.x,localPoint.y,0,0));
						if(_timeoutIndex != -1)
						{
							clearTimeout(_timeoutIndex);
							_timeoutIndex = -1;
						}
					}
					break;
				}
			}
		}
		
		private function updateInfoLabel():void
		{
			if(_info)
			{
				_despritionLabel.htmlText = _info.description;
				var tmpListContent:String = "";
				for(var i:int = 0;i < _info.dropList.length;i++)
				{
					var tmpInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(int(_info.dropList[i]));
					var color:String = CategoryType.getQualityColorString(tmpInfo.quality);
					tmpListContent += "<font color='#"+color+"'><u><a href='event:"+_info.dropList[i]+"'>"+tmpInfo.name+"</a></u></font>;" ;
				}
				_fallDownLabel.htmlText = LanguageManager.getWord("ssztl.club.fallDown") + "\n"+tmpListContent;
				if(_pic && _pic.parent)
				{
					_pic.parent.removeChild(_pic);
				}
				if(_path != "")
				{
					GlobalAPI.loaderAPI.removeAQuote(_path,createPicComplete);
				}
				_path = GlobalAPI.pathManager.getSceneMonsterShowPath(MonsterTemplateList.getMonster(_info.id).picPath);
				GlobalAPI.loaderAPI.getPicFile(_path,createPicComplete,SourceClearType.TIME,60000);
			}
			else
			{
				_despritionLabel.text = "";
				_fallDownLabel.text = "";
				if(_pic && _pic.parent)
				{
					_pic.parent.removeChild(_pic);
				}
				_pic = null;
				if(_path != "")
				{
					GlobalAPI.loaderAPI.removeAQuote(_path,createPicComplete);
				}
				_path = "";
			}
		}
		
		private function createPicComplete(data:BitmapData):void
		{
			if(!_info)return;
			if(_pic && _pic.parent)
			{
				_pic.parent.removeChild(_pic);
			}
			_pic = new Bitmap(data);
			_pic.scaleX = -1;
			_pic.x = 300;
			_pic.y = 120;
			addChildAt(_pic,1);
		}
		
		public function get info():BossWarTemplateInfo
		{
			return _info;
		}
		
		public function set info(value:BossWarTemplateInfo):void
		{
			_info = value;
			updateInfoLabel();
		}
		
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgPic && _bgPic.parent)
			{
				_bgPic.parent.removeChild(_bgPic);
			}
			_bgPic = null;
			_info = null;
			_despritionLabel = null;
			_fallDownLabel = null;
			if(_pic && _pic.parent)
			{
				_pic.parent.removeChild(_pic);
			}
			_pic = null;
			if(_path != "")
			{
				GlobalAPI.loaderAPI.removeAQuote(_path,createPicComplete);
			}
			_path = "";
			if(_bgPath != "")
			{
				GlobalAPI.loaderAPI.removeAQuote(_bgPath,bgPicComplete);
			}
			_bgPath = "";
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
		}
	}
}