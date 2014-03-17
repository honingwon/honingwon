package sszt.core.view.cell
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class BaseSkillCell extends BaseCell
	{
		public function BaseSkillCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		public function get skillTemplate():SkillTemplateInfo
		{
			return _info as SkillTemplateInfo;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_info)TipsUtil.getInstance().show(_info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_info)TipsUtil.getInstance().hide();
		}
		
		override protected function getLayerType():String
		{
			return LayerType.SKILL_ICON;
		}
	}
}