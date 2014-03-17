package sszt.club.components.clubMain.pop.lottery
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class ClubLotteryCell extends BaseCell
	{
		private var _selected:Boolean;
		
		public function ClubLotteryCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.STORE_ICON;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,44,44);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function set selected(value:Boolean):void
		{
			if(value == _selected) return;
			_selected = value;
			if(value)
			{
				graphics.beginFill(0xff0000,0.8);
				graphics.drawRect(0,0,50,50);
				graphics.endFill();
			}
			else
			{
				graphics.clear();
			}
		}
	}
}