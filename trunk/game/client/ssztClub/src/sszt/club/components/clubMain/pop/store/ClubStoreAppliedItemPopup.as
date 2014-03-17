package sszt.club.components.clubMain.pop.store
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.club.socketHandlers.ClubStoreApplyforItemSocketHandler;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.BaseMenuTip;
	import sszt.core.view.tips.MenuItem;
	import sszt.interfaces.drag.IDragable;
	
	public class ClubStoreAppliedItemPopup extends BaseMenuTip
	{
		private static var instance:ClubStoreAppliedItemPopup;
		private var cell:IDragable;
		private var _timeoutIndex:int = -1;
		private var _itemInfo:ItemInfo;
		
		public function ClubStoreAppliedItemPopup()
		{
			super();
		}
		
		public static function getInstance():ClubStoreAppliedItemPopup
		{
			if(instance == null)
			{
				instance = new ClubStoreAppliedItemPopup();
			}
			return instance
		}
		
		public function show(cell:IDragable,pos:Point):void
		{
			this.cell = cell;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:ClubStoreAppliedItemPopup = this;
			function showHandler():void
			{
				var tmpLabels:Array = [
					LanguageManager.getWord("ssztl.club.applyforItem")
				];
				var tmpIds:Array = [1];
				_itemInfo = cell.getSourceData() as ItemInfo;
				setLabels(tmpLabels,tmpIds);
				setPos(pos);
				setSpecial();
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function setPos(pos:Point):void
		{
			if(_bg.height + pos.y > CommonConfig.GAME_HEIGHT)
				this.y =  pos.y - _bg.height;
			else
				this.y = pos.y;
			if(_bg.width + pos.x >CommonConfig.GAME_WIDTH)
				this.x = pos.x - _bg.width;
			else
				this.x = pos.x;	
		}
		
		private function setSpecial():void
		{
			for each(var i:MenuItem in _menus)
			{
				if(i.id == 6) i.color = 0x00ff00;
			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_DOWN,keyIsDownHandler);
		}
		
		private function keyIsDownHandler(evt:KeyboardEvent):void
		{
			dispose();
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			switch (item.id)
			{
				case 1:
					ClubStoreApplyforItemSocketHandler.send(_itemInfo.itemId);
					break;
			}
		}
	}
}