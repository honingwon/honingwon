package sszt.friends.component.subComponent
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.core.caches.PlayerIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.ImMessage;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.im.FriendDeleteSocketHandler;
	import sszt.core.utils.ColorUtils;
	import sszt.core.view.FlashIcon;
	import sszt.core.view.tips.PlayerTip;
	import sszt.friends.component.ChatPanel;
	import sszt.friends.component.MainPanel;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.ui.BarAsset3;
	
	public class ImAccordionItemView extends Sprite implements IDoubleClick,ITick
	{
		public static const ONLINE_CHANGE:String = "online change";
		public static const READ_CHANGE:String = "unread";
		private var _info:ImPlayerInfo;
		private var _selected:Boolean;
		private var _itemField:MAssetLabel;
		private var _itemFieldRight:TextField;
//		private var _icon:Bitmap;
		private var _width:int;
		private var _mediator:FriendsMediator;
		private var _gid:int;
		private var _bg:Sprite;
		private var _bgOver:Sprite;
		public var tempPoint:Point;
		
		public function ImAccordionItemView(mediator:FriendsMediator,info:ImPlayerInfo,gid:int,width:int)
		{
			_mediator = mediator;
			_width = width;
			_info = info;
			_gid = gid;
			super();
			init();
			initEvent();
		}
				
		private function init():void
		{
			buttonMode = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,_width,28);
			graphics.endFill();
			
			_bg = new Sprite();
			_bg = MBackgroundLabel.getDisplayObject(new Rectangle(-5,0,_width+10,28),new BarAsset3()) as Sprite;
//			var matr:Matrix = new Matrix();
//			matr.createGradientBox(_width,_width,0,0,0);
//			_bg.graphics.beginGradientFill(GradientType.LINEAR,[0x265d2b,0x265d2b],[1,0],[0,255],matr,SpreadMethod.PAD);
//			_bg.graphics.drawRect(0,0,_width,28);
//			_bg.graphics.endFill();
			addChild(_bg);
			_bg.visible = false;
			
			_bgOver = new Sprite();
			_bgOver = MBackgroundLabel.getDisplayObject(new Rectangle(-5,0,_width+10,28),new BarAsset3()) as Sprite;
			_bgOver.alpha = 0.8;
			addChild(_bgOver);
			_bgOver.visible = false;
			
			_itemField = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_itemField.setSize(_width,16);
			_itemField.move(24,6);
			_itemField.text = _info.info.nick;
			_itemField.mouseEnabled = false;
			addChild(_itemField);
			
			
			var sexString:String = "♂";
			if(_info.info.sex)
			{
				sexString = "♂";
			}
			else
			{
				sexString = "♀";
			}
			
			_itemField.setHtmlValue(sexString + _info.info.nick + (_info.info.level<1?"":('('+_info.info.level + LanguageManager.getWord("ssztl.common.levelLabel")+')')));
			
//			_itemFieldRight = new TextField();
//			_itemFieldRight.width = _width;
//			_itemFieldRight.height = 20;
//			_itemFieldRight.x = 109;
//			_itemFieldRight.text = CareerType.getNameByCareer(GlobalData.selfPlayer.career) +' ('+_info.info.level+')';
//			_itemFieldRight.textColor = 0xffffff;
//			_itemFieldRight.mouseEnabled = false;
//			addChild(_itemFieldRight);
			
			var index:int;
			index = _info.info.sex ? (_info.career *2 - 1):(_info.career *2 );
//			_icon = new Bitmap(MainPanel.smallIcons[index]);message += info.fromSex == 1 ? "♂" : "♀";
//			_icon = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.SMALL,index));
//			_icon.x = 25;
//			_icon.y = 2;
//			addChild(_icon);
			if(_info.isBlack || _info.online == 0)
			{
				setGray();	
			}			
		}
		public function set isOver(value:Boolean):void
		{
			_bgOver.visible = value;
		}
		
		public function click():void
		{
			PlayerTip.getInstance().show(_info.info.serverId,_info.info.userId,_info.info.nick,_gid,tempPoint);
		}
		
		public function doubleClick():void
		{
			_mediator.showChatPanel(_info.info.serverId,_info.info.userId,1);
		}
		
		public function get info():ImPlayerInfo
		{
			return _info;
		}
		
		private function setGray():void
		{
//			ColorUtils.setGray(_icon);
			ColorUtils.setGray(_itemField);
			_itemField.textColor = 0x777164;
		}
		
		private function removeGray():void
		{
//			_icon.filters = null;
			_itemField.filters = null;
			_itemField.textColor = 0xFFFCCC;
		}
		
		private function initEvent():void
		{
			_info.addEventListener(FriendEvent.ONLINE_CHANGE,onlineChangeHandler);
			_info.addEventListener(FriendEvent.CHATINFO_UPDATE,infoUpdateHandler);
			_info.addEventListener(FriendEvent.SET_READ,setReadHandler);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(FriendEvent.ONLINE_CHANGE,onlineChangeHandler);
			_info.removeEventListener(FriendEvent.CHATINFO_UPDATE,infoUpdateHandler);
			_info.removeEventListener(FriendEvent.SET_READ,setReadHandler);
		}
				
		private function setReadHandler(evt:FriendEvent):void
		{
			flash = false;
			dispatchEvent(new Event(ImAccordionItemView.READ_CHANGE));
		}
		
		private function infoUpdateHandler(evt:FriendEvent):void
		{
			var id:Number = _info.info.userId;
			var item:ImMessage = evt.data as ImMessage;
			if(item.type == ImMessage.UNREAD_TWO)
			{
				dispatchEvent(new Event(READ_CHANGE));
				flash = true;
			}
		}
		
		private function checkHasRead():void
		{
			if(!isRead)
			{
				flash = true;
			}
		}
		
		public function get isRead():Boolean
		{
			return _info.isRead;
		}
		
		private var _currentIndex:int;
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

		public function set flash(value:Boolean):void
		{
			if(value)
			{
				GlobalAPI.tickManager.addTick(this);
			}else
			{
				GlobalAPI.tickManager.removeTick(this);
				alpha = 1;
			}
		}
			
		private function onlineChangeHandler(evt:FriendEvent):void
		{
			var flag:Boolean = evt.data as Boolean;
			if(flag)
			{
				removeGray();
			}
			else
			{
				setGray();
			}
			dispatchEvent(new FriendEvent(FriendEvent.ONLINE_CHANGE,evt.data));
		}
				
		public function get selected():Boolean
		{
			return _selected;
		}
				
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_selected)
			{
//				_itemField.textColor = 0xffffff;
				_bg.visible = true;
			}
			else
			{
//				_itemField.textColor = 0xffffff;
				_bg.visible = false;
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			_info = null;
			_itemField = null;
			_itemFieldRight = null;
//			_icon = null;
			_mediator = null;
			tempPoint = null;
			if(_bg)
			{
//				_bg.dispose();
				_bg = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}