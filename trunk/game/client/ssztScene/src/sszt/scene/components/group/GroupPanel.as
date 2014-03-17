package sszt.scene.components.group
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.group.groupSec.GroupSetupTabView;
	import sszt.scene.components.group.groupSec.GroupStateTabView;
	import sszt.scene.components.group.groupSec.IgroupTabView;
	import sszt.scene.components.group.groupSec.NearPlayerTabPanel;
	import sszt.scene.components.group.groupSec.NearTeamTabPanel;
	import sszt.scene.components.group.groupSec.TeamPlayerView;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.GroupMediator;
	import sszt.scene.socketHandlers.TeamChangeSettingSocketHandler;
	import sszt.scene.socketHandlers.TeamCreateSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class GroupPanel extends MPanel
	{
		private var _mediator:GroupMediator;
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _tabPanels:Vector.<IgroupTabView>;
//		private var _class:Vector.<Class>;
		private var _labels:Array;
		private var _btns:Array;
		private var _tabPanels:Array;
		private var _class:Array;
		private var _currentType:int;
		private var _bg:IMovieWrapper;
		private var _allowJoinCheckBox:CheckBox;
		private var _allowInvitCheckBox:CheckBox;
		
		private var _createTeamBtn:MCacheAssetBtn1;
		private var _leaveTeamBtn:MCacheAssetBtn1;
		private var _refeshBtn:MCacheAssetBtn1;
		
		private var _playerTile:MTile;
		private var _playerList:Array = [];
		private var _teamNoneTip:MAssetLabel;
		
		public function GroupPanel(mediator:GroupMediator)
		{
			_mediator = mediator;
			_currentType = -1;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.GroupTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.GroupTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title), true, -1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(570,363);
			
			_bg = BackgroundUtils.setBackground([
				
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,554,330)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,272,322)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(286,29,272,192)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(286,223,272,128)),
				
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(15,32,266,22)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(289,32,266,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(390,33,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(430,33,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(495,33,2,20),new MCacheSplit1Line()),
				
//				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,84,302,2)),
//				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,115,302,2)),
//				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,146,302,2)),
//				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(16,177,302,2))
			]);
			addContent(_bg as DisplayObject);
			
			//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(24,14,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABEL_TYPE9)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(300,272,180,17),new MAssetLabel(LanguageManager.getWord("ssztl.group.onlyLeaderDoWord"),MAssetLabel.LABEL_TYPE21)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(327,35,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.role") ,MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(399,35,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(451,35,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(227,35,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.strike"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(513,35,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			
			_createTeamBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.createTeam"));
			_createTeamBtn.move(387,236);
			addContent(_createTeamBtn);
			_leaveTeamBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.leaveTeam"));
			_leaveTeamBtn.move(387,236);
			_leaveTeamBtn.visible = false;
			addContent(_leaveTeamBtn);
			_refeshBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.refresh"));
			_refeshBtn.move(221,317);
			addContent(_refeshBtn);
			
			_allowJoinCheckBox = new CheckBox();
			_allowJoinCheckBox.move(300,298);
			_allowJoinCheckBox.setSize(140,16);
			_allowJoinCheckBox.label = LanguageManager.getWord("ssztl.group.allowApplyerEnetrWord");
			addContent(_allowJoinCheckBox);
			_allowInvitCheckBox = new CheckBox();
			_allowInvitCheckBox.move(300,322);
			_allowInvitCheckBox.setSize(160,16);
			_allowInvitCheckBox.label = LanguageManager.getWord("ssztl.group.allowInvitationWord");
			addContent(_allowInvitCheckBox);
			
			_playerTile = new MTile(266,32,1);
			_playerTile.setSize(266,158);
			_playerTile.move(289,56);
			_playerTile.horizontalScrollPolicy = _playerTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_playerTile.itemGapH = 0;
			addContent(_playerTile);
			
			_teamNoneTip = new MAssetLabel("", MAssetLabel.LABEL_TYPE_YAHEI);
			_teamNoneTip.textColor = 0x827960;
			_teamNoneTip.move(425,120);
			addContent(_teamNoneTip);
			_teamNoneTip.setHtmlValue(LanguageManager.getWord("ssztl.chat.noTeam"));
			_labels = [LanguageManager.getWord("ssztl.group.nearTeam"),LanguageManager.getWord("ssztl.scene.nearPlayer2")];
			
			_class = [NearTeamTabPanel,NearPlayerTabPanel];
			var pos:Array = [new Point(15,0),new Point(84,0)];
			
			_btns = [];
			for(var i:int = 0;i<_labels.length;i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				_btns.push(btn);
				btn.move(pos[i].x,pos[i].y);
				addContent(btn);
			}
			
			_tabPanels = new Array(_labels.length);
			
			changeTabPanel(0);
			changeJoinTypeHandler(null);
			if(_mediator.sceneInfo.teamData.leadId != GlobalData.selfPlayer.userId)
			{
				_allowJoinCheckBox.enabled = false;
				_allowInvitCheckBox.enabled = false;
			}
			initData();
		}
		
		private function initEvent():void
		{
			for each(var i:MCacheTabBtn1 in _btns)
			{
				i.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,changeLeaderHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addPlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.DISBAND,disBandHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGEJOINTYPE,changeJoinTypeHandler);			
			_refeshBtn.addEventListener(MouseEvent.CLICK,flashBtnClickHandler);
			_allowJoinCheckBox.addEventListener(Event.CHANGE,settingHandler);
			_allowInvitCheckBox.addEventListener(Event.CHANGE,settingHandler);
			
			_createTeamBtn.addEventListener(MouseEvent.CLICK,createBtnHandler);
			_leaveTeamBtn.addEventListener(MouseEvent.CLICK,leaveHandler);
		}
		private function removeEvent():void
		{
			for each(var i:MCacheTabBtn1 in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,changeLeaderHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addPlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.DISBAND,disBandHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGEJOINTYPE,changeJoinTypeHandler);
			_refeshBtn.removeEventListener(MouseEvent.CLICK,flashBtnClickHandler);
			_allowJoinCheckBox.removeEventListener(Event.CHANGE,settingHandler);
			_allowInvitCheckBox.removeEventListener(Event.CHANGE,settingHandler);
			_createTeamBtn.removeEventListener(MouseEvent.CLICK,createBtnHandler);
			_leaveTeamBtn.removeEventListener(MouseEvent.CLICK,leaveHandler);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var index:int = _btns.indexOf(evt.currentTarget);
			changeTabPanel(index);
		}
		private function disBandHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			_leaveTeamBtn.visible = false;
			_createTeamBtn.visible = true;	
			_teamNoneTip.visible = true;
		}
		private function settingHandler(evt:Event):void
		{			
			TeamChangeSettingSocketHandler.sendSetting(_allowJoinCheckBox.selected, int(_allowInvitCheckBox.selected));
		}
		
		private function flashBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentType == -1) return;
			_tabPanels[_currentType].refash();
		}		
		private function leaveHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.isSureExitTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
			}else
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.noExtendAddExitTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
			}	
		}
		private function leaveCloseHandler(e:CloseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(e.detail == MAlert.OK)
			{
				TeamLeaveSocketHandler.sendLeave();
			}
		}
		private function createBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			TeamCreateSocketHandler.send();
		}
		private function changeLeaderHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var id:Number = evt.data as Number;
			if(id == GlobalData.selfPlayer.userId)
			{
				_createTeamBtn.enabled = false;
				_teamNoneTip.visible = false;
				_allowJoinCheckBox.enabled = true;
				_allowInvitCheckBox.enabled = true;
				for(var i:int = 0;i<_playerList.length;i++)
				{
					_playerList[i].setLeader();
				}
			}
			else
			{
				if(id == 0)
				{
					_createTeamBtn.enabled = true;
					_teamNoneTip.visible = true;
				}
				else 
				{
					_createTeamBtn.enabled = false;
					_teamNoneTip.visible = false;
				}
				_allowJoinCheckBox.enabled = false;
				_allowInvitCheckBox.enabled = false;
			}
//			for each(var itemView:TeamPlayerItemView in _items)
//			{
//				if(itemView.player.getObjId() == id)itemView.isLeader = true;
//				else itemView.isLeader = false;
//			}
		}
		private function changeJoinTypeHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			_allowJoinCheckBox.selected = _mediator.sceneInfo.teamData.autoInTeam;
			if (_mediator.sceneInfo.teamData.allocationValue == 1)
				_allowInvitCheckBox.selected = true;
			else
				_allowInvitCheckBox.selected = false;
		}
		private function addPlayerHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var player:TeamScenePlayerInfo = evt.data as TeamScenePlayerInfo;
			var playerView:TeamPlayerView = new TeamPlayerView(player,_mediator);
			_playerList.push(playerView);
			_playerTile.appendItem(playerView);
			_leaveTeamBtn.visible = true;
			_createTeamBtn.visible = false;
			_teamNoneTip.visible = false;
		}
		private function removePlayerHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var player:TeamScenePlayerInfo = evt.data as TeamScenePlayerInfo;
			for(var i:int = 0;i<_playerList.length;i++)
			{
				if(player == _playerList[i].info)
				{
					var item:TeamPlayerView = _playerList.splice(i,1)[0];
					_playerTile.removeItem(item);
					break;
				}
				if(player.getObjId() == GlobalData.selfPlayer.userId)
				{
					_leaveTeamBtn.visible = false;
					_createTeamBtn.visible = true;
					_teamNoneTip.visible = true;
				}
			}
		}
		
		
		private function changeTabPanel(index:int):void
		{
			if(_currentType == index) return;
			if(_currentType == -1)
			{
				_tabPanels[index] = new _class[index](_mediator);
				_tabPanels[index].move(12,29);
				addContent(_tabPanels[index] as DisplayObject);
				_btns[index].selected = true;
				_currentType = index;
				return;
			}
			_btns[_currentType].selected = false;
			_tabPanels[_currentType].hide();
			_currentType = index;
			_btns[_currentType].selected = true;
			if(_tabPanels[_currentType] == null)
			{
				_tabPanels[_currentType] = new _class[_currentType](_mediator);
				_tabPanels[_currentType].move(12,29);		
			}
			addContent(_tabPanels[_currentType] as DisplayObject);

		}
		
		private function initData():void
		{
//			_teamStatePanel.getData();
			
			var list:Array = _mediator.sceneInfo.teamData.teamPlayers;
			if(list.length > 0)
			{
				for(var i:int = 0;i < list.length;i++)
				{
					var playerView:TeamPlayerView = new TeamPlayerView(list[i],_mediator);
					_playerTile.appendItem(playerView);
					_playerList.push(playerView);
				}
				_leaveTeamBtn.visible = true;
				_createTeamBtn.visible = false;
				_teamNoneTip.visible = false;
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			_labels = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_class = null;
			if(_btns)
			{
				for each(var i:MCacheTabBtn1 in _btns)
				{
					i.dispose();
				}
				_btns = null;
			}
			if(_tabPanels)
			{
				for each(var j:IgroupTabView in _tabPanels)
				{
					if(j)
					{
						j.dispose();
					}
				}
				_tabPanels = null;
			}
			_allowJoinCheckBox = null;
			_allowInvitCheckBox = null;
			if(_createTeamBtn)
			{
				_createTeamBtn.dispose();
				_createTeamBtn = null;
			}
			if(_leaveTeamBtn)
			{
				_leaveTeamBtn.dispose();
				_leaveTeamBtn = null;
			}
			if(_refeshBtn)
			{
				_refeshBtn.dispose();
				_refeshBtn = null;
			}
			
			super.dispose();
		}
	}
}