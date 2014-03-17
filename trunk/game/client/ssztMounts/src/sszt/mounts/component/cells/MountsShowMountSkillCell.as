package sszt.mounts.component.cells
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseSkillCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class MountsShowMountSkillCell extends BaseSkillCell
	{
		private var _skillInfo:SkillItemInfo;
		
		public function MountsShowMountSkillCell()
		{
			super();
		}
		
		public function set skillInfo(skillInfo:SkillItemInfo):void
		{
			if(_skillInfo == skillInfo) return;
			_skillInfo = skillInfo;
			if(_skillInfo)
			{
				super.info = _skillInfo.getTemplate();
			}
			else
			{
				super.info = null;
			}
		}
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_skillInfo && _skillInfo.templateId > 0)
				TipsUtil.getInstance().show(_skillInfo as SkillItemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function getLayerType():String
		{
			return LayerType.SKILL_ICON + '_' + _skillInfo.level;
		}
		
		override public function dispose():void
		{
			_skillInfo = null;
			super.dispose();
		}
		
	}
}