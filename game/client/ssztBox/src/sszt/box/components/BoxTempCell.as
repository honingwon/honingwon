package sszt.box.components
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class BoxTempCell extends BaseCell
	{
		public function BoxTempCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
			{
				TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		
	}
}