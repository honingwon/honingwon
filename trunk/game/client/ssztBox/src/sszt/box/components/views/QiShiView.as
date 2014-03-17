package sszt.box.components.views
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.box.components.BoxTempCell;
	import sszt.box.components.BoxTempCell1;
	import sszt.box.components.StoreItemCell;
	import sszt.box.data.OpenBoxCostUtil;
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.box.BoxTemplateList;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.ui.button.MTabButton;
	import sszt.ui.container.MTile;
	
	public class QiShiView extends Sprite implements IBoxView
	{
		private var _bgBtmp:Bitmap;
		private var _leftTile:MTile;
		private var _rightTile:MTile;
		private var _promptText:TextField;
		
		private var _oneTimeLabel:TextField;
		private var _tenTimeLabel:TextField;
		private var _fiftyTimeLabel:TextField;
		
		private var _cellList:Array = [];
		private var _cellList1:Array = [];
		
		private var _templateList:Array = [];
		public function QiShiView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{	
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.CENTER);
			
//			_promptText = new TextField();
//			_promptText.width = 244;
//			_promptText.height = 18;
//			_promptText.x = 125;
//			_promptText.y = 271;
//			_promptText.selectable = false;
//			_promptText.textColor = 0xffffff;
//			addChild(_promptText);
			
			_oneTimeLabel = new TextField();
			_oneTimeLabel.x = 54;
			_oneTimeLabel.y = 383;
			_oneTimeLabel.width = 120;
			_oneTimeLabel.height = 18;
			_oneTimeLabel.defaultTextFormat = format;
			_oneTimeLabel.selectable = false;
			addChild(_oneTimeLabel);
			
			_tenTimeLabel = new TextField();
			_tenTimeLabel.x = 183;
			_tenTimeLabel.y = 383;
			_tenTimeLabel.width = 120;
			_tenTimeLabel.height = 18;
			_tenTimeLabel.defaultTextFormat = format;
			_tenTimeLabel.selectable = false;
			addChild(_tenTimeLabel);
			
			_fiftyTimeLabel = new TextField();
			_fiftyTimeLabel.x = 313;
			_fiftyTimeLabel.y = 383;
			_fiftyTimeLabel.width = 120;
			_fiftyTimeLabel.height = 18;
			_fiftyTimeLabel.defaultTextFormat = format;
			_fiftyTimeLabel.selectable = false;
			addChild(_fiftyTimeLabel);
			
			var pos:Array = [{x:88,y:152},{x:134,y:152},{x:180,y:152},{x:258,y:152},{x:304,y:152},{x:350,y:152},
				{x:42,y:197},{x:396,y:197},
				{x:42,y:248},{x:396,y:248},
				{x:88,y:293},{x:134,y:293},{x:180,y:293},{x:258,y:293},{x:304,y:293},{x:350,y:293}
			];
			var pos1:Array = [{x:107,y:216},{x:325,y:216}];
			var cell:BaseCell;
			var i:int = 0;
			for(i = 0; i < pos.length ; ++i)
			{
				cell = new BoxTempCell();
				cell.x = pos[i].x;
				cell.y = pos[i].y;
				_cellList.push(cell);
				addChild(cell);
			}
			
			for(i = 0; i < pos1.length ; ++i)
			{
				cell = new BoxTempCell1();
				cell.x = pos1[i].x;
				cell.y = pos1[i].y;
				_cellList.push(cell);
				addChild(cell);
			}
			
		}
		
		public function initTile(type:int):void
		{
			_templateList = BoxTemplateList.getTemplateArray(type);
			
//			var careerType:int = GlobalData.selfPlayer.career;
//			
//			
////			var text:String = "";
//			switch(careerType)
//			{
//				case CareerType.SANWU:
//					_templateList = BoxTemplateList.getTemplateArray(type);
//					break;
//				case CareerType.XIAOYAO:
//					_templateList = BoxTemplateList.getTemplateArray(type+3);
//					break;
//				case CareerType.LIUXING:
//					_templateList = BoxTemplateList.getTemplateArray(type+6);
//					break;
//			}
			
//			switch(type)
//			{
//				case 1:
//					text = LanguageManager.getWord("ssztl.box.collectQiShi");
//					_promptText.htmlText = text;
//					break;
//				case 2:
//					text = LanguageManager.getWord("ssztl.box.collectZhenShi");
//					_promptText.htmlText = text;
//					break;
//			}
					
			_oneTimeLabel.text = LanguageManager.getWord("ssztl.box.openCost2",OpenBoxCostUtil.getCost(3*type - 2),OpenBoxCostUtil.getCostItemName(3*type - 2));
			_tenTimeLabel.text = LanguageManager.getWord("ssztl.box.openCost",OpenBoxCostUtil.getCost(3*type - 1));
			_fiftyTimeLabel.text = LanguageManager.getWord("ssztl.box.openCost",OpenBoxCostUtil.getCost(3*type));
			
			var cell:BaseCell;
			
			for(var i:int=0;i<18;i++)
			{
				_cellList[i].info = _templateList[i];
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
			if(_leftTile)
			{
				_leftTile.dispose();
				_leftTile = null;
			}
			
			if(_rightTile)
			{
				_rightTile.dispose();
				_rightTile = null;
			}
			
			if(_cellList)
			{
				for each(var cell:BaseCell in _cellList)
				{
					cell.dispose();
					cell = null;
				}
				_cellList = null;
			}
			
			
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}