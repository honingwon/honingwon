package sszt.club.components.clubMain.pop.sec.monster
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.club.ClubMonsterTemplateInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	
	public class ClubMonsterInfoPanel extends Sprite
	{
		private var _info:ClubMonsterTemplateInfo;
		private var _attackLabel:MAssetLabel;
		private var _defenseLabel:MAssetLabel;
		private var _hpLabel:MAssetLabel;
		private var _fallDownLabel:MAssetLabel;
		
//		private var _bgPic:Bitmap;
//		private var _bgPath:String;
		private var _pic:Bitmap;
		
		private var _path:String = "";
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		public function ClubMonsterInfoPanel()
		{
			super();
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_attackLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_attackLabel.move(52,250);
			addChild(_attackLabel);
			
			_defenseLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_defenseLabel.move(205,250);
			addChild(_defenseLabel);
			
			_hpLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_hpLabel.move(52,275);
			addChild(_hpLabel);
			
			_fallDownLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_fallDownLabel.move(11,329);
			_fallDownLabel.width = 285;
			_fallDownLabel.selectable = false;
			_fallDownLabel.mouseEnabled = _fallDownLabel.mouseWheelEnabled = true;
			_fallDownLabel.wordWrap = true;
			_fallDownLabel.multiline = true;
			_fallDownLabel.defaultTextFormat = LABEL_FORMAT;
			_fallDownLabel.setTextFormat(LABEL_FORMAT);
			addChild(_fallDownLabel);
			
			mouseEnabled = false;
//			_bgPath = GlobalAPI.pathManager.getAssetPath("bossInfoPanelBg.jpg");
//			GlobalAPI.loaderAPI.getPicFile(_bgPath,bgPicComplete,SourceClearType.NEVER);
		}
		
//		private function bgPicComplete(data:BitmapData):void
//		{
//			_bgPic = new Bitmap(data);
//			_bgPic.x = -7;
//			_bgPic.y = -5;
//			addChildAt(_bgPic,0);
//		}
		
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
		
		private function updateView():void
		{
			if(_info)
			{
				var tmpMonsterInfo:MonsterTemplateInfo = MonsterTemplateList.getMonster(_info.monsterId);
				_attackLabel.text = tmpMonsterInfo.attack.toString();
				_defenseLabel.text = tmpMonsterInfo.defense.toString();
				_hpLabel.text = tmpMonsterInfo.monsterHp.toString();
				var tmpListContent:String = "";
				for(var i:int = 0;i < _info.dropList.length;i++)
				{
					var tmpInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(int(_info.dropList[i]));
					var color:String = CategoryType.getQualityColorString(tmpInfo.quality);
					tmpListContent += "<font color='#"+color+"'><u><a href='event:"+_info.dropList[i]+"'>"+tmpInfo.name+"</a></u></font>;" ;
				}
				_fallDownLabel.htmlText = tmpListContent;
				if(_pic && _pic.parent)
				{
					_pic.parent.removeChild(_pic);
				}
				if(_path != "")
				{
					GlobalAPI.loaderAPI.removeAQuote(_path,createPicComplete);
				}
				_path = GlobalAPI.pathManager.getSceneMonsterShowPath(MonsterTemplateList.getMonster(_info.monsterId).picPath);
				GlobalAPI.loaderAPI.getPicFile(_path,createPicComplete,SourceClearType.TIME,60000);
			}
			else
			{
				_attackLabel.text = "";
				_defenseLabel.text = "";
				_hpLabel.text = "";
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
			_pic.x = 360;
			_pic.y = -20;
			addChildAt(_pic,1);
		}

		public function get info():ClubMonsterTemplateInfo
		{
			return _info;
		}

		public function set info(value:ClubMonsterTemplateInfo):void
		{
			_info = value;
			updateView();
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			_info = null;
			_attackLabel = null;
			_defenseLabel = null;
			_hpLabel = null;
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
//			if(_bgPath != "")
//			{
//				GlobalAPI.loaderAPI.removeAQuote(_bgPath);
//			}
//			_bgPath = "";
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
			if(parent)parent.removeChild(this);
		}
	}
}