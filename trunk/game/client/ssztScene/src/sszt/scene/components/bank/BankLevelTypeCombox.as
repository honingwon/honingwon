package sszt.scene.components.bank
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.scene.components.bank.bankTabPanel.BankLevelTabPanel;
	import sszt.scene.data.bank.BankInfo;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	
	public class BankLevelTypeCombox extends Sprite
	{
		private const CELL_MAX:int = 6;		
		private var _tile:MTile;
		
		private var _labelList:Array;
		private var _currentLabel:MAssetLabel;
		private var _tipsLabel:MAssetLabel;
		
		public function BankLevelTypeCombox()
		{
			super();
			_labelList = [];
			initView();
		}
		
		private function initView():void
		{
			_tile = new MTile(50,25);
			_tile.setSize(50,150);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
//			_tile.verticalScrollBar.lineScrollSize = 25;	
			_tile.itemGapH = _tile.itemGapW = 0;
			addChild(_tile);
			var label:MAssetLabel;
			for(var i:int = 0; i < CELL_MAX; i++)
			{
				label = new MAssetLabel(BankInfo.MONEY[i+1].toString(),MAssetLabel.LABEL_TYPE22);
				_tile.appendItem(label);
				_labelList.push(label);
				label.mouseEnabled = true;
				label.backgroundColor = 0xffffff;
//				label.setSize();
//				label.buttonMode = true;
				label.addEventListener(MouseEvent.CLICK, onMouseClick);
				label.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			}
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			var label:MAssetLabel = event.currentTarget as MAssetLabel;
			BankLevelTabPanel(parent).type = _labelList.indexOf(label)+1;
			this.visible = false;
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			var label:MAssetLabel = event.currentTarget as MAssetLabel;
//			label.selected = false;
			_currentLabel = label;
		}
		
		public function clear():void
		{
//			_currentPetCell.selected = false;
			for(var i:int = 0; i < _labelList.length; i++)
			{
				var label:MAssetLabel = _labelList[i];
				label.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				label.removeEventListener(MouseEvent.CLICK, onMouseClick)
			}
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			clear();
			_labelList = null;
		}
	}
}