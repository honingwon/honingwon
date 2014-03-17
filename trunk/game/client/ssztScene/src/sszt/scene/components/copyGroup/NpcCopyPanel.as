package sszt.scene.components.copyGroup
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import mx.states.AddChild;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.copyGroup.sec.AwardItemView;
	import sszt.scene.components.copyGroup.sec.TeamItemView;
	import sszt.scene.components.copyGroup.sec.TeamPlayerView;
	import sszt.scene.components.copyGroup.sec.TeamStatePanel;
	import sszt.scene.components.group.groupSec.TeamPlayerItemView;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.CopyGroupMediator;
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
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
//	import scene.scene.BaseScene;
	
	public class NpcCopyPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:CopyGroupMediator;
		
		private var _copyNameLabel:MAssetLabel;
		private var _countLabel:MAssetLabel;
		private var _pickMode:ComboBox;
		private var _autoInTeam:ComboBox;
		private var _enterBtn:MCacheAssetBtn1;
		private var _createBtn:MCacheAssetBtn1;
		private var _outBtn:MCacheAssetBtn1;
		private var _flashBtn:MCacheAssetBtn1;
		
		private var _teamStatePanel:TeamStatePanel;
		private var _playerTile:MTile;
		private var _awardTile:MTile;
//		private var _playerList:Vector.<TeamPlayerView>;
//		private var _awardList:Vector.<AwardItemView>;
		private var _playerList:Array;
		private var _awardList:Array;
		
		private var _copyItem:CopyTemplateItem;
		private var _npcInfo:NpcTemplateInfo;
		private var _level:int;   //从第几关开始，默认0
		
		private var _btns:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		
		private var _teamNoneTip:MAssetLabel;
		
		private var _bgCover:Bitmap;
		private var _picPath:String;
		
		public function NpcCopyPanel(mediator:CopyGroupMediator,item:CopyTemplateItem,level:int)
		{
			_copyItem = item;
			_level = level;
			_npcInfo = NpcTemplateList.getNpc(item.id);
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.CopyGroupTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.CopyGroupTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(684,316);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,668,306)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,222,297)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(236,6,222,297)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(460,6,212,297)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(16,35,214,263)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(240,35,214,263)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(236,8,220,29)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(313,14,63,15),new Bitmap(AssetUtil.getAsset("ssztui.common.MyTeamTagAsset") as BitmapData)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgCover = new Bitmap();
			_bgCover.x = 462;
			_bgCover.y = 8;
			addContent(_bgCover);
			_picPath = GlobalAPI.pathManager.getBannerPath("bgCopyGroup.jpg");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(473,20,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.copyName")  + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(473,45,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.suggestNum"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(473,70,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.pickModle"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(473,95,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.autoInTeam2") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			var tabNameLabels:Array = [LanguageManager.getWord("ssztl.common.team"),LanguageManager.getWord("ssztl.scene.nearPlayer2")];
			_btns = new Array(tabNameLabels.length);
			_panels = new Array(tabNameLabels.length);
			
			for(var i:int = 0;i < tabNameLabels.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0,i+1,tabNameLabels[i]);
				_btns[i].move(i * 56 + 19,9);
				addContent(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnHandler);
			}
			
			_copyNameLabel = new MAssetLabel(_copyItem.name,MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_copyNameLabel.move(533,20);
			addContent(_copyNameLabel); 
			_countLabel = new MAssetLabel(String(_copyItem.minPlayer) + "-" + String(_copyItem.maxPlayer),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_countLabel.move(533,45);
			addContent(_countLabel);
			
			_pickMode = new ComboBox();
			_pickMode.setSize(100,22);
			_pickMode.move(532,66);
			addContent(_pickMode);
			_pickMode.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.scene.autoPick"),value:0},
				{label:LanguageManager.getWord("ssztl.scene.autoAssign"),value:1}]);
			
			_pickMode.selectedItem = _pickMode.dataProvider.getItemAt(_mediator.sceneInfo.teamData.allocationValue);
			
			_autoInTeam = new ComboBox();
			_autoInTeam.setSize(100,22);
			_autoInTeam.move(532,91);
			addContent(_autoInTeam);
			_autoInTeam.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.common.open"),value:0},
				{label:LanguageManager.getWord("ssztl.common.close"),value:1}]);
			
			if(_mediator.sceneInfo.teamData.autoInTeam)
				_autoInTeam.selectedItem = _autoInTeam.dataProvider.getItemAt(0);
			else
				_autoInTeam.selectedItem = _autoInTeam.dataProvider.getItemAt(1);
			
			
			if(_mediator.sceneInfo.teamData.leadId != GlobalData.selfPlayer.userId)
			{
				_autoInTeam.enabled = false;
				_pickMode.enabled = false;
			}
					
//			_playerList = new Vector.<TeamPlayerView>();
//			_awardList = new Vector.<AwardItemView>();
			_playerList = [];
			_awardList = [];
		
			_teamStatePanel = new TeamStatePanel(_mediator);
			_teamStatePanel.move(18,37);
			addContent(_teamStatePanel);
			
			_playerTile = new MTile(210,32,1);
			_playerTile.setSize(210,160);
			_playerTile.move(242,37);
			_playerTile.horizontalScrollPolicy = _playerTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_playerTile);
			
			_teamNoneTip = new MAssetLabel(LanguageManager.getWord("ssztl.chat.noTeam"), MAssetLabel.LABEL_TYPE_YAHEI);
			_teamNoneTip.textColor = 0x827960;
			_teamNoneTip.move(242,126);
			_teamNoneTip.setSize(210,20);
			addContent(_teamNoneTip);
			
			_awardTile = new MTile(38,38,5);
			_awardTile.itemGapH = _awardTile.itemGapW = 1;
			_awardTile.setSize(220,80);
			_awardTile.move(469,155);
			_awardTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_awardTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_awardTile.verticalScrollBar.lineScrollSize = 40;
			addContent(_awardTile);
			
			_enterBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.scene.enterCopy"));
			_enterBtn.move(516,258);
			addContent(_enterBtn);
			
			_createBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.createTeam"));
			_createBtn.move(310,260);
			addContent(_createBtn);
			
			_outBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.exitTeam"));
			_outBtn.move(310,260);
			addContent(_outBtn);
			_outBtn.visible = false;
			
			_flashBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.refresh"));
			_flashBtn.move(96,260);
			addContent(_flashBtn);
			
			if(_mediator.sceneInfo.teamData.leadId != 0)
			{
				_createBtn.visible = false;
				_outBtn.visible = true;
				_teamNoneTip.visible = false;
			}
			setIndex(0);
			initData();
			initEvent();
			getData();
		}
		
		private function setIndex(argIndex:int):void
		{
			if(argIndex == _currentIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
			}
			_teamStatePanel.setPage(argIndex);
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function getData():void
		{
			_mediator.getCopyEnterCount();
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,changeLeaderHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addPlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_enterBtn.addEventListener(MouseEvent.CLICK,enterClickHandler);
			_createBtn.addEventListener(MouseEvent.CLICK,createClickHandler);
			_outBtn.addEventListener(MouseEvent.CLICK,outClickHandler);
			_flashBtn.addEventListener(MouseEvent.CLICK,flashBtnClickHandler);
			_autoInTeam.addEventListener(Event.CHANGE,settingHandler);
			_pickMode.addEventListener(Event.CHANGE,settingHandler);
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,changeLeaderHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addPlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_enterBtn.removeEventListener(MouseEvent.CLICK,enterClickHandler);
			_createBtn.removeEventListener(MouseEvent.CLICK,createClickHandler);
			_outBtn.removeEventListener(MouseEvent.CLICK,outClickHandler);
			_flashBtn.removeEventListener(MouseEvent.CLICK,flashBtnClickHandler);
			_autoInTeam.removeEventListener(Event.CHANGE,settingHandler);
			_pickMode.removeEventListener(Event.CHANGE,settingHandler);
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
		}
		
		private function selfMoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(_npcInfo == null) return;
			var selfInfo:BaseSceneObjInfo = evt.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		private function settingHandler(evt:Event):void
		{
			var auto:Boolean = false;
			if(_autoInTeam.selectedItem.value == 0)
				auto = true;
			TeamChangeSettingSocketHandler.sendSetting(auto,_pickMode.selectedItem.value);
		}
		
		private function flashBtnClickHandler(evt:MouseEvent):void
		{
			_teamStatePanel.getData();
		}
		
		private function changeLeaderHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var id:Number = evt.data as Number;
			if(id == GlobalData.selfPlayer.userId)
			{
				_autoInTeam.enabled = true;
				_pickMode.enabled = true;
				for(var i:int = 0;i<_playerList.length;i++)
				{
					_playerList[i].setLeader();
				}
			}else
			{
				_autoInTeam.enabled = false;
				_pickMode.enabled = false;
			}
		}
		
		private function addPlayerHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var player:TeamScenePlayerInfo = evt.data as TeamScenePlayerInfo;
			var playerView:TeamPlayerView = new TeamPlayerView(player,_mediator);
			_playerList.push(playerView);
			_playerTile.appendItem(playerView);
			_outBtn.visible = true;
			_createBtn.visible = false;
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
					_outBtn.visible = false;
					_createBtn.visible = true;
					_teamNoneTip.visible = true;
				}
			}
		}
			
		private function enterClickHandler(evt:MouseEvent):void
		{
			if(_mediator.sceneInfo.teamData.leadId == 0)
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.createTeamNow"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,enterAlertHandler);
				return;
			}
			if(GlobalData.selfPlayer.level < _copyItem.minLevel) 
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.levelNoAchieveCopyValue",_copyItem.minLevel));
				return ;
			}
			if(GlobalData.selfPlayer.level > _copyItem.maxLevel)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.overMaxLevelLimited"));
				return ;
			}
			if(_mediator.sceneInfo.teamData.teamPlayers.length > 1 && _copyItem.maxPlayer == 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.onlySingleEnter"));
				return;
			}
			if(_mediator.sceneInfo.teamData.teamPlayers.length > _copyItem.maxPlayer)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.copyEnterMaxNum")+ _copyItem.maxPlayer);
				return;
			}
			if(_mediator.sceneInfo.teamData.teamPlayers.length < _copyItem.minPlayer)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.copyEnterMinNum")+ _copyItem.minPlayer);
				return;
			}
			if(_mediator.sceneInfo.teamData.leadId != GlobalData.selfPlayer.userId)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.teamLeaderCanApply"));
				return ;
			}
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.transporting"));
				return ;
			}
//			if(!_mediator.sceneInfo.teamData.canEnterCopy(_copyItem))
//			{
//				QuickTips.show("存在队伍成员不符合进入副本等级条件！");
//				return ;
//			}
			var count:int = GlobalData.copyEnterCountList.getItemCount(_copyItem.id);
			if(count >= _copyItem.dayTimes)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.copyLeftZero"));
				return;
			}
			_mediator.enterCopy(_copyItem.id,_level);
			dispose();
		}
		
		private function enterAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				createClickHandler(null);
			}
		}
		
		private function createClickHandler(evt:MouseEvent):void
		{
			TeamCreateSocketHandler.send();
			_createBtn.visible = false;
			_outBtn.visible = true;
			_teamNoneTip.visible = false;
		}
		
		private function outClickHandler(evt:MouseEvent):void
		{
			TeamLeaveSocketHandler.sendLeave();
			_outBtn.visible = false;
			_createBtn.visible = true;
			_teamNoneTip.visible = true;
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgCover.bitmapData = data;
		}
		private function initData():void
		{
			_teamStatePanel.getData();
			
//			var list:Vector.<TeamScenePlayerInfo> = _mediator.sceneInfo.teamData.teamPlayers;
			var list:Array = _mediator.sceneInfo.teamData.teamPlayers;
			for(var i:int = 0;i < list.length;i++)
			{
				var playerView:TeamPlayerView = new TeamPlayerView(list[i],_mediator);
				_playerTile.appendItem(playerView);
				_playerList.push(playerView);
			}
			if(_copyItem)
			{
//				var ids:Vector.<Number> = _copyItem.dropItemList;
				var ids:Array = _copyItem.award;
				for(i = 0;i < ids.length;i++)
				{
					var template:ItemTemplateInfo = ItemTemplateList.getTemplate(ids[i]);
					if(template)
					{
						var award:AwardItemView = new AwardItemView(template);
						_awardTile.appendItem(award);
						_awardList.push(award);
					}
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgCover)
			{
				_bgCover = null;
			}
			_mediator = null;
			_copyNameLabel = null;
			_countLabel = null;
			_pickMode = null;
			_autoInTeam = null;
			_enterBtn = null;
			_createBtn = null;
			_outBtn = null;
			_flashBtn = null;
			
			_teamStatePanel = null;
			if(_playerTile)
			{
				_playerTile.dispose();
				_playerTile = null;
			}
			if(_awardTile)
			{
				_awardTile.dispose();
				_awardTile = null;
			}
			_playerList = null;
			_awardList = null;
			
			_copyItem = null;
			_npcInfo = null;
			_btns = null;
			_panels = null;
			_teamNoneTip = null;
			_picPath = null;
		}
	}
}