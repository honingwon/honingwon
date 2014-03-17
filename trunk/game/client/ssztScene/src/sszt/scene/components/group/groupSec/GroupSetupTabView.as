package sszt.scene.components.group.groupSec
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset2Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.GroupMediator;
	import sszt.scene.socketHandlers.TeamChangeSettingSocketHandler;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GroupSetupTabView extends Sprite implements IgroupTabView
	{
		private var _mediator:GroupMediator;
		private var _bg:IMovieWrapper;
		private var _autoInTeam:ComboBox;
		private var _allocationType:ComboBox;
		private var _inputPlayer:TextField;
		private var _tile:MTile;
//		private var _nearPlayers:Vector.<NearPlayerView>;
		private var _nearPlayers:Array;
		private var _field1:TextField,_field2:TextField;
		private var _okBtn:MCacheAsset2Btn;
		private var _inviteBtn:MCacheAsset1Btn;
		private var _combobox:ComboBox;
		
		public function GroupSetupTabView(mediator:GroupMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(261,3,2,234),new MCacheSplit4Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(270,50,314,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(385,26,143,19)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(303,75,259,143)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(306,78,254,24)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(389,80,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(470,80,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(307,122,229,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(307,145,229,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(307,168,229,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(307,191,229,2),new MCacheSplit2Line())
				]);
			addChild(_bg as DisplayObject);
			
			var labels:Array = [LanguageManager.getWord("ssztl.scene.teamSetting"),
				LanguageManager.getWord("ssztl.scene.inviteTeam2") + "：",
				LanguageManager.getWord("ssztl.scene.nearPlayer2") + "：",
				LanguageManager.getWord("ssztl.common.playerName"),
				LanguageManager.getWord("ssztl.common.carrer"),
				LanguageManager.getWord("ssztl.common.level2"),
				LanguageManager.getWord("ssztl.scene.isAutoInTeam"),
				LanguageManager.getWord("ssztl.scene.itemAssignModle"),
				LanguageManager.getWord("ssztl.common.playerName"),
				LanguageManager.getWord("ssztl.scene.canAutoInput")];
			var poses:Array = [new Point(10,5),new Point(269,5),new Point(269,53),new Point(324,81),new Point(420,81),new Point(499,81),
				new Point(15,33),new Point(15,104),new Point(269,27),new Point(325,219)];
			for(var i:int = 0; i < labels.length; i++)
			{
				var label:MAssetLabel = new MAssetLabel(labels[i],i < 6 ? MAssetLabel.LABELTYPE14 : MAssetLabel.LABELTYPE4);
				label.move(poses[i].x,poses[i].y);
				addChild(label);
			}
			
			_combobox = new ComboBox();
			_combobox.setSize(50,20);
			_combobox.move(332,26);
			_combobox.editable = false;
			var dp:DataProvider = new DataProvider();
			var index:int = 0;
			for each(var id:int in GlobalData.serverList)
			{
				if(id == GlobalData.selfPlayer.serverId)index = GlobalData.serverList.indexOf(String(id));
//				dp.addItem({label:id+"服",value:id});
				dp.addItem({label:LanguageManager.getWord("ssztl.common.serverValue",id),value:id});
			}
			_combobox.dataProvider = dp;
			addChild(_combobox);
			_combobox.selectedIndex = index;
			
			_field1 = new TextField();
			_field1.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
			_field1.mouseEnabled = _field1.mouseWheelEnabled = false;
			_field1.wordWrap = true;
			_field1.x = 15;
			_field1.y = 59;
			_field1.width = 232;
			_field1.text = LanguageManager.getWord("ssztl.scene.autoTeamExplain");
			addChild(_field1);
			_field2 = new TextField();
			_field2.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
			_field2.mouseEnabled = _field2.mouseWheelEnabled = false;
			_field2.wordWrap = true;
			_field2.x = 15;
			_field2.y = 142;
			_field2.width = 232;
			_field2.text = LanguageManager.getWord("ssztl.scene.autoPickExplain");
			addChild(_field2);
			
			_autoInTeam = new ComboBox();
			_autoInTeam.move(99,33);
			_autoInTeam.setSize(109,20);
			_autoInTeam.enabled = true;
			addChild(_autoInTeam);
			_autoInTeam.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.common.yes"),value:0},{label:LanguageManager.getWord("ssztl.common.no"),value:1}]);
			if(_mediator.sceneInfo.teamData.autoInTeam)
				_autoInTeam.selectedItem = _autoInTeam.dataProvider.getItemAt(0);
			else
				_autoInTeam.selectedItem = _autoInTeam.dataProvider.getItemAt(1);
			_autoInTeam.enabled = false;
			
			_allocationType = new ComboBox();
			_allocationType.move(99,104);
			_allocationType.setSize(109,20);
			_allocationType.enabled = true;
			addChild(_allocationType);
			_allocationType.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.scene.autoPick"),value:0},{label:LanguageManager.getWord("ssztl.scene.autoAssign"),value:1}]);
			_allocationType.selectedItem = _allocationType.dataProvider.getItemAt(_mediator.sceneInfo.teamData.allocationValue);
			_allocationType.enabled = false;
			
			_inputPlayer = new TextField();
			_inputPlayer.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_inputPlayer.height = 22;
			_inputPlayer.width = 160;
			_inputPlayer.x = 380;
			_inputPlayer.y = 28;
			_inputPlayer.type = TextFieldType.INPUT;
			_inputPlayer.text = LanguageManager.getWord("ssztl.scene.clickInputUserName");
			addChild(_inputPlayer);
			
			_inviteBtn = new MCacheAsset1Btn(0,LanguageManager.getWord("ssztl.common.invite"));
			_inviteBtn.move(533,21);
			addChild(_inviteBtn);
			_inviteBtn.enabled = false;
			
			_okBtn = new MCacheAsset2Btn(1,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(68,198);
			addChild(_okBtn);
			_okBtn.enabled = false;
			
			_tile = new MTile(230,21,1);
			_tile.setSize(250,113);
			_tile.move(306,105);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollBar.lineScrollSize = 23;
			_tile.verticalScrollPolicy = ScrollPolicy.ON;
			addChild(_tile);
			
//			var list:Vector.<TeamScenePlayerInfo> = _mediator.sceneInfo.teamData.teamPlayers;
			var list:Array = _mediator.sceneInfo.teamData.teamPlayers;
			if(list.length == 0)
			{
				_inviteBtn.enabled = true;
				_okBtn.enabled = false;
				_autoInTeam.enabled = false;
				_allocationType.enabled = false;
			}else
			{
				if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
				{
					_okBtn.enabled = true;
					_inviteBtn.enabled = true;
					_autoInTeam.enabled = true;
					_allocationType.enabled = true;
				}else
				{
					_okBtn.enabled = false;
					_inviteBtn.enabled = false;
					_autoInTeam.enabled = false;
					_allocationType.enabled = false;
				}
			}
			
//			_nearPlayers = new Vector.<NearPlayerView>();
			_nearPlayers = [];
			initData();
		}
		
		private function initData():void
		{
			var list:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
			var count:int =0;
			for each(var i:BaseScenePlayerInfo in list)
			{
				if(i.info.userId != GlobalData.selfPlayer.userId)
				{
					addItem(i);
					count++;
				}
			}
		}
		
		private function addItem(item:BaseScenePlayerInfo):void
		{
			var itemView:NearPlayerView = new NearPlayerView(item);
			_tile.appendItem(itemView);
			itemView.addEventListener(MouseEvent.CLICK,itemClickHandler);
			_nearPlayers.push(itemView);
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var itemView:NearPlayerView = evt.currentTarget as NearPlayerView;
			_inputPlayer.text = itemView.info.info.nick;
			_combobox.selectedIndex = GlobalData.serverList.indexOf(String(itemView.info.info.serverId));
		}
			
		private function initEvent():void
		{
			_inviteBtn.addEventListener(MouseEvent.CLICK,inviteBtnHandler);
			_okBtn.addEventListener(MouseEvent.CLICK,okBtnClickHandler);
			_inputPlayer.addEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			_inputPlayer.addEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,changeLeaderHandler);
		}
		
		private function removeEvent():void
		{
			_inviteBtn.removeEventListener(MouseEvent.CLICK,inviteBtnHandler);
			_okBtn.removeEventListener(MouseEvent.CLICK,okBtnClickHandler);
			_inputPlayer.removeEventListener(FocusEvent.FOCUS_IN,focusInHandler);
			_inputPlayer.removeEventListener(FocusEvent.FOCUS_OUT,focusOutHandler);
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,changeLeaderHandler);
		}
		
		private function okBtnClickHandler(e:MouseEvent):void
		{
			var auto:Boolean = false;
			if(_autoInTeam.selectedItem.value == 0)
				auto = true;
			TeamChangeSettingSocketHandler.sendSetting(auto,_allocationType.selectedItem.value);
		}
		
		private function focusInHandler(evt:FocusEvent):void
		{
			if(LanguageManager.getWord("ssztl.scene.clickInputUserName"))_inputPlayer.text = "";
		}
		
		private function focusOutHandler(e:FocusEvent):void
		{
			if(_inputPlayer.text == "")_inputPlayer.text = LanguageManager.getWord("ssztl.scene.clickInputUserName");
		}
		
		private function changeLeaderHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var id:Number = evt.data as Number;
			if(GlobalData.selfPlayer.userId == id)
			{
				_okBtn.enabled = true;
				_inviteBtn.enabled = true;
				_autoInTeam.enabled = true;
				_allocationType.enabled = true;
			}else
			{
				if(id == 0)_inviteBtn.enabled = true;
				else _inviteBtn.enabled = false;
				_okBtn.enabled = false;
				_autoInTeam.enabled = false;
				_allocationType.enabled = false;
			}
		}
		
		private function addPlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			var item:BaseScenePlayerInfo = evt.data as BaseScenePlayerInfo;
			if(item.info.userId != GlobalData.selfPlayer.userId)
			{
				addItem(item);
			}
		}
		
		private function removePlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			var info:BaseScenePlayerInfo = evt.data as BaseScenePlayerInfo;
			for(var i:int =0;i<_nearPlayers.length;i++)
			{
				if(_nearPlayers[i].info == info)
				{
					var item:NearPlayerView = _nearPlayers.splice(i,1)[0];
					_tile.removeItem(item);
					break;
				}
			}
		}
		
		private function inviteBtnHandler(e:MouseEvent):void
		{
			if(_inputPlayer.text == "" && _inputPlayer.text == LanguageManager.getWord("ssztl.scene.clickInputUserName"))
				QuickTips.show( LanguageManager.getWord("ssztl.scene.inputRightName"));
			else
			{
				if(GlobalData.copyEnterCountList.isInCopy)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
					return;
				}
				TeamInviteSocketHandler.sendInvite(_combobox.selectedItem.value,_inputPlayer.text);
			}
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_inviteBtn)
			{
				_inviteBtn.dispose();
				_inviteBtn = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_nearPlayers)
			{
				for(var i:int = 0;i<_nearPlayers.length;i++)
				{
					_nearPlayers[i].dispose();
				}
				_nearPlayers = null;
			}
			_autoInTeam = null;
			_allocationType = null;
			_inputPlayer = null;
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}