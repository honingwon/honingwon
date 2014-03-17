package sszt.mounts.component.cells
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.pet.IconShadowAsset;
	
	public class PetCellBig extends PetCell
	{
		private var _iconShadow:Bitmap;
		
		public function PetCellBig()
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
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
			if(!_iconShadow)
			{
				_iconShadow = new Bitmap(new IconShadowAsset());
				_iconShadow.x = _iconShadow.y = 3;
				addChild(_iconShadow);
			}else{
				setChildIndex(_iconShadow,numChildren-1);
			}
		}
		
		override protected function createBg():void
		{
			return;
		}
		override public function dispose():void
		{
			if(_iconShadow && _iconShadow.bitmapData)
			{
				_iconShadow.bitmapData.dispose();
				_iconShadow = null;
			}
			super.dispose();
		}
		
	}
}