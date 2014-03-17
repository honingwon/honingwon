package sszt.box.components.small.views
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.ui.container.MTile;
	
	import sszt.box.components.BoxTempCell;
	import sszt.box.components.views.IBoxView;
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.box.BoxTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	
	public class QiShiSmallView extends Sprite implements IBoxView
	{
		private var _promptText:TextField;
		private var _tile:MTile;
		private var _cellList:Array = [];
		private var _templateList:Array = [];
		public function QiShiSmallView()
		{
			initView();
		}

		private function initView():void
		{
			_promptText = new TextField();
			_promptText.width = 250;
			_promptText.height = 18;
			_promptText.x = 37;
			_promptText.y = 152;
			_promptText.textColor = 0xffffff;
			_promptText.selectable = false;
			_promptText.filters = [new GlowFilter(0,1,2,2,4)];
			addChild(_promptText);
			
			_tile = new MTile(40,40,6);
			_tile.itemGapH = 7;
			_tile.itemGapW = 9;
			_tile.setSize(394,144);
			_tile.move(8,10);
			addChild(_tile);
			
			var cell:BaseCell;
			for(var i:int=0;i<18;i++)
			{
				cell = new BoxTempCell();
				cell.info = _templateList[i];
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
			
			initTile(2);
		}
		/**
		 *type 1:铜宝 2：银宝 3：金宝
		 */
		public function initTile(type:int):void
		{
			
			var careerType:int = GlobalData.selfPlayer.career;
			var text:String = "";
			switch(careerType)
			{
				case CareerType.SANWU:
					_templateList = BoxTemplateList.getTemplateArray(type);
					break;
				case CareerType.XIAOYAO:
					_templateList = BoxTemplateList.getTemplateArray(type+3);
					break;
				case CareerType.LIUXING:
					_templateList = BoxTemplateList.getTemplateArray(type+6);
					break;
			}
			
			switch(type)
			{
				case 1:
					text = LanguageManager.getWord("ssztl.box.collectQiShi");
					_promptText.htmlText = text;
					break;
				case 2:
					text = LanguageManager.getWord("ssztl.box.collectZhenShi");
					_promptText.htmlText = text;
					break;
				case 3:
					text = LanguageManager.getWord("ssztl.box.collectXianShi");
					_promptText.htmlText = text;
					break;
			}
			
			var cell:BaseCell;
			for(var i:int=0;i<18;i++)
			{
//				cell = new BoxTempCell();
				_cellList[i].info = _templateList[i];
//				_tile.appendItem(cell);
//				_cellList.push(cell);
			}
			
		}
		
		public function show():void
		{
			initEvents();
		}
		
		public function hide():void
		{
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function setSize(width:int, height:int):void
		{
			graphics.beginFill(0xffffff,0);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function initEvents():void
		{
		}
		
		public function removeEvents():void
		{
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_cellList)
			{
				for each(var cell:BoxTempCell in _cellList)
				{
					cell.dispose();
				}
				cell = null;
				_cellList = null;
			}
		}
	}
}