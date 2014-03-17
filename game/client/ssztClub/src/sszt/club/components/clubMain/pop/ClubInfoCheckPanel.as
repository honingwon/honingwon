package sszt.club.components.clubMain.pop
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.club.datas.list.ClubListItemInfo;
	import sszt.club.socketHandlers.ClubTryinSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubLevelTemplate;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.club.ClubTitleXXAsset;
	
	public class ClubInfoCheckPanel extends MPanel
	{
		private var _info:ClubListItemInfo;
		private var _bg:IMovieWrapper;
		private var _clubRank:MAssetLabel,_clubName:MAssetLabel,_masterName:MAssetLabel,_clubLevel:MAssetLabel;
		private var _memberCount:MAssetLabel,_clubRich:MAssetLabel;
		private var _furnace_level:MAssetLabel,_shop_level:MAssetLabel;
		private var _clubNotice:TextField;
		private var _callBtn:MCacheAssetBtn1,_applyBtn:MCacheAssetBtn1;
		private var _rank:int;
		public function ClubInfoCheckPanel(info:ClubListItemInfo,rank:int)
		{
			_info = info;
			_rank = rank;
			super(new MCacheTitle1("",new Bitmap(new ClubTitleXXAsset())),true,-1)
//			super(new MCacheTitle1(LanguageManager.getWord("ssztl.common.check")),true,-1);;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(356,219);
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,4,340,178)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,2,356,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,169,356,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(76,16,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(76,38,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(76,60,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(76,82,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(238,16,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(238,38,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(238,60,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(238,82,99,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(19,125,318,46))
				
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,18,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.rank1") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(180,18,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,40,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLeaderName") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(180,40,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLevel")+ "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,62,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.memberNum") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(180,62,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubMoney") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,84,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.furnaceLevel") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(180,84,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.shopLevel") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,107,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubNotice") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			
			
			_clubRank = new MAssetLabel(_rank.toString(),MAssetLabel.LABEL_TYPE20);
			_clubRank.move(80,18);
			addContent(_clubRank);
			
			_clubName = new MAssetLabel(_info.name,MAssetLabel.LABEL_TYPE20);
			_clubName.move(242,18);
			addContent(_clubName);
			
			_masterName = new MAssetLabel( _info.masterName,MAssetLabel.LABEL_TYPE20);
			_masterName.move(80,40);
			addContent(_masterName);
			
			_clubLevel = new MAssetLabel(String(_info.level),MAssetLabel.LABEL_TYPE20);
			_clubLevel.move(242,40);
			addContent(_clubLevel);
			
			_memberCount = new MAssetLabel((_info.currentMember + "/" + _info.totalMember),MAssetLabel.LABEL_TYPE20);			
			_memberCount.move(80,62);
			addContent(_memberCount);
			
			_clubRich = new MAssetLabel(String(_info.rich),MAssetLabel.LABEL_TYPE20);
			_clubRich.move(242,62);
			addContent(_clubRich);
			
			_furnace_level = new MAssetLabel(String(_info.furnaceLevel),MAssetLabel.LABEL_TYPE20);
			_furnace_level.move(80,84);
			addContent(_furnace_level);
			
			_shop_level = new MAssetLabel(String(_info.shopLevel),MAssetLabel.LABEL_TYPE20);
			_shop_level.move(242,84);
			addContent(_shop_level);
			
			
			_clubNotice = new TextField();
			_clubNotice.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_clubNotice.mouseEnabled = _clubNotice.mouseWheelEnabled = false;
			_clubNotice.wordWrap = true;
			_clubNotice.width = 307;
			_clubNotice.height = 38;
			_clubNotice.x = 25;
			_clubNotice.y = 129;
			_clubNotice.text = _info.notice;
			addContent(_clubNotice);
			
			_callBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.contactClubLeader"));
			_callBtn.move(104,180);
			addContent(_callBtn);
			_applyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.applyJion"));
			_applyBtn.move(182,180);
			addContent(_applyBtn);
		}
		
		private function initEvent():void
		{
			_callBtn.addEventListener(MouseEvent.CLICK,callBtnClickHandler);
			_applyBtn.addEventListener(MouseEvent.CLICK,applyBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_callBtn.removeEventListener(MouseEvent.CLICK,callBtnClickHandler);
			_applyBtn.removeEventListener(MouseEvent.CLICK,applyBtnClickHandler);
		}
		
		private function callBtnClickHandler(e:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:_info.masterServerId,id:_info.masterId,nick:_info.masterName,flag:1}));
		}
		
		private function applyBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.selfPlayer.clubName != "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.alreadyInClub"));
			}
			else if(GlobalData.selfPlayer.level < 30)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.unableJionClub"));
			}
			else
			{
				ClubTryinSocketHandler.send(_info.id);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_callBtn)
			{
				_callBtn.dispose();
				_callBtn = null;
			}
			if(_applyBtn)
			{
				_applyBtn.dispose();
				_applyBtn = null;
			}
			_clubRank = null;
			_clubName = null;
			_masterName = null;
			_clubLevel = null;
			_memberCount = null;
			_clubRich = null;
			_furnace_level = null;
			_shop_level = null;
			
			_info = null;
			super.dispose();
		}
	}
}