package sszt.scene.components.skillBar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.DragActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseSkillItemCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CellEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.label.MAssetLabel;
	
	public class SkillBarCell extends BaseCell implements IAcceptDrag
	{
		public static const DRAG_OUT:String = "dragOut";
		
		private var _place:int;
		private var _skillInfo:SkillItemInfo;
		private var _itemInfo:ItemInfo;
		private var _countField:TextField;
		private var _timerEffect:TimerEffect;
		private var _isCtrl:Boolean;
		private var _field:TextField;
		private var _itemList:Array;
		private var _count:int;
		private var _over:Bitmap;
		
		public function SkillBarCell(place:int,isCtrl:Boolean = false)
		{
			buttonMode = true;
			_place = place;
			_isCtrl = isCtrl;
			super();
			//			_field = new MAssetLabel((_isCtrl ? "ctrl+" : "") + (_isCtrl ? _place - 7 : (_place + 1)),[new TextFormat("Arial",9,0xEDDB60,null,null,
			//					null,null,null,TextFormatAlign.RIGHT),new GlowFilter(0x1D250E,1,2,2,4.5)]);
			//			_field.setSize(36,20);
			_field = new TextField();
			_field.text = (_isCtrl ? "ctrl+" : "") + (_isCtrl ? (_place - 9)%10 : (_place + 1)%10);
			_field.setTextFormat(new TextFormat("Tahoma",10,0xFFFCCC,null,null,null,null,null,TextFormatAlign.LEFT));
			_field.filters = [new GlowFilter(0x000000,1,2,2,9)];
			_field.width = 38;
			_field.height = 20;
			_field.x = 2;
			_field.mouseEnabled = _field.mouseWheelEnabled = false;
			addChild(_field);
			
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.visible = false;
			addChild(_over);
		}
		
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		public function get place():int
		{
			return _place;
		}
		
		public function get skillInfo():SkillItemInfo
		{
			return _skillInfo;
		}
		public function set skillInfo(value:SkillItemInfo):void
		{
			if(_skillInfo == value)return;
			if(_skillInfo)
			{
				_skillInfo.removeEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,skillLockUpdateHandler);
				_skillInfo.removeEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,skillCooldownUpdateHandler);
			}
			if(itemInfo)itemInfo = null;
			_skillInfo = value;
			if(_skillInfo)
			{
				_skillInfo.addEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,skillLockUpdateHandler);
				_skillInfo.addEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,skillCooldownUpdateHandler);
				locked = false;
				
				if(_timerEffect == null)
				{
					_timerEffect = new TimerEffect(_skillInfo.getTemplate().coldDownTime[_skillInfo.level - 1],new Rectangle(_figureBound.x,_figureBound.y,_figureBound.width,_figureBound.height));
					//					_timerEffect.mouseEnabled = _timerEffect.mouseChildren = false;
					addChild(_timerEffect);
				}
				else
				{
					_timerEffect.setTime(_skillInfo.getTemplate().coldDownTime[_skillInfo.level - 1]);
				}
				
				super.info = _skillInfo.getTemplate();
			}
			else
			{
				locked = true;
				if(_timerEffect)
				{
					_timerEffect.dispose();
					_timerEffect = null;
				}
				super.info = null;
			}
		}
		
		public function get itemList():Array
		{
			return _itemList;
		}
		public function set itemList(list:Array):void
		{
			if(list == null)
			{
				_itemList = null;
				itemInfo = null;
			}
			else
			{
				_itemList = list;
				itemInfo = list[0];
			}
			if(itemInfo)
			{
				_count = GlobalData.bagInfo.getItemCountById(itemInfo.templateId);
				if(_count > 99)_count = 99;
				if(_countField == null)
				{
					_countField = new TextField();
					_countField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
					_countField.filters = [new GlowFilter(0x1D250E,1,2,2,9)];
					_countField.mouseEnabled = _countField.mouseWheelEnabled = false;
					_countField.x = 2;
					_countField.y = 22;
					_countField.width = 36;
					addChild(_countField);
				}
				_countField.text = String(_count);
			}
			else
			{
				if(_countField && _countField.parent)
				{
					_countField.parent.removeChild(_countField);
				}
				_countField = null;
			}
		}
		
		public function get itemInfo():ItemInfo
		{
			return _itemInfo;
		}
		public function set itemInfo(value:ItemInfo):void
		{
			if(_itemInfo == value)return;
			if(_itemInfo)
			{
				//				_itemInfo.removeEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,itemLockUpdateHandler);
				_itemInfo.removeEventListener(ItemInfoUpdateEvent.COOLDOWN_UPDATE,itemCooldownUpdateHandler);
				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_ITEM_CD,updateItemCdHandler);
			}
			if(skillInfo)skillInfo = null;
			_itemInfo = value;
			if(_itemInfo)
			{
				//				_itemInfo.addEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,itemLockUpdateHandler);
				_itemInfo.addEventListener(ItemInfoUpdateEvent.COOLDOWN_UPDATE,itemCooldownUpdateHandler);
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_ITEM_CD,updateItemCdHandler);
				
				if(CategoryType.isHpDrup(_itemInfo.template.categoryId) || CategoryType.isMpDrup(_itemInfo.template.categoryId))
				{
					if(_timerEffect == null)
					{
						_timerEffect = new TimerEffect(_itemInfo.template.cd,new Rectangle(_figureBound.x,_figureBound.y,_figureBound.width,_figureBound.height));
						//						_timerEffect.mouseEnabled = _timerEffect.mouseChildren = false;
						addChild(_timerEffect);
					}
					if(CategoryType.isHpDrup(_itemInfo.template.categoryId)  && (getTimer() - GlobalData.lastUseTime_hp < _itemInfo.template.cd) && GlobalData.lastUseTime_hp != 0)
					{
						_timerEffect.setTime(_itemInfo.template.cd + GlobalData.lastUseTime_hp - getTimer());
						_timerEffect.begin();
					}
					else if(CategoryType.isMpDrup(_itemInfo.template.categoryId)  && (getTimer() - GlobalData.lastUseTime_mp < _itemInfo.template.cd) && GlobalData.lastUseTime_mp != 0)
					{
						_timerEffect.setTime(_itemInfo.template.cd + GlobalData.lastUseTime_mp - getTimer());
						_timerEffect.begin();
					}
				}
				
				locked = false;
				super.info = _itemInfo.template;
			}
			else
			{
				locked = true;
				if(_timerEffect)
				{
					_timerEffect.dispose();
					_timerEffect = null;
				}
				super.info = null;
			}
		}
		
		public function get count():int
		{
			return _count;
		}
		public function set count(value:int):void
		{
			if(_count == value)return;
			_count = value > 99 ? 99 : value;
			_countField.text = String(_count);
		}
		
		private function updateItemCdHandler(e:CommonModuleEvent):void
		{
			if(_itemInfo && CategoryType.isHpDrup(_itemInfo.template.categoryId) && e.data == 1)
			{
				if((getTimer() - GlobalData.lastUseTime_hp < _itemInfo.template.cd) && GlobalData.lastUseTime_hp != 0)
				{
					_timerEffect.setTime(_itemInfo.template.cd + GlobalData.lastUseTime_hp - getTimer());
					_timerEffect.begin();
				}
			}
			else if(_itemInfo && CategoryType.isMpDrup(_itemInfo.template.categoryId) && e.data == 2)
			{
				if((getTimer() - GlobalData.lastUseTime_mp < _itemInfo.template.cd) && GlobalData.lastUseTime_mp != 0)
				{
					_timerEffect.setTime(_itemInfo.template.cd + GlobalData.lastUseTime_mp - getTimer());
					_timerEffect.begin();
				}
			}
		}
		
		private function skillLockUpdateHandler(e:SkillItemInfoUpdateEvent):void
		{
			if(_skillInfo)
			{
				locked = _skillInfo.lock;
			}
		}
		
		private function skillCooldownUpdateHandler(e:SkillItemInfoUpdateEvent):void
		{
			if(_skillInfo.isInCooldown)
			{
				var t:Number = GlobalData.systemDate.getSystemDate().getTime();
				_timerEffect.setTime(_skillInfo.lastUseTime + Number(_skillInfo.getTemplate().coldDownTime[_skillInfo.level - 1]) - t);	
				_timerEffect.begin();
				this.mouseEnabled = false;
			}
			else
			{
				_timerEffect.stop();
				this.mouseEnabled = true;
			}
		}
		
		//		private function itemLockUpdateHandler(e:ItemInfoUpdateEvent):void
		//		{
		//			if(_itemInfo)
		//			{
		//				locked = _itemInfo.lock;
		//			}
		//		}
		
		private function itemCooldownUpdateHandler(e:ItemInfoUpdateEvent):void
		{
			if(_itemInfo.isInCooldown)
			{
				_timerEffect.begin();
				this.mouseEnabled = false;
			}
			else
			{
				_timerEffect.stop();
				this.mouseEnabled = true;
			}
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			var skillItem:SkillItemInfo;
			var item:ItemInfo;
			if(source == this){action = DragActionType.ONSELF}
			else if(source.getSourceType() == CellType.SKILLCELL)
			{
				skillItem = source.getSourceData() as SkillItemInfo;
				if(skillItem && (skillItem.getTemplate().activeType == 0 || skillItem.getTemplate().activeType == 2))
				{
					action = DragActionType.DRAGIN;
					dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,{type:0,id:skillItem.templateId,fromPlace:-1,toPlace:_place}));
				}
			}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				item = source.getSourceData() as ItemInfo;
				if(CategoryType.getCanMoveSkillBar(item.template.categoryId))
				{
					action = DragActionType.DRAGIN;
					dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,{type:1,id:item.templateId,fromPlace:-1,toPlace:_place}));
				}
			}
			else if(source.getSourceType() == CellType.SKILLBARCELL)
			{
				action = DragActionType.DRAGIN;
				if(SkillBarCell(source).itemInfo != null)
				{
					item = source.getSourceData() as ItemInfo;
					dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,{type:1,id:item.templateId,fromPlace:source["place"],toPlace:_place}));
				}
				else if(SkillBarCell(source).skillInfo != null)
				{
					skillItem = source.getSourceData() as SkillItemInfo;
					dispatchEvent(new CellEvent(CellEvent.CELL_MOVE,{type:0,id:skillItem.templateId,fromPlace:source["place"],toPlace:_place}));
				}
			}
			return action;
		}
		
		override public function dragStop(data:IDragData):void
		{
			if(data.action != DragActionType.DRAGIN && data.action != DragActionType.ONSELF && data.action != DragActionType.UNDRAG)
			{
				dispatchEvent(new Event(DRAG_OUT));
			}
		}
		
		//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setChildIndex(_over,numChildren - 1);
			if(_skillInfo)
			{
				setChildIndex(_timerEffect,numChildren - 1);
			}
			else if(_itemInfo)
			{
				if(_countField)setChildIndex(_countField,numChildren - 1);
				if(_timerEffect)setChildIndex(_timerEffect,numChildren - 1);
			}
			setChildIndex(_field,numChildren - 1);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(itemInfo)TipsUtil.getInstance().show(itemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			else if(skillInfo)TipsUtil.getInstance().show(skillInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(itemInfo || skillInfo)TipsUtil.getInstance().hide();
		}
		
		override public function getSourceType():int
		{
			return CellType.SKILLBARCELL;
		}
		
		override public function getSourceData():Object
		{
			if(skillInfo)return skillInfo;
			else return itemInfo;
		}
		
		override protected function getLayerType():String
		{
			if(skillInfo)return LayerType.SKILL_ICON;
			return LayerType.ICON;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_timerEffect)
			{
				_timerEffect.dispose();
				_timerEffect = null;
			}
			if(_skillInfo)
			{
				_skillInfo.removeEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,skillLockUpdateHandler);
				_skillInfo.removeEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,skillCooldownUpdateHandler);
				_skillInfo = null;
			}
			if(_itemInfo)
			{
				//				_itemInfo.removeEventListener(ItemInfoUpdateEvent.LOCK_UPDATE,itemLockUpdateHandler);
				_itemInfo.removeEventListener(ItemInfoUpdateEvent.COOLDOWN_UPDATE,itemCooldownUpdateHandler);
				_itemInfo = null;
			}
			_itemList = null;
			_countField = null;
		}
	}
}