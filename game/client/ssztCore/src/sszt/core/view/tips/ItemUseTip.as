package sszt.core.view.tips
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToConsignData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.bag.ItemScoreSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.patchUse.BatchUsePanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.events.ChatModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.module.ModuleEventDispatcher;

	public class ItemUseTip extends BaseMenuTip
	{
		private var place:int;
		private var cell:IDragable;
		private var itemInfo:ItemInfo;
		private static var instance:ItemUseTip;
		private var _timeoutIndex:int = -1;
		
		public function ItemUseTip()
		{
			super();
		}
		
		public static function getInstance():ItemUseTip
		{
			if(instance == null)
			{
				instance = new ItemUseTip();
			}
			return instance;
		}
		
		public function show(cell:IDragable,pos:Point):void
		{
			this.cell = cell;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:ItemUseTip = this;
			function showHandler():void
			{
//				var tmpLabels:Array = ["使用","丢弃","寄售","加锁","展示"];
				var tmpLabels:Array = [
					LanguageManager.getWord("ssztl.common.use"),
					LanguageManager.getWord("ssztl.bag.drop"),
					LanguageManager.getWord("ssztl.common.consign"),
//					LanguageManager.getWord("ssztl.bag.addLock"),
					LanguageManager.getWord("ssztl.common.show")];
				var tmpIds:Array = [1,2,3,5];
				itemInfo = cell.getSourceData() as ItemInfo;
				if(itemInfo.template.canRecycle)
				{
//					tmpLabels.push(LanguageManager.getWord("ssztl.common.split"));
//					tmpIds.push(6);
				}
				if(CategoryType.isBatchUseItem(itemInfo.template.categoryId))
				{
					tmpLabels.push(LanguageManager.getWord("ssztl.common.multiUse"));
					tmpIds.push(7);
				}
				if(CategoryType.isEquip(itemInfo.template.categoryId) && itemInfo.score == 0)
				{
					tmpLabels.push(LanguageManager.getWord("ssztl.rank.equipScore"));
					tmpIds.push(8);
				}
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
		
		private function setSpecial():void
		{
			for each(var i:MenuItem in _menus)
			{
				if(i.id == 6) i.color = 0x00ff00;
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
					ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,cell));
					break;
				case 2:
					if(!itemInfo.template.canDestory)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDrop"));
						return ;
					}
					MAlert.show(LanguageManager.getWord("ssztl.common.isSureDrop"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,alertHandler);
					break;
				case 3:
					SetModuleUtils.addConsign(new ToConsignData(2,itemInfo.place));
					break;
				case 4:
					break;
				case 5:
					ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_ITEM,itemInfo));
					break;
				case 6:
					SetModuleUtils.addFurnace(1,itemInfo.itemId);
					break;
				case 7:
					BatchUsePanel.getInstance().show(itemInfo);
					break;
				case 8:
					ItemScoreSocketHandler.send(itemInfo.place);
					break;
			}
		}
		
		private function alertHandler(evt:CloseEvent):void
		{
//			var item:ItemInfo = cell.getSourceData() as ItemInfo;
			if(evt.detail == MAlert.OK)
			{
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG,itemInfo.place,CommonBagType.BAG,-1,itemInfo.count);
			}
		}
	}
}