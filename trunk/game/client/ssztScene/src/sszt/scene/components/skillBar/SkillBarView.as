package sszt.scene.components.skillBar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mhsm.ui.DownBtnAsset;
	import mhsm.ui.UpBtnAsset;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillListUpdateEvent;
	import sszt.core.data.skill.SkillShortCutListUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseSkillItemCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CellEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SkillBarMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	
	public class SkillBarView extends Sprite
	{
		private var _bg1:Bitmap;
		private var _bg2:Bitmap;
		private var _mediator:SkillBarMediator;
		private var _tile:MTile;
		private var _transparentTile:MTile;
		private var _addBtn:MBitmapButton;
		private var _delBtn:MBitmapButton;
//		private var _items:Vector.<SkillBarCell>;
		private var _items:Array;
		
		private var _fightBox:FightView;
		
		public function SkillBarView(mediator:SkillBarMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			gameSizeChangeHandler(null);
			
			_bg2 = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarBg1Asset") as BitmapData);
			_bg2.x = 37;
			_bg2.y = -54;
			addChild(_bg2);
			
			_transparentTile = new MTile(38,38,10);
			_transparentTile.setSize(371,38);
			_transparentTile.itemGapW = -1;
			_transparentTile.move(37,-91);
			_transparentTile.horizontalScrollPolicy = _transparentTile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			_tile = new MTile(38,38,10);
			_tile.setSize(371,38);
			_tile.itemGapW = -1;
			addChild(_tile);
			_tile.move(37,-54);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			
//			_addBtn = new MBitmapButton(new SkillBarAddBtnAsset());
			_addBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.SkillBarAddBtnAsset") as BitmapData);
			_addBtn.move(411,-31);
			addChild(_addBtn);
			
			_delBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.SkillBarDelBtnAsset") as BitmapData);
			_delBtn.move(411,-31);
			_delBtn.visible = false;
			addChild(_delBtn);
			
			initCells();
			
			_fightBox = new FightView();
			_fightBox.move(37,-92);
			addChild(_fightBox);
		}
		
		private function initEvent():void
		{
			_addBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_addBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_addBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			_delBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_delBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_delBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			
			GlobalData.skillShortCut.addEventListener(SkillShortCutListUpdateEvent.UPDATE_SHORTCUT,updateShortCutHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,itemUpdateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_addBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_addBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_addBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			
			_delBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_delBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_delBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			
			GlobalData.skillShortCut.removeEventListener(SkillShortCutListUpdateEvent.UPDATE_SHORTCUT,updateShortCutHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,itemUpdateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 728 >> 1 ;
			y = CommonConfig.GAME_HEIGHT ;
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(!_bg1)
			{
				showExtend();
			}
			else if(_bg1.parent)
			{
				hideExtend();
			}
			else
			{
				showExtend();
			}
		}
		
		private function showExtend():void
		{
			_delBtn.visible = true;
			_addBtn.visible = false;
			if(!_bg1)
			{
				_bg1 = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarBg1Asset") as BitmapData);
				_bg1.x = 37;
				_bg1.y = -91;
			}
			if(!_bg1.parent)addChild(_bg1);
			if(!_transparentTile.parent)addChild(_transparentTile);
			
			_fightBox.y = -130;
		}
		private function hideExtend():void
		{
			_delBtn.visible = false;
			_addBtn.visible = true;
			
			if(_transparentTile && _transparentTile.parent)_transparentTile.parent.removeChild(_transparentTile);
			if(_bg1 && _bg1.parent)_bg1.parent.removeChild(_bg1);
			
			_fightBox.y = -92;
		}
		
		private function btnOverHandler(e:MouseEvent):void
		{
			var str:String;
			switch(e.currentTarget)
			{
				case _addBtn:
					str = LanguageManager.getWord("ssztl.scene.openSkillQuickPanel");
					break;
				case _delBtn:
					str = LanguageManager.getWord("ssztl.scene.hideSkillQuickPanel");
					break;
			}
			TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function btnOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function updateShortCutHandler(e:SkillShortCutListUpdateEvent):void
		{
			doUpdate(int(e.data["type"]),int(e.data["place"]));
		}
		
		private function itemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			for each(var cell:SkillBarCell in _items)
			{
				if(cell.itemInfo)
				{
					var count:int = GlobalData.bagInfo.getItemCountById(cell.itemInfo.templateId);
					if(count > 0)
					{
						cell.count = count;
					}
					else
					{
						_mediator.dragItem(1,cell.itemInfo.templateId,cell.place,-1);
					}
				}
			}
		}
		
		private function doUpdate(type:int,place:int):void
		{
			var list:Array = GlobalData.skillShortCut.getItemIdByPlace(place);
			if(type == 0)
			{
				if(list == null || list.length == 0)
				{
					_items[place].skillInfo = null;
				}
				else
				{
					var skill:SkillItemInfo = GlobalData.skillInfo.getSkillById(list[1]);
					_items[place].skillInfo = skill;
				}
			}
			else if(type == 1)
			{
				if(list == null || list.length == 0)
				{
					_items[place].itemList = null;
				}
				else
				{
					var itemInfo:ItemInfo;
					var itemList:Array = GlobalData.bagInfo.getItemById(list[1]);
					_items[place].itemList = itemList;
				}
			}
			else if(type == 2)
			{
				_items[place].itemList = null;
				_items[place].skillInfo = null;
			}
		}
		
		private function initCells():void
		{
			_items = [];
			var i:int;
			for(i = 0; i < 20; i++)
			{
				var item:SkillBarCell = new SkillBarCell(i,i > 9);
				item.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				item.addEventListener(CellEvent.CELL_MOVE,cellMoveHandler);
				item.addEventListener(SkillBarCell.DRAG_OUT,cellDragOutHandler);
				item.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
				if(i > 9){_transparentTile.appendItem(item);}
				else{_tile.appendItem(item);}
				
				_items.push(item);
			}
			var list:Array = GlobalData.skillShortCut.getItemList();
			for(i = 0; i < 16 && i < list.length; i++)
			{
				if(list[i])doUpdate(list[i][0],i);
			}
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			var _cur:SkillBarCell = evt.currentTarget as SkillBarCell;
			_cur.over = true;
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var _cur:SkillBarCell = evt.currentTarget as SkillBarCell;
			_cur.over = false;
		}
		
		private function cellDownHandler(evt:MouseEvent):void
		{
			var cell:SkillBarCell = evt.currentTarget as SkillBarCell;
			if(cell.skillInfo && cell.skillInfo.isInCooldown)return;
			if(cell.itemInfo && cell.itemInfo.isInCooldown)return;
			GlobalAPI.dragManager.startDrag(cell);
		}
		
		private function cellMoveHandler(evt:CellEvent):void
		{
			_mediator.dragItem(evt.data["type"],evt.data["id"],evt.data["fromPlace"],evt.data["toPlace"]);
		}
		
		private function cellDragOutHandler(evt:Event):void
		{
			var cell:SkillBarCell = evt.currentTarget as SkillBarCell;
			if(cell.skillInfo != null)
				_mediator.dragItem(0,cell.skillInfo.templateId,cell.place,-1);
			else if(cell.itemInfo != null)
				_mediator.dragItem(1,cell.itemInfo.templateId,cell.place,-1);
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var index:int = _items.indexOf(evt.currentTarget as SkillBarCell);
			applyItem(index);
		}
		
		public function applyItem(index:int):void
		{
			var cell:SkillBarCell = _items[index];
			if(cell.skillInfo != null)
			{
//				_mediator.sceneModule.sceneInfo.selectSkill = cell.skillInfo;
				_mediator.sceneModule.sceneInfo.addSkill(cell.skillInfo);
				_mediator.attack(cell.skillInfo);
			}
			else if(cell.itemInfo != null)
				_mediator.useItem(cell.itemInfo.templateId);
		}
		
		public function showDeathTip():void
		{
			_fightBox.showDeathTip(true);
		}
	}
}