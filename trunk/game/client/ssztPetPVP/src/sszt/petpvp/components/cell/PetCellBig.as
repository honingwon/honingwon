package sszt.petpvp.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	
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
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
//			if(!_iconShadow)
//			{
//				_iconShadow = new Bitmap(new IconShadowAsset());
//				_iconShadow.x = _iconShadow.y = 3;
//				addChild(_iconShadow);
//			}else{
//				setChildIndex(_iconShadow,numChildren-1);
//			}
		}
		
		override protected function getLayerType():String
		{
			return LayerType.PET_AVATAR_BIG;
		}
		
		override protected function createBg():void
		{
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
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