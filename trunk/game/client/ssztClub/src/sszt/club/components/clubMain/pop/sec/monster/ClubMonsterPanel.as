package sszt.club.components.clubMain.pop.sec.monster
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.club.components.clubMain.pop.sec.IClubMainPanel;
	import sszt.club.datas.monster.ClubMonsterInfo;
	import sszt.club.events.ClubMonsterUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bossWar.BossWarTemplateList;
	import sszt.core.data.club.ClubMonsterTemplateInfo;
	import sszt.core.data.club.ClubMonsterTemplateList;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubMonsterPanel extends MSprite implements IClubMainPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _levelUpBtn:MCacheAsset1Btn;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _currentSelect:int = -1;
		private var _monsterInfoPanel:ClubMonsterInfoPanel;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		private var _monsterDescriptionLabel:MAssetLabel;
		private var _currentMonsterLabel:MAssetLabel;
		private var _updateMonsterLabel:MAssetLabel;
		private var _needClubLevelLabel:MAssetLabel;
		private var _needClubRichLabel:MAssetLabel;
		private var _bgPic:Bitmap;
		private var _bgPath:String;
		
		public function ClubMonsterPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			initView();
			_mediator.clubInfo.initClubMonster();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,118,398)),
//				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(121,0,317,398)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(441,0,234,398)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(167,247,102,19)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(321,247,102,19)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(167,272,102,19)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(452,128,213,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(132,240,291,2),new MCacheSplit2Line())
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(450,9,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.shenShouOverView"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(450,142,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.currentShenShou"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(445,172,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.jiLianShenShou"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(445,270,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.jiLianCondition"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(450,292,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLevel") + ":",MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(450,314,64,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubMoney2") + "：",MAssetLabel.LABELTYPE14)));
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(132,248,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.attack3") + "：",MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(286,248,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.defense") + "：",MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(132,273,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.hp") + "：",MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(132,307,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.fallDown"),MAssetLabel.LABELTYPE14)));
			
			_levelUpBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.club.jiLianShenShou"));
			_levelUpBtn.move(578,361);
			addChild(_levelUpBtn);
//			_levelUpBtn.enabled = false;
			
			_monsterDescriptionLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_monsterDescriptionLabel.width = 220;
			_monsterDescriptionLabel.wordWrap = true;
			_monsterDescriptionLabel.multiline = true;
			_monsterDescriptionLabel.defaultTextFormat = LABEL_FORMAT;
			_monsterDescriptionLabel.setTextFormat(LABEL_FORMAT);
			_monsterDescriptionLabel.move(450,31);
			addChild(_monsterDescriptionLabel);
			
			_currentMonsterLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_currentMonsterLabel.move(510,142);
			addChild(_currentMonsterLabel);
			
			_updateMonsterLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_updateMonsterLabel.width = 220;
			_updateMonsterLabel.wordWrap = true;
			_updateMonsterLabel.multiline = true;
			_updateMonsterLabel.defaultTextFormat = LABEL_FORMAT;
			_updateMonsterLabel.setTextFormat(LABEL_FORMAT);
			_updateMonsterLabel.move(450,194);
			addChild(_updateMonsterLabel);
			
			
			_needClubLevelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_needClubLevelLabel.move(514,291);
			addChild(_needClubLevelLabel);
			
			_needClubRichLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_needClubRichLabel.move(514,315);
			addChild(_needClubRichLabel);
			
			_itemList = [];
			
			_mTile = new MTile(120,40);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.setSize(120,400);
			_mTile.move(0,0);
			addChild(_mTile);
			
			_monsterInfoPanel = new ClubMonsterInfoPanel();
			addChild(_monsterInfoPanel);
			_monsterInfoPanel.move(121,0);
			
			mouseEnabled = false;
			
			_bgPath = GlobalAPI.pathManager.getAssetPath("clubBossPanelBg.jpg");
			GlobalAPI.loaderAPI.getPicFile(_bgPath,bgPicComplete,SourceClearType.NEVER);
			
			for each(var j:ClubMonsterTemplateInfo in ClubMonsterTemplateList.list)
			{
				var tmpItem:ClubMonsterItemView = new ClubMonsterItemView(j,_mediator);
				_itemList.push(tmpItem);
				_mTile.appendItem(tmpItem);
				tmpItem.addEventListener(MouseEvent.CLICK,itemSelectHandler);
			}
			if(_itemList.length > 0)
			{
				setSelectIndex(0);
			}
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		
		private function bgPicComplete(data:BitmapData):void
		{
			_bgPic = new Bitmap(data);
			_bgPic.x = 122;
			_bgPic.y = 3;
			addChildAt(_bgPic,0);
		}
		
		private function initEvent():void
		{
			_levelUpBtn.addEventListener(MouseEvent.CLICK,levelupBtnClickHandler);
			clubMonsterInfo.addEventListener(ClubMonsterUpdateEvent.CLUB_MONSTER_UPDATE,updateLabel);
		}
		
		private function removeEvent():void
		{
			_levelUpBtn.removeEventListener(MouseEvent.CLICK,levelupBtnClickHandler);
			clubMonsterInfo.removeEventListener(ClubMonsterUpdateEvent.CLUB_MONSTER_UPDATE,updateLabel);
		}
		
		private function updateLabel(e:ClubMonsterUpdateEvent):void
		{
			var tmpInfoCurrentInfo:ClubMonsterTemplateInfo = ClubMonsterTemplateList.getClubMonsterByLevel(clubMonsterInfo.monsterLevel);
			_currentMonsterLabel.text = MonsterTemplateList.getMonster(tmpInfoCurrentInfo.monsterId).name;

			_monsterDescriptionLabel.htmlText = LanguageManager.getWord("ssztl.club.clubMonsterDescript");
			_updateMonsterLabel.text = LanguageManager.getWord("ssztl.club.upgradeClubMonster");
			
			var tmpInfo:ClubMonsterTemplateInfo = ClubMonsterTemplateList.getClubMonsterByLevel(clubMonsterInfo.monsterLevel + 1);
			if(tmpInfo)
			{
				_needClubLevelLabel.text = tmpInfo.needClubLevel.toString();
				_needClubRichLabel.text = tmpInfo.needClubRich.toString();
			}
			else
			{
				_needClubLevelLabel.text = "";
				_needClubRichLabel.text = "";
			}
		}
		
		private function itemSelectHandler(e:MouseEvent):void
		{
			var index:int = _itemList.indexOf(e.currentTarget);
			setSelectIndex(index);
		}
		
		private function setSelectIndex(argIndex:int):void
		{
			if(_currentSelect == argIndex)return;
			if(_currentSelect != -1)
			{
				_itemList[_currentSelect].select = false;
			}
			_currentSelect = argIndex;
			_itemList[_currentSelect].select = true;
			updateInfoPanel();
		}
		
		private function updateInfoPanel():void
		{
			_monsterInfoPanel.info = _itemList[_currentSelect].info;
		}
		
		private function levelupBtnClickHandler(e:MouseEvent):void
		{
			var tmpInfo:ClubMonsterTemplateInfo = ClubMonsterTemplateList.getClubMonsterByLevel(clubMonsterInfo.monsterLevel + 1);
			if(!tmpInfo)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.alreadyAchieveMaxLevel"));
				return;
			}
			if(clubMonsterInfo.currentClubLevel < tmpInfo.needClubLevel || clubMonsterInfo.currentClubRich < tmpInfo.needClubRich)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.jiLianConditionNotEnough"));
				return;
			}
			_mediator.sendMonsterUpgrade();
		}
		
		private function get clubMonsterInfo():ClubMonsterInfo
		{
			return _mediator.clubInfo.clubMonsterInfo;
		}
		
		public function show():void
		{
			_mediator.sendMonsterInfo();
			//先模拟数据
//						clubMonsterInfo.monsterLevel = 1;
//						clubMonsterInfo.update();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bgPath != "")
			{
				GlobalAPI.loaderAPI.removeAQuote(_bgPath,bgPicComplete);
			}
			_bgPath = "";
			_mediator.clubInfo.clearClubMonster();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_levelUpBtn)
			{
				_levelUpBtn.dispose();
				_levelUpBtn = null;
			}
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var i:ClubMonsterItemView in _itemList)
			{
				if(i)
				{
					i.removeEventListener(MouseEvent.CLICK,itemSelectHandler);
					i.dispse();
					i = null;
				}
			}
			_itemList = null;
			if(_monsterInfoPanel)
			{
				_monsterInfoPanel.dispose();
				_monsterInfoPanel = null;
			}
			 _currentMonsterLabel = null;
			 _monsterDescriptionLabel = null;
			 _updateMonsterLabel = null;
			 _needClubLevelLabel = null;
			 _needClubRichLabel = null;
			super.dispose();
		}
	}
}