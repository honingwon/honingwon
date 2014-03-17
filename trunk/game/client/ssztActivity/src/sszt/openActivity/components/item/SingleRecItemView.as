package sszt.openActivity.components.item
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.utils.object_proxy;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.interfaces.panel.IPanel;
	import sszt.openActivity.components.BigCell;
	import sszt.openActivity.components.OpenActivityPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.activity.PngGotAsset;
	
	public class SingleRecItemView extends Sprite implements IPanel
	{
		/**
		 * 已领取 
		 */
		private var _getOver:Bitmap;
		/**
		 * 已过期 
		 */
		private var _overdue:MAssetLabel;
		/**
		 * 单笔充值 
		 */
		private var _singleValue:MAssetLabel;
		
		/**
		 * 赠送的礼包 
		 */		
		private var _bigCell:BigCell;
		
		/**
		 * 领取奖励 
		 */
		private var _getAwardBtn:MCacheAssetBtn1;
		
		private var _opActObj:OpenActivityTemplateListInfo;
		
		public function SingleRecItemView(opActObj:OpenActivityTemplateListInfo)
		{
			super();
			_opActObj = opActObj;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_overdue = new MAssetLabel("",[OpenActivityPanel.tfStyle]);
			_overdue.textColor = 0x777164;
			_overdue.move(48,150);
			addChild(_overdue);
			_overdue.setHtmlValue(LanguageManager.getWord("ssztl.activity.overTime"));
			
			_getOver = new Bitmap(new PngGotAsset(),"auto",true);
			_getOver.x = 23;
			_getOver.y = 132;
			_getOver.scaleX = _getOver.scaleY = 0.9;
			addChild(_getOver);
			
			_singleValue = new MAssetLabel("",[OpenActivityPanel.tfStyle]);
			_singleValue.move(50,15);
			addChild(_singleValue);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(23,77,50,50),new Bitmap(CellCaches.getCellBigBg())));
			_bigCell = new BigCell();
			_bigCell.move(23,77);
			addChild(_bigCell);
			
			_getAwardBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.getLabel"));
			_getAwardBtn.move(16,150);
			addChild(_getAwardBtn);
		}
		
		public function initEvent():void
		{
			_getAwardBtn.addEventListener(MouseEvent.CLICK,getSingleClick)
		}
		
		private function getSingleClick(evt:MouseEvent):void
		{
			OpenActivityGetAwardSocketHandler.send(_opActObj.id,_opActObj.group_id);
		}
		
		public function initData():void
		{
			
			_singleValue.setHtmlValue(LanguageManager.getWord("ssztl.activity.singlePayLabel") + "\n<font size='16' color='#ffcc00'>" + _opActObj.need_num.toString() + LanguageManager.getWord("ssztl.common.yuanBao") + "</font>");
			
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _opActObj.item;
			_bigCell.itemInfo = itemInfo;
			
			var obj:Object = GlobalData.openActivityInfo.activityDic[_opActObj.group_id];
			if(int(obj.totalValue) >= _opActObj.need_num)
			{
				_getAwardBtn.enabled = true;
			}
			else
			{
				_getAwardBtn.enabled = false;
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
//					_getOver.visible = true;
					_overdue.visible = false;
					_getAwardBtn.visible = true;
					_getAwardBtn.enabled = false;
					_getAwardBtn.label = LanguageManager.getWord("ssztl.common.notAchiveLabel");
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
			
		}
		
		public function removeEvent():void
		{
			_getAwardBtn.removeEventListener(MouseEvent.CLICK,getSingleClick)
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
			_singleValue = null;
			_bigCell = null;
			_getAwardBtn = null;
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