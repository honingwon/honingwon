package sszt.core.view
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class MayaCopyEntranceViewCell extends BaseCell
	{
		private var _countLabel:TextField;
		private var _count:int;
		public function MayaCopyEntranceViewCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			
			_countLabel = new TextField();
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.defaultTextFormat = t;
			_countLabel.setTextFormat(t);
			_countLabel.x = 4;
			_countLabel.y = 22;
			_countLabel.width = 33;
			_countLabel.height = 14;
			_countLabel.mouseEnabled = _countLabel.mouseWheelEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
		}
		
		public function set count(value:int):void
		{
			_count = value;
			_countLabel.text  = "1/" + value;
		}
		
		override protected function createPicComplete(data:BitmapData):void
		{
			super.createPicComplete(data);
			addChild(_countLabel);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_countLabel = null;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
				TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
	}
}