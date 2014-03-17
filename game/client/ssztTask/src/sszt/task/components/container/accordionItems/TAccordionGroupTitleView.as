package sszt.task.components.container.accordionItems
{
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.ui.container.accordionItems.AccordionGroupTitleView;
	
	import ssztui.ui.TreeIconAddAsset;
	import ssztui.ui.TreeIconLowAsset;
	
	
	public class TAccordionGroupTitleView extends AccordionGroupTitleView
	{
		public function TAccordionGroupTitleView(title:String, width:int, showBg:Boolean=true)
		{
			super(title, width, showBg);
		}
		
		override protected function init():void
		{
			buttonMode = true;
//			if(_showBg)
//			{
//				_bg = new BarAsset1();
//				addChild(_bg);
//				_bg.width = _width;
//				_bg.tabEnabled = false;
//			}
			_selectedIcon = new Bitmap(new TreeIconLowAsset());
			_selectedIcon.x = 3;
			_selectedIcon.y = 2;
			addChild(_selectedIcon);
			_unselectedIcon = new Bitmap(new TreeIconAddAsset());
			_unselectedIcon.x = 3;
			_unselectedIcon.y = 2;
			addChild(_unselectedIcon);
			_selectedIcon.visible = false;
			
			_titleField = new TextField();
			_titleField.width = _width - 18;
			_titleField.height = 21;
			_titleField.mouseEnabled = false;
			_titleField.x = 22;
			_titleField.y = 1;
			_titleField.text = _title;
			_titleField.textColor = 0xdb921e;
			addChild(_titleField);
		}
	}
}