package sszt.scene.components.nearly
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
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
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.mediators.NearlyMediator;
	import sszt.scene.socketHandlers.TeamInviteSocketHandler;
	
	public class NearlyPlayerTabView extends BaseNearlyTabView
	{
		private var _tile:MTile;
//		private var _items:Vector.<NearlyPlayerItemView>;
		private var _items:Array;
		private var _currentItem:NearlyPlayerItemView;
		private var _inviteGroupBtn:MCacheAsset1Btn;
		private var _flashBtn:MCacheAsset1Btn;
		private var _addFriendBtn:MCacheAsset1Btn;
		private var _chatBtn:MCacheAsset1Btn;
		private var _applyChargeBtn:MCacheAsset1Btn;
		
		public function NearlyPlayerTabView(mediator:NearlyMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			
			_tile = new MTile(280,22);
			_tile.verticalScrollPolicy = ScrollPolicy.ON;
			_tile.setSize(301,312);
			_tile.move(0,8);
			addChild(_tile);
			
			_inviteGroupBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.inviteTeam2"));
			_inviteGroupBtn.move(11,329);
			addChild(_inviteGroupBtn);
					
			_flashBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.common.refresh"));
			_flashBtn.move(110,359);
			addChild(_flashBtn);
			
			_addFriendBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.common.addToFriend"));
			_addFriendBtn.move(110,329);
			addChild(_addFriendBtn);
			
			_chatBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.inviteChat"));
			_chatBtn.move(209,329);
			addChild(_chatBtn);
			
			_applyChargeBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.applyTrade"));
			_applyChargeBtn.move(11,359);
			addChild(_applyChargeBtn);
			
//			_items = new Vector.<NearlyPlayerItemView>();
			_items = [];
			initDatas();
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);

			_inviteGroupBtn.addEventListener(MouseEvent.CLICK,inviteGroupHandler);
			_flashBtn.addEventListener(MouseEvent.CLICK,flashHandler);
			_addFriendBtn.addEventListener(MouseEvent.CLICK,addFriendHandler);
			_chatBtn.addEventListener(MouseEvent.CLICK,chatHandler);
			_applyChargeBtn.addEventListener(MouseEvent.CLICK,applyChargeHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.ADDPLAYER,addPlayerHandler);
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			
			_inviteGroupBtn.removeEventListener(MouseEvent.CLICK,inviteGroupHandler);
			_flashBtn.removeEventListener(MouseEvent.CLICK,flashHandler);
			_addFriendBtn.removeEventListener(MouseEvent.CLICK,addFriendHandler);
			_chatBtn.removeEventListener(MouseEvent.CLICK,chatHandler);
			_applyChargeBtn.removeEventListener(MouseEvent.CLICK,applyChargeHandler);
		}
				
		private function inviteGroupHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentItem)
			{
				TeamInviteSocketHandler.sendInvite(_currentItem.info.info.serverId,_currentItem.info.info.nick);
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function flashHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			//自动刷新
		}
		
		private function addFriendHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentItem)
			{
				if(GlobalData.imPlayList.getPlayer(_currentItem.info.info.userId) == null)
				{
					FriendUpdateSocketHandler.sendAddFriend(_currentItem.info.info.serverId,_currentItem.info.info.nick,true);	
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
			if(_currentItem)
			{
				ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:_currentItem.info.info.serverId,id:_currentItem.info.info.userId,nick:"["+_currentItem.info.info.serverId+"]"+_currentItem.info.info.nick,flag:1}));
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function applyChargeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentItem)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,_currentItem.info.info.userId));
			}else
			{
				_mediator.sceneInfo.eventList.addEvent(LanguageManager.getWord("ssztl.scene.selectOnePlayer"));
			}
		}
		
		private function initDatas():void
		{
			var list:Dictionary = _mediator.sceneInfo.playerList.getPlayers();
			for each(var i:BaseScenePlayerInfo in list)
			{
				if(i.info.userId != GlobalData.selfPlayer.userId)
				{
					addItem(i);
				}
			}
		}
		
		private function addItem(info:BaseScenePlayerInfo):void
		{
			var item:NearlyPlayerItemView = new NearlyPlayerItemView(info);
			item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			_tile.appendItem(item);
			_items.push(item);
		}
		
		private function addPlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			var info:BaseScenePlayerInfo = evt.data as BaseScenePlayerInfo;
			addItem(info);
		}
		
		private function removePlayerHandler(evt:ScenePlayerListUpdateEvent):void
		{
			var info:BaseScenePlayerInfo = evt.data as BaseScenePlayerInfo;
			var item:NearlyPlayerItemView;
			for(var i:int = 0; i < _items.length; i++)
			{
				if(_items[i].info == info)
				{
					item = _items.splice(i,1)[0];
					break;
				}
			}
			if(item)
			{
				_tile.removeItem(item);
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				item.dispose();
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var item:NearlyPlayerItemView = evt.currentTarget as NearlyPlayerItemView;
			if(_currentItem) _currentItem.selected = false;
			_currentItem = item;
			_currentItem.selected = true ;
		}
		
		override public function dispose():void
		{
			removeEvent();
			for each(var i:NearlyPlayerItemView in _items)
			{
				i.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				i.dispose();
			}
			_items = null;
			if(_tile)
			{
				_tile.dispose();
			}
			_tile = null;
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
			super.dispose();
		}
	}
}