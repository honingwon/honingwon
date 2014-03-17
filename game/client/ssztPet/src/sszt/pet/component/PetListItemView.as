package sszt.pet.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.pet.component.cells.PetCell;
	import sszt.pet.component.cells.PetCellBig;
	import sszt.pet.data.PetStateType;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.pet.FightAsset;
	import ssztui.pet.ItemOnAsset;
	import ssztui.ui.BorderAsset15;
	
	public class PetListItemView extends Sprite
	{
		private var _petItemInfo:PetItemInfo;
		
		private var _bg:IMovieWrapper;
		private var _selectBg:BorderAsset15;
		private var _fightBg:Bitmap;
		private var _petHeadCell:PetCellBig;
		
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _fightLabel:MAssetLabel;
		
		private var _selected:Boolean;
		
		public function PetListItemView(petItemInfo:PetItemInfo)
		{
			_petItemInfo = petItemInfo;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			buttonMode = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,139,48);
			graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,139,48),new Bitmap(new ItemOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,5,38,38),new Bitmap(CellCaches.getCellBg()))
			]);
//			addChild(_bg as DisplayObject);
			
			_petHeadCell = new PetCellBig();
			_petHeadCell.move(9,10);
			addChild(_petHeadCell);
			_petHeadCell.petItemInfo = _petItemInfo;
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameLabel.move(63,10);
			addChild(_nameLabel);
			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_petItemInfo.templateId).quality);
			_nameLabel.setValue(_petItemInfo.nick);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(63,26);
			addChild(_levelLabel);
			_levelLabel.setValue("LV." + _petItemInfo.level.toString());
			
			_fightLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_fightLabel.move(63,42);
			addChild(_fightLabel);
			
			_fightBg = new Bitmap(new FightAsset());
			_fightBg.x = _fightBg.y = 8;
			addChild(_fightBg);
			_fightBg.visible = _petItemInfo.state == PetStateType.FIGHT ? true : false;
			
			_selectBg = new BorderAsset15();
			_selectBg.width = 139;
			_selectBg.height = 66;
			_selectBg.x = 1;
			_selectBg.y = 2;
			addChild(_selectBg);
			_selectBg.visible = false;
			_selectBg.mouseEnabled = _selectBg.mouseChildren = false;
			
			updateAttr();
		}
		
		private function initEvent():void
		{
			//监听宠物出战/休息状态
			_petItemInfo.addEventListener(PetItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
			_petItemInfo.addEventListener(PetItemInfoUpdateEvent.RENAME,renameHandler);
			_petItemInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE,attrUpdateHander);
		}
		
		private function removeEvent():void
		{
			_petItemInfo.removeEventListener(PetItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
			_petItemInfo.removeEventListener(PetItemInfoUpdateEvent.RENAME,renameHandler);
			_petItemInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE,attrUpdateHander);
		}
		
		private function attrUpdateHander(e:Event):void
		{
			updateAttr();
		}
		
		private function updateAttr():void
		{
			_levelLabel.setValue("LV." + _petItemInfo.level.toString());
			_fightLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.fightValueTh")+"：<font color='#fffccc'>"+_petItemInfo.fight+"</font>");
		}
		
		private function renameHandler(e:Event):void
		{
			_nameLabel.setValue(_petItemInfo.nick);
			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_petItemInfo.templateId).quality);
			_petHeadCell.petItemInfo = _petItemInfo;
		}
		
		public function get petItemInfo():PetItemInfo
		{
			return _petItemInfo;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
//			if(_selectBg)
//			{
				_selectBg.visible = _selected ? true : false;
//			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function stateChangeHandler(event:PetItemInfoUpdateEvent):void
		{
			_fightBg.visible = _petItemInfo.state == PetStateType.FIGHT ? true : false;
		}
		
		public function dispose():void
		{
			removeEvent();
			
			_petItemInfo = null;
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_selectBg)
			{
				_selectBg = null;
			}			
			if(_fightBg && _fightBg.bitmapData)
			{
				_fightBg.bitmapData.dispose();
				_fightBg = null;
			}
			if(_petHeadCell)
			{
				_petHeadCell.dispose();
				_petHeadCell = null;
			}
			_nameLabel = null;
			_fightLabel = null;
		}	
	}
}