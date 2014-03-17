package sszt.core.view.cell
{
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;

	public class BaseBigCell extends BaseCell
	{
		public function BaseBigCell()
		{
			super();
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,44,44);
		}
		
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
	}
}