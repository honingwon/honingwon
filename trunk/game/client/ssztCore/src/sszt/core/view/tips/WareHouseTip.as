package sszt.core.view.tips
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.drag.IDragable;

	public class WareHouseTip extends BaseMenuTip
	{
		private var place:int;
		private var cell:IDragable;
		private static var instance:WareHouseTip;
		private var _timeoutIndex:int =-1;
		
		public function WareHouseTip()
		{
			super();
		}
		
		public static function getInstance():WareHouseTip
		{
			if(instance == null)
			{
				instance = new WareHouseTip();
			}
			return instance;
		}
		
		public function show(cell:IDragable,pos:Point):void
		{
			this.cell = cell;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:WareHouseTip = this;
			function showHandler():void
			{
				setLabels([LanguageManager.getWord("ssztl.common.putInBag")],[1]);
				setPos(pos);
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
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			switch (item.id)
			{
				case 1:
					var toPlace:int = GlobalData.bagInfo.getEmptyPlace();
					var itemInfo:ItemInfo = cell.getSourceData() as ItemInfo;
					if(itemInfo == null) return;
					if(toPlace == -1)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
						return ;
					}
					ItemMoveSocketHandler.sendItemMove(CommonBagType.WAREHOUSE,itemInfo.place,CommonBagType.BAG,toPlace,itemInfo.count);
					break;
			}
		}
		
	}
}