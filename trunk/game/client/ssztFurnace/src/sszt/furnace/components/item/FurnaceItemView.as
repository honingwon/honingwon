package sszt.furnace.components.item
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.manager.LanguageManager;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.components.cell.FurnaceQualityCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class FurnaceItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _furnaceCell:FurnaceQualityCell;
		private var _itemNameLabel:MAssetLabel;
		private var _descriptionLabel:MAssetLabel;
		private var _furnaceItemInfo:FurnaceItemInfo;
		
		public function FurnaceItemView(argFurnaceItemIno:FurnaceItemInfo)
		{
			super();
			_furnaceItemInfo = argFurnaceItemIno;
			
			buttonMode = true;
//			graphics.beginFill(0,0);
//			graphics.drawRect(0,0,140,52);
//			graphics.endFill();
//			
//			graphics.lineStyle(1,0xFFFFFF,1);
//			graphics.drawRect(0,0,140,52);
			initialView();
			initialEvents();
			updaeView(null);
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(0,0,120,48)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,5,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_furnaceCell = new FurnaceQualityCell(_furnaceItemInfo);
			_furnaceCell.x = 4;
			_furnaceCell.y = 5;
			addChild(_furnaceCell);
			
			_itemNameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
//			_itemNameLabel.textColor = CategoryType.getQualityColor(_furnaceItemInfo.bagItemInfo.template.quality);
			_itemNameLabel.autoSize = TextFieldAutoSize.LEFT;
			_itemNameLabel.selectable = false;
			_itemNameLabel.move(43,6);
			_itemNameLabel.width = 85;
			_itemNameLabel.height = 20;
			addChild(_itemNameLabel);
			
			_descriptionLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_descriptionLabel.autoSize = TextFieldAutoSize.LEFT;
			_descriptionLabel.selectable = false;
			_descriptionLabel.move(43,25);
			_descriptionLabel.width = 60; 
			_descriptionLabel.height = 20;
			addChild(_descriptionLabel);
			
			updateDescriptionLabel();
		}
		
		private function initialEvents():void
		{
			_furnaceItemInfo.addEventListener(FuranceEvent.ITEMINFO_CELL_UPDATE,updaeView);
		}
		private function removeInitialEvents():void
		{
			_furnaceItemInfo.removeEventListener(FuranceEvent.ITEMINFO_CELL_UPDATE,updaeView);
		}
		
		private function updaeView(e:FuranceEvent):void
		{
			if(_furnaceItemInfo.count <= 0)
			{
				mouseEnabled = mouseChildren = buttonMode = false;
				filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
			else
			{
				mouseEnabled = mouseChildren = buttonMode = true;
				filters = [];	
			}
			updateDescriptionLabel();
		}
			
		
		private function updateDescriptionLabel():void
		{
			_itemNameLabel.text = _furnaceItemInfo.bagItemInfo.template.name;
			_itemNameLabel.textColor = CategoryType.getQualityColor(_furnaceItemInfo.bagItemInfo.template.quality);
			var tmp:String = "";
			switch(_furnaceItemInfo.type)
			{
				case -1:
					tmp = LanguageManager.getWord("ssztl.common.count2") + _furnaceItemInfo.count.toString();
					break;
				case FurnaceBuyType.EQUIPTRANSFORM:
				case FurnaceBuyType.STRENGTH:
				case FurnaceBuyType.FUSE:
					tmp = LanguageManager.getWord("ssztl.furnace.StrengthPlus")  + _furnaceItemInfo.bagItemInfo.strengthenLevel.toString();
					break;
				case FurnaceBuyType.REMOVE:
					tmp = LanguageManager.getWord("ssztl.furnace.holeNum") + "："  + _furnaceItemInfo.bagItemInfo.getEnchaseCount(true) +"/" + _furnaceItemInfo.bagItemInfo.getUsedHoleCount(true);
					break;
				case FurnaceBuyType.REBUILD:
//					tmp = LanguageManager.getWord("ssztl.common.count2")  + _furnaceItemInfo.count.toString();
					tmp = LanguageManager.getWord("ssztl.furnace.StrengthPlus")  + _furnaceItemInfo.bagItemInfo.strengthenLevel.toString();
					break;
//				case FurnaceBuyType.OPENHOLE:
//					tmp = LanguageManager.getWord("ssztl.furnace.holeNum")  + _furnaceItemInfo.bagItemInfo.getUsedHoleCount(false) +"/3" ;
//					break;
				case FurnaceBuyType.COMPOSE:
					tmp = LanguageManager.getWord("ssztl.common.count2")  + _furnaceItemInfo.count.toString();
					break;
				case FurnaceBuyType.ENCHASE:
					tmp = LanguageManager.getWord("ssztl.furnace.enchase") + "："  + _furnaceItemInfo.bagItemInfo.getEnchaseCount(true) +"/"  +_furnaceItemInfo.bagItemInfo.getUsedHoleCount(true);
					break;
				
				case FurnaceBuyType.ITEMCOMPOSE:
					tmp = LanguageManager.getWord("ssztl.common.count2")  + _furnaceItemInfo.count.toString();
					break;
				case FurnaceBuyType.WUHUN:
					tmp = LanguageManager.getWord("ssztl.common.count2")  + _furnaceItemInfo.count.toString();
					break;
			}
			_descriptionLabel.text = tmp;
		}
		
//		private function updateTextField():void
//		{
//			_descriptionLabel.text = "+ " + _furnaceItemInfo.count.toString();
//		}

		public function get furnaceItemInfo():FurnaceItemInfo
		{
			return _furnaceItemInfo;
		}

		public function set furnaceItemInfo(value:FurnaceItemInfo):void
		{
			_furnaceItemInfo = value;
			_furnaceCell.furnaceItemInfo = value;
			updaeView(null);
		}
		
		public function dispose():void
		{
			removeInitialEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_furnaceCell)
			{
				_furnaceCell.dispose();
				_furnaceCell = null;
			}
			_itemNameLabel = null;
			_descriptionLabel = null;
			_furnaceItemInfo = null;
			if(parent)parent.removeChild(this);
		}

	}
}