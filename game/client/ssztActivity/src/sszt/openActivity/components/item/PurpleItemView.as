package sszt.openActivity.components.item
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.openActivity.components.BigCell;
	import sszt.openActivity.components.Cell;
	import sszt.openActivity.components.OpenActivityPanel;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	import ssztui.activity.PngGotAsset;

	public class PurpleItemView extends Sprite
	{
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		/**
		 * 已领取 
		 */
		private var _getOver:Bitmap;
		/**
		 * 已过期 
		 */
		private var _overdue:MAssetLabel;
		
		/**
		 * 帮助礼包:（成员礼包） 
		 */
		private var _tag:MAssetLabel;
		
		/**
		 * 赠送的礼包 
		 */		
		private var _cell:BigCell;
		
		/**
		 * 领取奖励 
		 */
		private var _getAwardBtn:MCacheAssetBtn1;
		
		private var _opActObj:OpenActivityTemplateListInfo;
		private var _bg:IMovieWrapper;
		
		public function PurpleItemView(opActObj:OpenActivityTemplateListInfo)
		{
			super();
			_opActObj = opActObj;
			initView();
			initEvent();
			initData();
		}
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,394,60)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(77,5,2,50),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(87,5,50,50),new Bitmap(CellCaches.getCellBigBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_cell = new BigCell();
			_cell.move(87,5);
			addChild(_cell);
			
			_tag = new MAssetLabel("",[OpenActivityPanel.tfStyle]);
			_tag.textColor = 0x48ff00;
			_tag.move(38,21);
			addChild(_tag);
			
			_itemList = [];
			_itemTile = new MTile(38,38,6);
			_itemTile.setSize(240,38);
			_itemTile.move(140,11);
			_itemTile.itemGapW = 1;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			_getOver = new Bitmap(new PngGotAsset(),"auto",true);
			_getOver.x = 330;
			_getOver.y = 10;
			_getOver.scaleX = _getOver.scaleY = 0.9;
			addChild(_getOver);
			
			_overdue = new MAssetLabel("",[OpenActivityPanel.tfStyle]);
			_overdue.textColor = 0x777164;
			_overdue.move(352,20);
			addChild(_overdue);
			_overdue.setHtmlValue(LanguageManager.getWord("ssztl.activity.overTime"));
			
			_getAwardBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.getLabel"));
			_getAwardBtn.move(322,17);
			addChild(_getAwardBtn);
			
		}
		public function initEvent():void
		{
			_getAwardBtn.addEventListener(MouseEvent.CLICK,getMakeVipClick)
		}
		public function removeEvent():void
		{
			_getAwardBtn.removeEventListener(MouseEvent.CLICK,getMakeVipClick)
		}
		
		private function getMakeVipClick(evt:MouseEvent):void
		{
			OpenActivityGetAwardSocketHandler.send(_opActObj.id,_opActObj.group_id);
		}
		public function initData():void
		{
			//赠送礼包
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _opActObj.item;
			_cell.itemInfo = itemInfo;
			
			var bigItem:ItemTemplateInfo = ItemTemplateList.getTemplate(_opActObj.item);
			//礼包里赠送的物品
			var i:int = 0
			var itemArray:Array = []; //物品模板id数组
			var itemNumArray:Array = []; //物品数量数组
			var scriptArray:Array = bigItem.script.split("|"); 
			var scriptStr:String = "";
			var scriptStrArray:Array = [];
			for(;i<scriptArray.length;i++)
			{
				scriptStrArray = scriptArray[i].toString().split(",");
				if(scriptStrArray.length >= 6)
				{
					itemArray.push(scriptStrArray[2]);
					itemNumArray.push(scriptStrArray[3]);
				}
			}
			i = 0; 
			var item:Cell;
			for(; i<itemArray.length; i++)
			{
				item = new Cell();
				itemInfo = new ItemInfo();
				itemInfo.templateId = itemArray[i];
				itemInfo.count = itemNumArray[i];
				item.itemInfo = itemInfo;
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
			
		}
		/**
		 * 0:不可领  1:可领取 2:已领 3：已经过期
		 */
		public function setType(value:int):void
		{
			switch(value)
			{
				case 0:
					_getOver.visible = false;
					_overdue.visible = false;
					_getAwardBtn.visible = true;
					_getAwardBtn.enabled = false;
					_getAwardBtn.label = LanguageManager.getWord("ssztl.common.notAchiveLabel");
					break;
				case 1:
					_getOver.visible = false;
					_overdue.visible = false;
					_getAwardBtn.visible = true;
					_getAwardBtn.enabled = true;
					_getAwardBtn.label = LanguageManager.getWord("ssztl.common.getLabel");
					break;
				case 2:
					_getOver.visible = true;
					_overdue.visible = false;
					_getAwardBtn.visible = false;
					break;
				case 3:
					_getOver.visible = false;
					_overdue.visible = true;
					_getAwardBtn.visible = false;
					break;
			}
		}
		public function clearData():void
		{
			var i:int = 0;
			if (_itemList)
			{
				while (i < _itemList.length)
				{
					
					_itemList[i].dispose();
					i++;
				}
				_itemList = [];
			}
			if(_itemTile)
			{
				_itemTile.clearItems();
			}
			_cell.dispose();
		}
		public function setTag(str:String,n:int):void
		{
			_tag.setHtmlValue(str);
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function dispose():void
		{
			clearData();
			removeEvent();
			opAct = null;
			_itemTile = null;
			_itemList = null;
			_cell = null;
		}
		public function get opActObj():OpenActivityTemplateListInfo
		{
			return _opActObj;
		}
		
		public function set opActObj(value:OpenActivityTemplateListInfo):void
		{
			_opActObj = value;
		}
		
	}
}