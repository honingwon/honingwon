package sszt.personal.components.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	
	public class PersonalLuckyItemView extends BaseCell
	{
		public function PersonalLuckyItemView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			this.filters = [new GlowFilter(0xFFFFFF,1,4,4,4,1)];
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_info)
			{
				TipsUtil.getInstance().show(ItemTemplateInfo(_info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_info)TipsUtil.getInstance().hide();
		}
	}
}