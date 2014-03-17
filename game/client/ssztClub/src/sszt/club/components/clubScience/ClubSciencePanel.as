package sszt.club.components.clubScience
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.club.components.clubMain.pop.sec.IClubMainPanel;
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubSkillEvent;
	import sszt.core.data.club.ClubSkillItemInfo;
	import sszt.core.data.club.ClubSkillTemplate;
	import sszt.core.data.club.ClubSkillTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.NumberUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubSciencePanel extends Sprite implements IClubMainPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ClubMediator;
		private var _tile:MTile;
		private var _list:Array;
		private var _detail:ClubSkillDetail;
		private var _exploit:MAssetLabel;
		private var _currentItem:ClubSkillItemView;
		public static var selectBg:SelectedBorder;
		public static const CLUB_SKILL_UPDATE:String = "clubSkillUpdate";
		
		public function ClubSciencePanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			selectBg = new SelectedBorder();
			selectBg.width = 208;
			selectBg.height = 67;
			selectBg.mouseEnabled = false;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,414,397)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(419,0,256,397)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(72,367,132,19)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(421,5,252,22)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(421,237,252,22))
				]);
			addChild(_bg as DisplayObject);

			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(10,368,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.personalContribute2") + "：",MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,8,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.skillDetail"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,34,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillName"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,58,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.skillEffect"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,150,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.updateEffect"),MAssetLabel.LABELTYPE14)));
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,240,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.upgradeCondition"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,266,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLevel") + ":",MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,284,90,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubCostMoney"),MAssetLabel.LABELTYPE14)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(443,328,37,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.prompt"),MAssetLabel.LABELTYPE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(481,328,175,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubLeaderCanUpgrade"),MAssetLabel.LABELTYPE1)));
			
			_tile = new MTile(200,55,2);
			_tile.setSize(404,353);
			_tile.move(7,5);
			_tile.itemGapW = 4;
			_tile.itemGapH = 4;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_detail = new ClubSkillDetail(_mediator);
			_detail.move(0,0);
			addChild(_detail);

			_exploit = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_exploit.move(73,367);
			addChild(_exploit);
			_exploit.setValue(GlobalData.selfPlayer.selfExploit + "/" + GlobalData.selfPlayer.totalExploit);
			
			_list = [];
			initTemplateData();
			initData();
			initEvent();
			
			if(_list.length > 0)
			{
				_currentItem = _list[0];
				_currentItem.selected = true;
				if(_currentItem.isStudy) _detail.setDetail(_currentItem.template,_currentItem.skillInfo.level);
				else _detail.setDetail(_currentItem.template);
			}
		}
		
		private function initEvent():void
		{
			GlobalData.clubSkillList.addEventListener(ClubSkillEvent.ADD_CLUB_SKILL,addSkillHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler)
		}
		
		private function removeEvent():void
		{
			GlobalData.clubSkillList.removeEventListener(ClubSkillEvent.ADD_CLUB_SKILL,addSkillHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler)
		}
		
		public function assetsCompleteHandler():void
		{
			
		}
		private function exploitUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_exploit.setValue(GlobalData.selfPlayer.selfExploit + "/" + GlobalData.selfPlayer.totalExploit);
		}
		
		private function addSkillHandler(evt:ClubSkillEvent):void
		{
			var skill:ClubSkillItemInfo = evt.data as ClubSkillItemInfo;
			for each(var i:ClubSkillItemView in _list)
			{
				if(i.templateId == skill.templateId)
				{
					i.skillInfo = skill;
					_detail.setDetail(i.skillInfo.template,i.skillInfo.level);
					break;
				}
			}
		}
		
		private function initTemplateData():void
		{
			var item:ClubSkillItemView;
			for each(var i:ClubSkillTemplate in ClubSkillTemplateList.list)
			{
				item = new ClubSkillItemView(i);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				item.addEventListener(ClubSciencePanel.CLUB_SKILL_UPDATE,updateSkillHandler);
				_tile.appendItem(item);
				_list.push(item);
			}
		}
		
		private function initData():void
		{
			var list:Array = GlobalData.clubSkillList.getList();
			for each(var i:ClubSkillItemInfo in list)
			{
				for each(var j:ClubSkillItemView in _list)
				{
					if(j.templateId == i.templateId)
					{
						j.skillInfo = i;
						break;
					}
				}
			}
		}
		
		private function updateSkillHandler(evt:Event):void
		{
			var item:ClubSkillItemView = evt.currentTarget as ClubSkillItemView;
			if(item.isStudy)
			{
				_detail.setDetail(item.template,item.skillInfo.level);
			}else
			{
				_detail.setDetail(item.template);
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var item:ClubSkillItemView = evt.currentTarget as ClubSkillItemView;
			if(_currentItem == item) return;
			if(_currentItem) _currentItem.selected = false;
			_currentItem = item;
			_currentItem.selected = true;
			if(_currentItem.isStudy) _detail.setDetail(_currentItem.template,_currentItem.skillInfo.level);
			else _detail.setDetail(_currentItem.template);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_list)
			{
				for(var i:int = 0;i<_list.length;i++)
				{
					_list[i].dispose();
				}
				_list = null;
			}
			if(_detail)
			{
				_detail.dispose();
				_detail = null;
			}
			_exploit = null;
			_currentItem = null;
			selectBg = null;
			if(parent) parent.removeChild(this);
		}
		
		public function show():void
		{
		}
	}
}