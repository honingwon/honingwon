package sszt.core.view
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.caches.PlayerIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.FriendModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import mhsm.ui.BarAsset2;
	
	public class FlashIcon extends Sprite implements ITick
	{
		private var _serverId:int;
		private var _id:Number;
		private var _nick:String;
		private var _nickLable:MAssetLabel;
		private var _bg:Bitmap;
		private var _isRead:Boolean;
		
		public function FlashIcon(serverId:int,id:Number,nick:String)
		{
			_serverId = serverId;
			_id = id;
			_nick = nick;
			super();
			init();
			initEvent();
		}
		
		private var _currentIndex:int = 0;
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_currentIndex <12)
			{
				alpha -= 0.08;
			}else
			{
				alpha += 0.08;
			}
			_currentIndex++;
			if(_currentIndex >= 25)
			{
				alpha = 1;
				_currentIndex = 0;
			} 
		}
		
		public function get id():Number
		{
			return _id;
		}
		
		public function get isRead():Boolean
		{
			return _isRead;
		}
		
		public function set isRead(value:Boolean):void
		{
			_isRead = value;
			if(!value)
			{
				GlobalAPI.tickManager.addTick(this);
			}else
			{
				GlobalAPI.tickManager.removeTick(this);
				alpha = 1;
			}
		}
		
		private function init():void
		{
			var player:ImPlayerInfo = GlobalData.imPlayList.getPlayer(_id);
			if(player.career != 0)
			{
				var index:int =  player.info.sex ? (player.career *2 - 1):(player.career *2 );	
			}else
			{
				index = 0;
			}
//			_bg = new Bitmap(FriendIconList.ICONS[index]);
			_bg = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.SMALL,index));
			_bg.width = 24;
			_bg.height = 24;
			addChild(_bg);
			
//			_nickLable = new MAssetLabel(_nick,MAssetLabel.LABELTYPE13,TextFormatAlign.LEFT);
//			_nickLable.move(15,1);
//			addChild(_nickLable);
			
			buttonMode = true;
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,clickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(_nick,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();	
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.MAX_CHAT_PANEL,{serverId:_serverId,id:_id}));
			isRead = true;
//			GlobalData.friendIconList.removeIcon(_id);
		}
		
		public function maxChatPanel():void
		{
			clickHandler(null);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			if(parent) parent.removeChild(this);
		}
	}
}