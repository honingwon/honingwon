package sszt.role.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import sszt.core.view.cell.BaseCell;
	
	import ssztui.role.CellBorderAsset;

	public class ExchangeCell extends BaseCell
	{
		private var _border:Bitmap;
		public function ExchangeCell()
		{
			super();
			initView();
		}
		private function initView():void
		{
			_border = new Bitmap(new CellBorderAsset());
			addChild(_border);
		}
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(1,1,24,24);
		}
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setChildIndex(_border,numChildren-1);
		}
		override public function dispose():void
		{
			super.dispose();
			if(_border && _border.bitmapData)
			{
				_border.bitmapData.dispose();
				_border = null;
			}
		}
	}
}