package sszt.task.components.container.accordionItems
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.accordionItems.AccordionGroupItemView;
	import sszt.ui.container.accordionItems.IAccordionItemData;
	
	import ssztui.ui.BarAsset3;
	
	public class TAccordionGroupItemView extends AccordionGroupItemView
	{
		public function TAccordionGroupItemView(info:IAccordionItemData, width:int, showItemSelectedBg:Boolean=true)
		{
			super(info, width, showItemSelectedBg);
		}
		
		override protected function init():void
		{
			buttonMode = true;
			
			if(_showItemSelectedBg)
			{
//				var _background:Shape = new Shape();
//				var matr:Matrix = new Matrix();
//				matr.createGradientBox(_width,_width,0,0,0);
//				_background.graphics.beginGradientFill(GradientType.LINEAR,[0x265d2b,0x265d2b],[1,0],[0,255],matr,SpreadMethod.PAD);
//				_background.graphics.drawRect(0,0,_width,20);
//				addChild(_background);
				
				_selectedBg = (BackgroundUtils.setBackground([
					new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0, 0, _width, 22),new BarAsset3())
				])) as DisplayObject;
				addChild(_selectedBg);
				_selectedBg.visible = false;
			}
			
			_accordionItem = _info.getAccordionItem(_width);
			_accordionItem.x = 22;
			_accordionItem.y = 3;
			addChild(_accordionItem);
		}
	}
}