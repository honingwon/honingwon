package sszt.openActivity.components.item
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.core.view.tips.TipsUtil;
	import sszt.openActivity.components.BigCell;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.activity.PngGotAsset;

	public class ChestItemView extends Sprite
	{
//		private var _btnChest:MAssetButton1;
		private var _getOver:Bitmap;
		
		private var _needNum:MAssetLabel;
		
		private var _opActObj:OpenActivityTemplateListInfo;
		private var cell:BigCell;
		private var _getBtn:MCacheAssetBtn1;
		
		public function ChestItemView(opActObj:OpenActivityTemplateListInfo)
		{
			_opActObj = opActObj;
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,85,117);
			graphics.endFill();
			buttonMode = true;
			
//			_btnChest = new MAssetButton1(new BtnTreasureAsset() as MovieClip);
//			_btnChest.move(-20,16);
//			addChild(_btnChest);
			
			_needNum = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_needNum.textColor = 0xfffac1;
			_needNum.move(42,8);
			addChild(_needNum);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(17,29,50,50),new Bitmap(CellCaches.getCellBigBg())));
			cell = new BigCell();
			cell.move(17,29);
			addChild(cell);
//			cell.mouseEnabled = cell.mouseChildren = false;
			
			_getBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.getLabel"));
			_getBtn.move(15,82);
			addChild(_getBtn);
			
			_getOver = new Bitmap(new PngGotAsset(),"auto",true);
			_getOver.x = 18;
			_getOver.y = 70;
			_getOver.scaleX = _getOver.scaleY = 0.9;
			addChild(_getOver);
			_getOver.visible = false;
			
			initEvent();
			initData();
		}
		/**
		 * 0:不可领  1:可领取 2:已领
		 */
		public function setType(value:int):void
		{
			switch(value)
			{
				case 0:
//					_btnChest.enabled = false;
					_getOver.visible = false;
					_getBtn.enabled = false;
					break;
				case 1:
//					_btnChest.enabled = true;
					_getOver.visible = false;
					_getBtn.enabled = true;
					break;
				case 2:
//					_btnChest.enabled = false;
					_getOver.visible = true;
					_getBtn.visible = false;
					break;
			}
		}
		private function initEvent():void
		{
//			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
//			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_getBtn.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function initData():void
		{
			_needNum.setValue(_opActObj.need_num + LanguageManager.getWord("ssztl.common.yuanBao"));
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _opActObj.item;
			cell.itemInfo = itemInfo;
		}
		
		private function removeEvent():void
		{
//			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
//			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_getBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			var str:String = "<font size='14' color='#3399ff'><b>累积充值奖励·壹</b></font>\n" +
							 "<font color='#4bbf0b'>可获得：50级史诗装备箱×1、3级宝石箱×2、坐骑还魂丹×30</font>\n" +
							 "<font color='#ff6600'>点击领取</font>　<font color='#b09a80'>已领取</font>"
			TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function clickHandler(e:MouseEvent):void
		{
			OpenActivityGetAwardSocketHandler.send(_opActObj.id,_opActObj.group_id);
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			this.graphics.clear();
//			if(_btnChest)
//			{
//				_btnChest.dispose();
//				_btnChest = null;
//			}
			if(_getOver && _getOver.bitmapData)
			{
				_getOver.bitmapData.dispose();
				_getOver = null;
			}
			
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