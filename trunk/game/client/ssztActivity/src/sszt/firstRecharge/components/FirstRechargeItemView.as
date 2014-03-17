package sszt.firstRecharge.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.PngGotAsset;

	public class FirstRechargeItemView extends Sprite
	{
		private var _item:ItemTemplateInfo;
		private var cell:BigCell;
		
		public function FirstRechargeItemView(item:ItemTemplateInfo,itemNum:int)
		{
			_item = item;
			
			cell = new BigCell();
			cell.move(0,0);
			addChild(cell);
			
			initEvent();
			initData();
		}
		
		private function initEvent():void
		{
			
		}
		
		private function initData():void
		{
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _item.templateId;
			cell.itemInfo = itemInfo;
		}
		
		
		private function removeEvent():void
		{
			
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			cell = null;
		}

	}
}