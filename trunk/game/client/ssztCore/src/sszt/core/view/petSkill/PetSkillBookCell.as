package sszt.core.view.petSkill
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.LayerType;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.tips.TipsUtil;
	
	import ssztui.ui.CellBigBgAsset;
	
	public class PetSkillBookCell extends BaseItemInfoCell
	{
		private var _skillBookInfo:SkillItemInfo;
		private var _border:Bitmap;
		
		public function PetSkillBookCell()
		{
			super();
			_border = new Bitmap(new CellBigBgAsset());
			addChild(_border);
		}
		
		public function set skillBookInfo(itemInfo:SkillItemInfo):void
		{
			if(itemInfo == skillBookInfo) return;
			_skillBookInfo = itemInfo;
			info = _skillBookInfo.getTemplate();
		}
		public function get skillBookInfo():SkillItemInfo
		{
			return _skillBookInfo;
		}
		
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3, 3, 44, 44);
		}
		
		override protected function getLayerType():String
		{
			return LayerType.SKILL_ICON + '_' + _skillBookInfo.level;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(_skillBookInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			_skillBookInfo = null;
			super.dispose();
		}
	}
}