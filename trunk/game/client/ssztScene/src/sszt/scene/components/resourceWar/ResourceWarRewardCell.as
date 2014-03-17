package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.ui.CellBigBgAsset;
	
	public class ResourceWarRewardCell extends BaseCell
	{
		private var _selected:Boolean;
		
		public function ResourceWarRewardCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
//		override protected function getLayerType():String
//		{
//			return LayerType.STORE_ICON;
//		}
//		
//		override protected function initFigureBound():void
//		{
//			_figureBound = new Rectangle(3,3,44,44);
//		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
	}
}