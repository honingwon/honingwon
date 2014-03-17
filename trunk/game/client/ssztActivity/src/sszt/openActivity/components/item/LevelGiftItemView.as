package sszt.openActivity.components.item
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.openActivity.components.BigCell;
	import sszt.openActivity.components.OpenActivityPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.activity.PngGotAsset;

	public class LevelGiftItemView extends Sprite
	{
		private var _levelTxt:MAssetLabel;
		/**
		 * 已领取 
		 */
		private var _getOver:Bitmap;
		/**
		 * 已过期 
		 */
		private var _overdue:MAssetLabel;
		private var _getBtn:MCacheAssetBtn1;
		
		
		private var _opActObj:OpenActivityTemplateListInfo;
		private var cell:BigCell;
		
		public function LevelGiftItemView(opActObj:OpenActivityTemplateListInfo)
		{
			_opActObj = opActObj;
			
			_levelTxt = new MAssetLabel("",[OpenActivityPanel.tfStyle]);
			_levelTxt.move(50,10);
			addChild(_levelTxt);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(23,62,50,50),new Bitmap(CellCaches.getCellBigBg())));
			cell = new BigCell();
			cell.move(23,62);
			addChild(cell);
			
			_getOver = new Bitmap(new PngGotAsset(),"auto",true);
			_getOver.x = 23;
			_getOver.y = 112;
			_getOver.scaleX = _getOver.scaleY = 0.9;
			addChild(_getOver);
			
			_overdue = new MAssetLabel("",[OpenActivityPanel.tfStyle]);
			_overdue.textColor = 0x777164;
			_overdue.move(48,130);
			addChild(_overdue);
			_overdue.setHtmlValue(LanguageManager.getWord("ssztl.activity.overTime"));
			
			_getBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.getLabel"));
			_getBtn.move(16,130);
			addChild(_getBtn);
			
			initEvent();
			initData();
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
					_getBtn.visible = true;
					_getBtn.enabled = false;
					_getBtn.label = LanguageManager.getWord("ssztl.common.notAchiveLabel");
					break;
				case 1:
					_getOver.visible = false;
					_overdue.visible = false;
					_getBtn.visible = true;
					_getBtn.enabled = true;
					_getBtn.label = LanguageManager.getWord("ssztl.common.getLabel");
					break;
				case 2:
					_getOver.visible = true;
					_overdue.visible = false;
					_getBtn.visible = false;
					break;
				case 3:
					_getOver.visible = false;
					_overdue.visible = true;
					_getBtn.visible = false;
					break;
			}
		}
		
		private function initEvent():void
		{
			_getBtn.addEventListener(MouseEvent.CLICK,clickHandlerLevel);
		}
		
		private function initData():void
		{
			_levelTxt.setHtmlValue(LanguageManager.getWord("ssztl.activity.levelingLabel2",_opActObj.start_time) + "\n<font size='16' color='#ffcc00'>" + _opActObj.need_num + LanguageManager.getWord("ssztl.common.levelLabel") + "</font>");
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _opActObj.item;
			cell.itemInfo = itemInfo;
		}
		
		
		public function clickHandlerLevel(e:MouseEvent):void
		{
			OpenActivityGetAwardSocketHandler.send(_opActObj.id,_opActObj.group_id);
		}
		
		
		private function removeEvent():void
		{
			_getBtn.removeEventListener(MouseEvent.CLICK,clickHandlerLevel);
		}
		
		
		public function dispose():void
		{
			removeEvent();
			if(_getOver && _getOver.bitmapData)
			{
				_getOver.bitmapData.dispose();
				_getOver = null;
			}
			if(_getBtn)
			{
				_getBtn.dispose();
				_getBtn = null;
			}
			_levelTxt = null;
			cell = null;
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