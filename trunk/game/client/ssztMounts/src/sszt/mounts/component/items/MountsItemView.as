package sszt.mounts.component.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.KeyType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.events.ChatModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.mounts.component.cells.MountsCell;
	import sszt.mounts.component.cells.PetCellBig;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.pet.FightAsset;
	import ssztui.pet.ItemMountOnAsset;
	import ssztui.ui.BorderAsset14;
	import ssztui.ui.BorderAsset15;
	
	public class MountsItemView extends Sprite
	{
		private var _bg1:IMovieWrapper;
		private var _bg:BorderAsset14;
		private var _selectBg:BorderAsset15;
		private var _cell:PetCellBig;
		private var _selected:Boolean;
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _fightLabel:MAssetLabel;
		private var _mountsInfo:MountsItemInfo;
		private var _fightBg:Bitmap;
		
		public function MountsItemView(mounts:MountsItemInfo)
		{
			_mountsInfo = mounts;
			super();
			init();
		}
		
		private function init():void
		{
			buttonMode = true;
			
			_bg1 = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,139,48),new Bitmap(new ItemMountOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,5,38,38),new Bitmap(CellCaches.getCellBg()))
			]); 
//			addChild(_bg1 as DisplayObject);
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,139,48);
			graphics.endFill();
//			
//			_bg = new BorderAsset14();
//			addChild(_bg);
//			_bg.width = 163;
//			_bg.height = 46;
			
			_selectBg = new BorderAsset15();
			_selectBg.width = 139;
			_selectBg.height = 66;
			_selectBg.x = 1;
			_selectBg.y = 2;
			addChild(_selectBg);
			_selectBg.visible = false;

			_cell = new PetCellBig();
			_cell.move(9,10);
			addChild(_cell);
			_cell.mountsItemInfo = _mountsInfo;
//			_cell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
//			_cell.addEventListener(MouseEvent.CLICK,clickHandler);
//			var tmp:ItemTemplateInfo;;
//			if(_mountsInfo.styleId == 0 || _mountsInfo.styleId == -1)
//			{
//				tmp = _mountsInfo.template;
//			}
//			else
//			{
//				var item:ItemTemplateInfo = ItemTemplateList.getTemplate(_mountsInfo.styleId);
//				if(item)
//				{
//					tmp = ItemTemplateList.getTemplate(item.property1);
//					if(!tmp)tmp = _mountsInfo.template;
//				}
//			}
//			_cell.mountsInfo = _mountsInfo;
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_mountsInfo.templateId).quality);
			_nameLabel.move(63,10);
			addChild(_nameLabel);
			_nameLabel.setValue(_mountsInfo.nick);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(63,26);
			addChild(_levelLabel);
			_levelLabel.setValue("LV." + _mountsInfo.level.toString());
			
			_fightLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_fightLabel.move(63,42);
			addChild(_fightLabel);
			_fightLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.fightValueTh")+"：<font color='#fffccc'>"+_mountsInfo.fight+"</font>");
			
			_fightBg = new Bitmap(new FightAsset());
			_fightBg.x = _fightBg.y = 8;
			addChild(_fightBg);
			if((_mountsInfo.state & 1) == 0) _fightBg.visible = false;
			else _fightBg.visible = true;
			
			_mountsInfo.addEventListener(MountsItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
			_mountsInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE,updateHandler);
		}
		
		private function updateHandler(event:Event):void
		{
			_levelLabel.setValue("LV." + _mountsInfo.level.toString());
			_fightLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.fightValueTh")+"：<font color='#fffccc'>"+_mountsInfo.fight+"</font>");
		}
		
//		private function cellDownHandler(evt:MouseEvent):void
//		{
//			var cell:MountsCell = evt.currentTarget as MountsCell;
//			if(cell.mountsInfo)
//			{
//				cell.dragStart();
//			}
//		}
		
//		private function clickHandler(evt:MouseEvent):void
//		{
//			if(GlobalAPI.keyboardApi.keyIsDown(KeyType.SHIFT))
//			{
//				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PET,_cell.mountsInfo));
//			}else
//			{
//				MountsItemMenuTip.getInstance().show(_mountsInfo,new Point(evt.stageX,evt.stageY));
//			}
//		}
		
		
		private function stateChangeHandler(evt:MountsItemInfoUpdateEvent):void
		{
			if((_mountsInfo.state & 1) == 0) _fightBg.visible = false;
			else _fightBg.visible = true;
		}
		
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected) _selectBg.visible = true;
			else _selectBg.visible = false;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get mountsInfo():MountsItemInfo
		{
			return _mountsInfo;
		}
		
		public function dispose():void
		{		
			if(_mountsInfo)
			{
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE,updateHandler);
				_mountsInfo = null;
			}
			if(_bg1)
			{
				_bg1.dispose();
				_bg1 = null;
			}
			_bg = null;
			_selectBg = null;
			_fightBg = null;
			if(_cell)
			{
//				_cell.removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
//				_cell.removeEventListener(MouseEvent.CLICK,clickHandler);
				_cell.dispose();
				_cell = null;
			}
			_nameLabel = null;
			_fightLabel = null;
			if(parent) parent.removeChild(this);
		}	
	}
}