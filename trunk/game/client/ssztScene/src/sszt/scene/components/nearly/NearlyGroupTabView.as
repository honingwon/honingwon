package sszt.scene.components.nearly
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.nearly.nearlySec.NearGroupTitle;
	import sszt.scene.components.nearly.nearlySec.NearTeamItem;
	import sszt.scene.components.nearly.nearlySec.NearUnteamPlayerItem;
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.data.team.UnteamPlayerInfo;
	import sszt.scene.events.NearDataUpdateEvent;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.NearlyMediator;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	
	public class NearlyGroupTabView extends MScrollPanel implements INearlyTabView
	{
		private var _mediator:NearlyMediator;
		private var _title1:NearGroupTitle;
		private var _title2:NearGroupTitle;
		private var _tile1:MTile;
		private var _tile2:MTile;
		private var _items1:Array;
		private var _items2:Array;
		private var _inviteGroupBtn:MCacheAsset1Btn;
		private var _applyGroupBtn:MCacheAsset1Btn;
		private var _flashBtn:MCacheAsset1Btn;
		private var _addFriendBtn:MCacheAsset1Btn;
		private var _chatBtn:MCacheAsset1Btn;
		private var _applyChargeBtn:MCacheAsset1Btn;
		private var _currentTeamItem:NearTeamItem;
		private var _currentPlayerItem:NearUnteamPlayerItem;
		
		public function NearlyGroupTabView(mediator:NearlyMediator)
		{
			_mediator = mediator;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setSize(301,320);
			
			_title1 = new NearGroupTitle(LanguageManager.getWord("ssztl.scene.noFullTeam"));
			getContainer().addChild(_title1);
			
			_title2 = new NearGroupTitle(LanguageManager.getWord("ssztl.scene.noTeamPlayer"));
			_title2.y = _title1.height;
			getContainer().addChild(_title2);
			
			_tile1 = new MTile(280,22);
			_tile1.setSize(280,0);
			_tile1.y = _title1.height + 4;
			getContainer().addChild(_tile1);
			
			_tile2 = new MTile(280,22);
			_tile2.setSize(280,0);
			getContainer().addChild(_tile2);
			
			verticalScrollPolicy = ScrollPolicy.ON;
			horizontalScrollPolicy =ScrollPolicy.OFF;
			_tile1.verticalScrollPolicy = _tile1.horizontalScrollPolicy = _tile2.verticalScrollPolicy = _tile2.horizontalScrollPolicy = ScrollPolicy.OFF;
			
//			_items1 = new Vector.<NearTeamItem>();
//			_items2 = new Vector.<NearUnteamPlayerItem>();
			_items1 = [];
			_items2 = [];
			
			_inviteGroupBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.inviteTeam2"));
			_inviteGroupBtn.move(11,329);
			addChild(_inviteGroupBtn);
			
			_applyGroupBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.applyTeam"));
			_applyGroupBtn.move(110,329);
			addChild(_applyGroupBtn);
			
			_flashBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.common.refresh"));
			_flashBtn.move(209,329);
			addChild(_flashBtn);
			
			_addFriendBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.common.addToFriend"));
			_addFriendBtn.move(11,359);
			addChild(_addFriendBtn);
			
			_chatBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.inviteChat"));
			_chatBtn.move(110,359);
			addChild(_chatBtn);
			
			_applyChargeBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.applyTrade"));
			_applyChargeBtn.move(209,359);
			addChild(_applyChargeBtn);
			
			initEvent();
		}
		
		override protected function draw():void
		{
			var currentHeight:int = _title1.height;
			if(isInvalid(InvalidationType.STATE))
			{
				var tmpHeight:int = _items1.length * 24;
				_tile1.height = tmpHeight;
				currentHeight += tmpHeight;
				currentHeight += 3;
				_title2.y = currentHeight;
				currentHeight += _title2.height;
				_tile2.y = currentHeight + 4;
				tmpHeight = _items2.length * 24;
				_tile2.height = tmpHeight;
				_tile1.drawNow();
				_tile2.drawNow();
				currentHeight += tmpHeight;
				update(304,currentHeight);
			}
			super.draw();
		}
		
		public function getData():void
		{
			_mediator.getNearlyData();
		}
		
		protected function initEvent():void
		{
			_mediator.sceneInfo.nearData.addEventListener(NearDataUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,teamPlayerUpdateHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,teamPlayerUpdateHandler);
			_applyGroupBtn.addEventListener(MouseEvent.CLICK,applyGroupHandler);
			_inviteGroupBtn.addEventListener(MouseEvent.CLICK,inviteGroupHandler);
			_flashBtn.addEventListener(MouseEvent.CLICK,flashHandler);
			_addFriendBtn.addEventListener(MouseEvent.CLICK,addFriendHandler);
			_chatBtn.addEventListener(MouseEvent.CLICK,chatHandler);
			_applyChargeBtn.addEventListener(MouseEvent.CLICK,applyChargeHandler);
		}
		
		protected function removeEvent():void
		{
			_mediator.sceneInfo.nearData.removeEventListener(NearDataUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,teamPlayerUpdateHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,teamPlayerUpdateHandler);
			_applyGroupBtn.removeEventListener(MouseEvent.CLICK,applyGroupHandler);
			_inviteGroupBtn.removeEventListener(MouseEvent.CLICK,inviteGroupHandler);
			_flashBtn.removeEventListener(MouseEvent.CLICK,flashHandler);
			_addFriendBtn.removeEventListener(MouseEvent.CLICK,addFriendHandler);
			_chatBtn.removeEventListener(MouseEvent.CLICK,chatHandler);
			_applyChargeBtn.removeEventListener(MouseEvent.CLICK,applyChargeHandler);
		}
		
		private function applyGroupHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentTeamItem)
			{
				TeamInviteSocketHandler.sendInvite(_currentTeamItem.info.serverId,_currentTeamItem.info.name);
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOneTeam"));
			}
		}
		
		private function inviteGroupHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentPlayerItem)
			{
				TeamInviteSocketHandler.sendInvite(_currentPlayerItem.info.serverId,_currentPlayerItem.info.name);
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function flashHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			getData();
		}
		
		private function addFriendHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentPlayerItem)
			{
				if(GlobalData.imPlayList.getFriend(_currentPlayerItem.info.id) == null)
				{
					FriendUpdateSocketHandler.sendAddFriend(_currentPlayerItem.info.serverId,_currentPlayerItem.info.name,true);	
				}else
				{
					_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.inFriendList"));
				}
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function chatHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentPlayerItem)
			{
				ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:_currentPlayerItem.info.serverId,id:_currentPlayerItem.info.id,nick:"["+_currentPlayerItem.info.serverId+"]"+_currentPlayerItem.info.name,flag:1}));
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function applyChargeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentPlayerItem)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,_currentPlayerItem.info.id));
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function setDataCompleteHandler(evt:NearDataUpdateEvent):void
		{
			initDataView();
		}
		
		private function teamPlayerUpdateHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			getData();
		}
		
		private function initDataView():void
		{
			clearDataView();
//			var teams:Vector.<BaseTeamInfo> = _mediator.sceneInfo.nearData.teamList;
			var teams:Array = _mediator.sceneInfo.nearData.teamList;
			for each(var i:BaseTeamInfo in teams)
			{
				var teamItem:NearTeamItem = new NearTeamItem(i);
				_tile1.appendItem(teamItem);
				_items1.push(teamItem);
				teamItem.addEventListener(MouseEvent.CLICK,playerItemClickHandler);
			}
//			var players:Vector.<UnteamPlayerInfo> = _mediator.sceneInfo.nearData.unteamPlayers;
			var players:Array = _mediator.sceneInfo.nearData.unteamPlayers;
			for each(var j:UnteamPlayerInfo in players)
			{
				var playerItem:NearUnteamPlayerItem = new NearUnteamPlayerItem(j);
				_tile2.appendItem(playerItem);
				_items2.push(playerItem);
				playerItem.addEventListener(MouseEvent.CLICK,playerItemClickHandler);
			}
			invalidate(InvalidationType.STATE);
		}
		
		private function clearDataView():void
		{
			_tile1.clearItems();
			_tile2.clearItems();
			_currentPlayerItem = null;
			_currentTeamItem = null;
			for(var i:int = 0; i < _items1.length; i++)
			{
				_items1[i].dispose();
			}
//			_items1 = new Vector.<NearTeamItem>();
			_items1 = [];
			for(var j:int = 0; j < _items2.length; j++)
			{
				_items2[j].dispose();
			}
//			_items2 = new Vector.<NearUnteamPlayerItem>();
			_items2 = [];
		}
		
		private function playerItemClickHandler(evt:MouseEvent):void
		{
			if(_currentTeamItem) 
			{
				_currentTeamItem.selected = false;
				_currentTeamItem = null;
			}
			if(_currentPlayerItem)
			{
				_currentPlayerItem.selected = false;
				_currentPlayerItem = null;
			}	
			if(evt.currentTarget is NearTeamItem)
			{
				_currentTeamItem = evt.currentTarget as NearTeamItem;
				_currentTeamItem.selected = true;
			}else
			{
				_currentPlayerItem = evt.currentTarget as NearUnteamPlayerItem;
				_currentPlayerItem.selected = true;
			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_flashBtn)
			{
				_flashBtn.dispose();
				_flashBtn = null;
			}
			if(_addFriendBtn)
			{
				_addFriendBtn.dispose();
				_addFriendBtn = null;
			}
			if(_inviteGroupBtn)
			{
				_inviteGroupBtn.dispose();
				_inviteGroupBtn = null;
			}
			if(_chatBtn)
			{
				_chatBtn.dispose();
				_chatBtn = null;
			}
			if(_applyChargeBtn)
			{
				_applyChargeBtn.dispose();
				_applyChargeBtn = null;
			}
			_tile1.dispose();
			_tile1 = null;
			_tile2.dispose();
			_tile2 = null;
			for(var i:int =0;i<_items1.length;i++)
			{
				_items1[i].dispose();
			}
			_items1 = null;
			for(i = 0;i<_items2.length;i++)
			{
				_items2[i].dispose();
			}
			_items1 = null;
			super.dispose();
		}
	}
}