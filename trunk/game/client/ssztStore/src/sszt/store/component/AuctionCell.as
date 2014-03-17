package sszt.store.component
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.LayerType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class AuctionCell extends BaseCell
	{
		private var _countLabel:TextField;
		
		public function AuctionCell()
		{
			super();
			_countLabel = new TextField();
			_countLabel.x = 20;
			_countLabel.y = 29;
			_countLabel.width = 25;
			_countLabel.height = 25;
			_countLabel.mouseEnabled = _countLabel.mouseWheelEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.defaultTextFormat = t;
			_countLabel.setTextFormat(t);
			addChild(_countLabel);
		}
		
		public function set count(value:int):void
		{
			if(value == 0) _countLabel.text = "";
			else _countLabel.text = String(value);	
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(2,2,44,44);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
			setChildIndex(_countLabel,numChildren - 1);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
				TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
	}
}