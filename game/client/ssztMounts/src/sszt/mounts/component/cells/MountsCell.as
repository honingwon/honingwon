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
	
	public class MountsCell extends BaseCell
	{	
//		private var _typeLabel:TextField;
		private var _mountsInfo:MountsItemInfo;
		
		public function MountsCell()
		{
			super();
			init();
		}
		
		private function init():void
		{
//			_typeLabel = new TextField();
//			_typeLabel.textColor = 0xffffff;
//			_typeLabel.x = 10;
//			_typeLabel.y = 31;
//			_typeLabel.width = 40;
//			_typeLabel.height = 25;
//			_typeLabel.mouseEnabled = _typeLabel.mouseWheelEnabled = false;
//			_typeLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
//			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
//			_typeLabel.defaultTextFormat = t;
//			_typeLabel.setTextFormat(t);
		}
		

		public function set mountsInfo(value:MountsItemInfo):void
		{
			_mountsInfo = value;
			info = _mountsInfo.template;
//			if(value) _typeLabel.text = PetType.getTypeString(value.template.property1);
//			else _typeLabel.text = "";
		}
		
		public function get mountsInfo():MountsItemInfo
		{
			return _mountsInfo;
		}
		
		public function set mountsTemplateInfo(value:ItemTemplateInfo):void
		{
			info = value;
//			if(value) _typeLabel.text = PetType.getTypeString(value.property1);
//			else _typeLabel.text = "";
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