package sszt.yellowBox.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class YellowBoxItemView extends Sprite implements IPanel
	{
		
		private var _cell:BigCell;
		private var _namelable:MAssetLabel;
		
		private var _itemObj:Object;
		
		public function YellowBoxItemView(obj:Object)
		{
			super();
			_itemObj = obj;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,0,50,50),new Bitmap(CellCaches.getCellBigBg())));
			
			_cell = new BigCell();
			_cell.move(0,0);
			addChild(_cell);
			
			_namelable = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_namelable.textColor = 0xff9900;
			_namelable.move(0,14);
//			addChild(_namelable);
		}
		
		public function initEvent():void
		{
			
		}
		
		public function initData():void
		{
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _itemObj.templateId;
			itemInfo.count = _itemObj.count;
			_cell.itemInfo = itemInfo;
			_namelable.text = itemInfo.template.name;
		}
		
		public function clearData():void
		{
			
		}
		
		public function removeEvent():void
		{
		}
		
		public function move(x:Number, y:Number):void
		{
		}
		
		public function dispose():void
		{
			removeEvent();
			_cell = null;
			_namelable = null;
			_itemObj = null;
		}
	}
}