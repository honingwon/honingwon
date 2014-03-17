package sszt.swordsman.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.mediator.SwordsmanMediator;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel; 
	
	/**
	 * 公共顶部 
	 * @author chendong
	 * 
	 */	
	public class CommonTop extends Sprite implements IPanel
	{
		/**
		 * 0:发布江湖令;1:领取江湖令 
		 */		
		private var _type:int = 0;
		/**
		 *  江湖令分为绿、蓝、紫、橙四种，每天总共可发布(领取)5次江湖令任务。发布的江湖令任务呗领取可立即获得经验奖励，江湖令品质越高，奖励越高。
		 */
		private var _description:MAssetLabel;
		
		private var _tile:MTile;
		
		private var _PAGESIZE:int = 4;
		
		private var _cellList:Array;
		
		private var _mediator:SwordsmanMediator;
		
		public function CommonTop(type:int,mediator:SwordsmanMediator)
		{
			super();
			_type = type;
			_mediator = mediator;
			initView();
			initEvent();
//			initData();
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			for(var i:int = 0;i < _cellList.length;i++)
			{
				if(_cellList[i]._swordsmanPic.itemInfo == null)
				{
					var item:ItemInfo = new ItemInfo();
					item.templateId = 206020;
					item.count = 10000;
					_cellList[i]._swordsmanPic.itemInfo = item;
					break;
				}
			}
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			ModuleEventDispatcher.addModuleEventListener(SwordsmanMediaEvents.UPDATE_TOKEN_NUM,updateTokenNum);
		}
		
		public function initView():void
		{
			// TODO Auto Generated method stub
			
			_description = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_description.setLabelType([new TextFormat("SimSun",12,0xffcc66,null,null,null,null,null,null,null,null,null,6)]);
			_description.move(226,16);
			addChild(_description);
			_description.setHtmlValue(LanguageManager.getWord('ssztl.swordsMan.tip'));
			
			_tile = new MTile(103,54,4);
			_tile.itemGapW = 2;
			_tile.itemGapH = 0;
			_tile.setSize(418,155);
			_tile.move(18,67);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			
			_cellList = new Array();
			for(var i:int = 0;i< _PAGESIZE;i++)
			{
				var cell:SwordsmanSprite = new SwordsmanSprite(_type,i,_mediator);
				_cellList.push(cell);
				_tile.appendItem(cell);
			}
		}
		
		
		public function updateTokenNum(evt:SwordsmanMediaEvents):void
		{
			for(var i:int=0; i<_cellList.length; i++)
			{
				if(_cellList[i]._type == 1)
				{
					_cellList[i].initData();
				}
			}
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			ModuleEventDispatcher.removeModuleEventListener(SwordsmanMediaEvents.UPDATE_TOKEN_NUM,updateTokenNum);
		}
	}
}