package sszt.mounts.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsListUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mounts.component.items.MountsItemView;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	public class MountsLeftPanel extends Sprite
	{
		private var _mediator:MountsMediator;
		private var _countLabel:MAssetLabel;
		private var _list:Array;
		private var _tile:MTile;
		private var _bg:IMovieWrapper;
		public var currentItem:MountsItemView;
		public static const SELECT_CHANGE:String = "selectChange";
		
		public function MountsLeftPanel(mediator:MountsMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_countLabel.textColor = 0x726d61;
			_countLabel.move(70,358);
			addChild(_countLabel);
			_countLabel.setHtmlValue(LanguageManager.getWord("ssztl.mounts.keyTip"));
			
			_tile = new MTile(141,70);
			_tile.setSize(141,350);
			_tile.itemGapH = _tile.itemGapW = 0;
			addChild(_tile);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			_list = [];
			var list:Array = GlobalData.mountsList.getList();
			for each(var i:MountsItemInfo in list)
			{
				var itemView:MountsItemView = new MountsItemView(i);
				_tile.appendItem(itemView);
				_list.push(itemView);
				itemView.addEventListener(MouseEvent.CLICK,clickHandler);
			}
//			_countLabel.setValue(_list.length + "/3");
			if(_list.length > 0)
			{
				for each(var j:MountsItemView in _list)
				{
					if(j.mountsInfo.state == 1)
					{
						currentItem = j;
						j.selected = true;
					}
				}
				if(currentItem == null)
				{
					currentItem = _list[0];
					currentItem.selected = true;
				}
			}
			initEvent();
		}
		
		private function initEvent():void
		{
			GlobalData.mountsList.addEventListener(MountsListUpdateEvent.ADD_MOUNTS,addPetHandler);
			GlobalData.mountsList.addEventListener(MountsListUpdateEvent.REMOVE_MOUNTS,removePetHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.mountsList.removeEventListener(MountsListUpdateEvent.ADD_MOUNTS,addPetHandler);
			GlobalData.mountsList.removeEventListener(MountsListUpdateEvent.REMOVE_MOUNTS,removePetHandler);
		}
		
		private function addPetHandler(evt:MountsListUpdateEvent):void
		{
			var mountsInfo:MountsItemInfo = evt.data as MountsItemInfo;
			var itemView:MountsItemView = new MountsItemView(mountsInfo);
			_list.push(itemView);
			_tile.appendItem(itemView);
			itemView.addEventListener(MouseEvent.CLICK,clickHandler);
			if(currentItem) currentItem.selected = false;
			currentItem = itemView;
			currentItem.selected = true;
			dispatchEvent(new Event(SELECT_CHANGE));
//			_countLabel.setValue(GlobalData.mountsList.mountsCount + "/3");
		}
		
		private function removePetHandler(evt:MountsListUpdateEvent):void
		{
			var mountsInfo:MountsItemInfo = evt.data as MountsItemInfo;
			var itemView:MountsItemView;
			for(var i:int = 0;i<_list.length;i++)
			{
				if(_list[i].mountsInfo == mountsInfo)
				{
					itemView = _list.splice(i,1)[0];
					if(itemView == currentItem)
					{
						currentItem.selected = false;
						currentItem = null;
						if(_list[0])
						{
							currentItem = _list[0];
							currentItem.selected = true;
						}
					}
					_tile.removeItem(itemView);
					itemView.dispose();
					break;
				}
			}
//			_countLabel.setValue(GlobalData.mountsList.mountsCount + "/3");
			dispatchEvent(new Event(SELECT_CHANGE));
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var item:MountsItemView = evt.currentTarget as MountsItemView;
			if(currentItem == item) return;
			if(currentItem) currentItem.selected = false;
			currentItem = item;
			currentItem.selected = true;
			dispatchEvent(new Event(SELECT_CHANGE));
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			
			for each(var i:MountsItemView in _list)
			{
				i.addEventListener(MouseEvent.CLICK,clickHandler);
			}
			
			_mediator = null;
			_countLabel = null;
			if(_tile)
			{
				_tile.disposeItems();
				_tile = null;
			}
			_list = null;
			currentItem = null;
			if(parent) parent.removeChild(this);
		}
	}
}