package sszt.openActivity.components.item
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.interfaces.panel.IPanel;
	import sszt.openActivity.components.BigCell;
	import sszt.openActivity.components.Cell;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	/**
	 * 帮会升级Item 
	 * @author chendong
	 * 
	 */	
	public class ClubItemView extends Sprite implements IPanel
	{
		private var _type:int = -1; //0:"帮主礼包"，1："成员礼包"
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		/**
		 * 赠送的礼包 
		 */		
		private var _bigCell:BigCell;
		
		/**
		 * 帮助礼包:（成员礼包） 
		 */
		private var _desInfo:MAssetLabel;
		
		/**
		 * 领取奖励 
		 */
		private var _getAwardBtn:MCacheAssetBtn1;
		
		
		private var _opActObj:OpenActivityTemplateListInfo;
		
		public function ClubItemView(opActObj:OpenActivityTemplateListInfo)
		{
			super();
			_opActObj = opActObj;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bigCell = new BigCell();
			_bigCell.move(0,0);
			addChild(_bigCell);
			
			_desInfo = new MAssetLabel("",MAssetLabel.LABELTYPE14,TextFormatAlign.LEFT);
			_desInfo.move(0,0);
			addChild(_desInfo);
			
			_itemList = [];
			_itemTile = new MTile(63,112,6);
			_itemTile.setSize(378,112);
			_itemTile.move(0,0);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			_getAwardBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.getLabel"));
			_getAwardBtn.move(0,0);
			addChild(_getAwardBtn);
		}
		
		public function initEvent():void
		{
			_getAwardBtn.addEventListener(MouseEvent.CLICK,getClubClick)
		}
		
		private function getClubClick(evt:MouseEvent):void
		{
			OpenActivityGetAwardSocketHandler.send(_opActObj.id,_opActObj.group_id);
		}
		
		public function initData():void
		{
			//赠送礼包
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _opActObj.item;
			_bigCell.itemInfo = itemInfo;
			
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
			_bigCell.dispose();
		}
		
		public function removeEvent():void
		{
			_getAwardBtn.removeEventListener(MouseEvent.CLICK,getClubClick)
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
			_bigCell = null;
		}
	}
}