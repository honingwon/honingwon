package sszt.mounts.component.cells
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DragActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.ui.label.MAssetLabel;
	
	public class MountsCell1 extends BaseCell
	{	
		private var _mountsInfo:MountsItemInfo;
		
		public function MountsCell1()
		{
			super();
			init();
		}
		
		private function init():void
		{
		}
		

		public function set mountsInfo(value:MountsItemInfo):void
		{
			_mountsInfo = value;
			info = _mountsInfo.template;
		}
		
		public function get mountsInfo():MountsItemInfo
		{
			return _mountsInfo;
		}
		
		public function set mountsTemplateInfo(value:ItemTemplateInfo):void
		{
			info = value;
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
//			addChild(_typeLabel);
//			if(_mountsInfo) _pic.filters = [CategoryType.getGlowByQuality(_mountsInfo.template.quality)];
//			else if(info) _pic.filters = [CategoryType.getGlowByQuality((info as ItemTemplateInfo).quality)];
//			else _pic.filters = null;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_mountsInfo) TipsUtil.getInstance().show(_mountsInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
			else TipsUtil.getInstance().show(info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height),false,0,false);
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
//			_typeLabel = null;
			_mountsInfo = null;
			super.dispose();
		}
	}
}