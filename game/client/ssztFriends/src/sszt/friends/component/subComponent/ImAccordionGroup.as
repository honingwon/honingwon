package sszt.friends.component.subComponent
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.GroupType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.im.FriendDeleteSocketHandler;
	import sszt.core.view.tips.PlayerAmityTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.ui.container.MTile;
	
	public class ImAccordionGroup extends Sprite
	{
		public static const SELECT_CHANGE:String = "selectChange";
		public static const ITEM_CHANGE:String = "itemChange";
		
		private var _titleView:ImAccordionTitleView;
		private var _tile:MTile;
//		private var _itemViewList:Vector.<ImAccordionItemView>;
		private var _itemViewList:Array;
		private var _title:String;
		private var _itemValues:Dictionary;		
		private var _width:int;
		private var _showItemCount:int;
		private var _selected:Boolean;
		private var _currentItem:ImAccordionItemView;
		private var _mediator:FriendsMediator;
		private var _gId:Number;
		public var tempPoint:Point;
		public function ImAccordionGroup(id:Number,mediator:FriendsMediator,title:String,itemValues:Dictionary,width:int,showItemCount:int)
		{
			_gId = id;
			_mediator = mediator;
			_title = title;
			_itemValues = itemValues;
			_width = width;
			_showItemCount = getDataLength(itemValues);
//			_itemViewList = new Vector.<ImAccordionItemView>();
			_itemViewList = new Array();
			super();
			init();
			initEvent();
		}
		
		public function changeTitle(title:String):void
		{
			_title = title;	
			_titleView.changeTitle(title);
		}
		
		public function getID():Number
		{
			return _gId;
		}
		
		public function getDataLength(data:Dictionary):int
		{
			var count:int = 0;
			for each(var i:ImPlayerInfo in data)
			{
				count++;
			}
			return count;
		}
		
		public function getOnlineNumer(data:Dictionary):int
		{
			var count:int = 0;
			for each(var i:ImPlayerInfo in data)
			{
				if(i.online == 1 && !i.isBlack)
				{
					count++;
				}
			}
			return count;
		}
		
		private function init():void
		{
			_titleView = createTitleView(_title, _width);
			addChild(_titleView);
			_tile = new MTile(_width, 28);
			_tile.itemGapH = 1;
			_tile.move(0, _titleView.height + 2);
			_tile.setSize(_width, 0);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			_tile.visible = false;
			initTile();
			readChangeHandler(null);
		}
		
		private function initTile():void
		{
			for each(var i:ImPlayerInfo in _itemValues)
			{
				var item:ImAccordionItemView = createItemView(i,_width);
				_itemViewList.push(item);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				item.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
				item.addEventListener(FriendEvent.ONLINE_CHANGE,onlineChangeHandler);
				item.addEventListener(ImAccordionItemView.READ_CHANGE,readChangeHandler);
				if(_gId == GroupType.RECENT) item.info.addEventListener(FriendEvent.NEW_RECENT,newRecentHandler)
			}
			var showCount:int;
			_tile.height = _showItemCount * (28 + 2);
			
			_itemViewList.sort(compareFunction);
			for(var j:int =0;j<_itemViewList.length;j++)
			{
				_tile.appendItem(_itemViewList[j]);
			}
		}
		
		private function readChangeHandler(evt:Event):void
		{
			var count:int = 0;
			for(var i:int = 0;i<_itemViewList.length;i++)
			{
				if(!_itemViewList[i].isRead)
				{
					count++;
					break;
				}
			}
			if(count > 0)
			{
				_titleView.flash = true;
			}else
			{
				_titleView.flash = false;
			}
		}
		
		private function compareFunction(item1:ImAccordionItemView,item2:ImAccordionItemView):int
		{
			if(item1.info.online>=item2.info.online) return -1;
			else return 1;
		}
				
		protected function createTitleView(title:String,width:int):ImAccordionTitleView
		{
			if(_gId == GroupType.BLACK)
			{
				var onCount:int = 0;
			}else
			{
				onCount = getOnlineNumer(_itemValues);
			}
			var allCount:int = getDataLength(_itemValues)
			return new ImAccordionTitleView(title,width,onCount,allCount);
		}
		
		protected function createItemView(info:ImPlayerInfo,width:int):ImAccordionItemView
		{
			return new ImAccordionItemView(_mediator,info,_gId,width);
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			DoubleClickManager.addClick(evt.currentTarget as IDoubleClick);
			if(_currentItem)_currentItem.selected = false;
			_currentItem = evt.currentTarget as ImAccordionItemView;
			_currentItem.tempPoint = new Point(evt.stageX,evt.stageY);
			_currentItem.selected = true;
		}
		
		private function itemOverHandler(evt:MouseEvent):void
		{
			var imItemView:ImAccordionItemView = evt.currentTarget as ImAccordionItemView;
			var tip:String = 
				LanguageManager.getWord("ssztl.common.level")+"："+ imItemView.info.info.level + LanguageManager.getWord("ssztl.common.levelLabel") + "\n" +
				LanguageManager.getWord("ssztl.friends.near")+"："+ imItemView.info.amity + "\n" +
				LanguageManager.getWord("ssztl.friends.nearLevel")+"：" + getNearLevel(imItemView.info.amity);
			TipsUtil.getInstance().show(tip,null,new Rectangle(evt.stageX,evt.stageY,0,0));
			
			imItemView.isOver = true;
		}
		
		private function getNearLevel(nearValue:int):String
		{
			var nearLevel:String = LanguageManager.getWord("ssztl.friends.nearLevel1");
			if(nearValue >= 0 && nearValue < 1000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel1");
			}
			if(nearValue >= 1000 && nearValue < 3000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel2");
			}
			else if(nearValue >= 3000 && nearValue < 7000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel3");
			}
			else if(nearValue >= 7000 && nearValue < 15000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel4");
			}
			else if(nearValue >= 15000 && nearValue < 31000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel5");
			}
			else if(nearValue >= 31000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel6");
			}
			return nearLevel;
		}
		
		private function itemOutHandler(evt:MouseEvent):void
		{
			var imItemView:ImAccordionItemView = evt.currentTarget as ImAccordionItemView;
			TipsUtil.getInstance().hide();
			imItemView.isOver = false;
		}
		
		private function initEvent():void
		{
			_titleView.addEventListener(MouseEvent.CLICK,titleClickHandler);
			if(_gId>=0)
			{
				GlobalData.imPlayList.addEventListener(FriendEvent.ADD_FRIEND,addItemViewHandler);
				GlobalData.imPlayList.addEventListener(FriendEvent.DELETE_FRIEND,deleteItemViewHandler);
			}
			if(_gId == GroupType.BLACK)
			{
				GlobalData.imPlayList.addEventListener(FriendEvent.ADD_BLACK,addItemViewHandler);
				GlobalData.imPlayList.addEventListener(FriendEvent.DELETE_BLACK,deleteItemViewHandler);
			}
			if(_gId == GroupType.ENEMY)
			{
				GlobalData.imPlayList.addEventListener(FriendEvent.ADD_ENEMY,addItemViewHandler);
				GlobalData.imPlayList.addEventListener(FriendEvent.DELETE_ENEMY,deleteItemViewHandler);
			}
			if(_gId == GroupType.RECENT)
			{
				GlobalData.imPlayList.addEventListener(FriendEvent.ADD_RECENR,addItemViewHandler);
				GlobalData.imPlayList.addEventListener(FriendEvent.REMOVE_RECENT,deleteItemViewHandler);
			}
			if(_gId == GroupType.STRANGER)
			{
				GlobalData.imPlayList.addEventListener(FriendEvent.ADD_STRANGER,addItemViewHandler);
				GlobalData.imPlayList.addEventListener(FriendEvent.REMOVE_STRANGER,deleteItemViewHandler);
			}
		}
		
		private function removeEvent():void
		{
			_titleView.removeEventListener(MouseEvent.CLICK,titleClickHandler);
			if(_gId>=0)
			{
				GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_FRIEND,addItemViewHandler);
				GlobalData.imPlayList.removeEventListener(FriendEvent.DELETE_FRIEND,deleteItemViewHandler);
			}
			if(_gId == GroupType.BLACK)
			{
				GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_BLACK,addItemViewHandler);
				GlobalData.imPlayList.removeEventListener(FriendEvent.DELETE_BLACK,deleteItemViewHandler);
			}
			if(_gId == GroupType.ENEMY)
			{
				GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_ENEMY,addItemViewHandler);
				GlobalData.imPlayList.removeEventListener(FriendEvent.DELETE_ENEMY,deleteItemViewHandler);
			}
			if(_gId == GroupType.RECENT)
			{
				GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_RECENR,addItemViewHandler);
				GlobalData.imPlayList.removeEventListener(FriendEvent.REMOVE_RECENT,deleteItemViewHandler);
			}
			if(_gId == GroupType.STRANGER)
			{
				GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_STRANGER,addItemViewHandler);
				GlobalData.imPlayList.removeEventListener(FriendEvent.REMOVE_STRANGER,deleteItemViewHandler);
			}
		}
		
		private function onlineChangeHandler(evt:FriendEvent):void
		{
			var flag:Boolean = evt.data as Boolean;
			if(flag)
			{
				_titleView.changeState(1,0);
			}else
			{
				_titleView.changeState(-1,0);
			}
			_tile.clearItems();
			_itemViewList.sort(compareFunction);
			for(var i:int =0;i<_itemViewList.length;i++)
			{
				_tile.appendItem(_itemViewList[i]);
			}
			dispatchEvent(new Event(ITEM_CHANGE));
		}
		
		private function deleteItemViewHandler(evt:FriendEvent):void
		{
			var id:Number = evt.data as Number;
			var count:int = _tile.getItemCount();
			for( var i:int = 0;i<count;i++)
			{
				var item:ImAccordionItemView = _tile.getItemAt(i) as ImAccordionItemView;
				if(id == item.info.info.userId)
				{
					if(_gId == GroupType.BLACK)	_titleView.changeState(0,-1);
					else _titleView.changeState(-item.info.online,-1);
					var index:int = _itemViewList.indexOf(item);
					_itemViewList.splice(index,1);
					_tile.removeItem(item);
					item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
					item.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
					item.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
					item.removeEventListener(FriendEvent.ONLINE_CHANGE,onlineChangeHandler);
					item.removeEventListener(ImAccordionItemView.READ_CHANGE,readChangeHandler);
					if(_gId == GroupType.RECENT) item.info.removeEventListener(FriendEvent.NEW_RECENT,newRecentHandler)
					delete _itemValues[id];
					_tile.height = getDataLength(_itemValues)*(28+2);
					dispatchEvent(new Event(ITEM_CHANGE));
					break;
				}
			}
		}
		
		private function newRecentHandler(evt:FriendEvent):void
		{
			var id:Number= evt.data as Number;
			if(!_itemViewList) return;
			for(var i:int = 0;i<_itemViewList.length;i++)
			{
				if(_itemViewList[i].info.info.userId == id)
				{
					var item:ImAccordionItemView = _itemViewList.splice(i,1)[0];
					_itemViewList.unshift(item);
					break;
				}
			}
			_tile.clearItems();
			for(i = 0;i<_itemViewList.length;i++)
			{
				_tile.appendItem(_itemViewList[i]);
			}
			dispatchEvent(new Event(ITEM_CHANGE));	
		}
		
		private function addItemViewHandler(evt:FriendEvent):void
		{
			var data:ImPlayerInfo = evt.data as ImPlayerInfo;
			if(data.isFriend && _gId>=0)
			{
				if(data.group == _gId)
				{
					addItem(data);
				}
			}else
			{
				addItem(data);
			}
		}
		
		private function addItem(data:ImPlayerInfo):void
		{
			if(data.isBlack)
			{
				_titleView.changeState(0,1);
			}else
			{
				_titleView.changeState(data.online,1);
			}
			var item:ImAccordionItemView = createItemView(data,_width);
			_itemViewList.push(item);
			_itemValues[data.info.userId] = data;
			item.addEventListener(MouseEvent.CLICK,itemClickHandler);
			item.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			item.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			item.addEventListener(FriendEvent.ONLINE_CHANGE,onlineChangeHandler);
			item.addEventListener(ImAccordionItemView.READ_CHANGE,readChangeHandler);
			if(_gId == GroupType.RECENT) item.info.addEventListener(FriendEvent.NEW_RECENT,newRecentHandler)
			_tile.height = getDataLength(_itemValues)*(28+2);
			_tile.clearItems();
			_itemViewList.sort(compareFunction);
			for(var i:int =0;i<_itemViewList.length;i++)
			{
				_tile.appendItem(_itemViewList[i]);
			}
			dispatchEvent(new Event(ITEM_CHANGE));
		}
		
		private function titleClickHandler(evt:Event):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispatchEvent(new Event(SELECT_CHANGE));
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			_titleView.selected = _selected;
			if(_selected)
			{
				_tile.visible = true;
			}
			else
			{
				_tile.visible = false;
			}
		}
		
		override public function get height():Number
		{
			if(!_selected)return _titleView.height;
			return _titleView.height + _tile.height;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_titleView)
			{
				_titleView.dispose();
				_titleView = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_itemViewList)
			{
				for(var i:int =0;i<_itemViewList.length;i++)
				{
					_itemViewList[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
					_itemViewList[i].removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
					_itemViewList[i].removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
					_itemViewList[i].removeEventListener(FriendEvent.ONLINE_CHANGE,onlineChangeHandler);
					_itemViewList[i].removeEventListener(ImAccordionItemView.READ_CHANGE,readChangeHandler);
					if(_gId == GroupType.RECENT) _itemViewList[i].info.removeEventListener(FriendEvent.NEW_RECENT,newRecentHandler)
					_itemViewList[i].dispose();
				}
				_itemViewList = null;
			}
			_itemValues = null;
			_currentItem = null;
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}