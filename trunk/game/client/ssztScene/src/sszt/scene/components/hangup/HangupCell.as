package sszt.scene.components.hangup
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.DragActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class HangupCell extends BaseCell implements IAcceptDrag
	{
		private var _skillInfo:SkillItemInfo;
		private var _timerEffect:TimerEffect;
		private var _place:int;
		
		public function HangupCell(place:int)
		{
			_place = place;
			super(null,true,true,-1);
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
			_skillInfo = value;
			if(_skillInfo)
			{
				_skillInfo.addEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,skillLockUpdateHandler);
				_skillInfo.addEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,skillCooldownUpdateHandler);
				locked = false;
				
				if(_timerEffect == null)
				{
					_timerEffect = new TimerEffect(_skillInfo.getTemplate().coldDownTime[_skillInfo.level],new Rectangle(_figureBound.x,_figureBound.y,_figureBound.width,_figureBound.height));
					addChild(_timerEffect);
				}
				else
				{
					_timerEffect.setTime(_skillInfo.getTemplate().coldDownTime[_skillInfo.level]);
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
				_timerEffect.setTime(_skillInfo.lastUseTime + Number(_skillInfo.getTemplate().coldDownTime[_skillInfo.level]) - t);	
				_timerEffect.begin();
				this.mouseEnabled = false;
			}
			else
			{
				_timerEffect.stop();
				this.mouseEnabled = true;
			}
		}
		
		override public function getSourceType():int
		{
			return CellType.HANGUPSKILLCELL;
		}
		
		override protected function getLayerType():String
		{
			return LayerType.SKILL_ICON;
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(skillInfo)TipsUtil.getInstance().show(skillInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(skillInfo)TipsUtil.getInstance().hide();
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setChildIndex(_timerEffect,numChildren - 1);
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			var skillItem:SkillItemInfo = source.getSourceData() as SkillItemInfo;
			if(skillItem && skillItem.getTemplate().activeType == 0)
			{
				if(source == this){action = DragActionType.ONSELF}
				else if(source.getSourceType() == CellType.SKILLCELL)
				{
					if(skillItem)
					{
						action = DragActionType.DRAGIN;
						dispatchEvent(new HangupCellEvent(HangupCellEvent.DRAG_IN,skillItem,_place));
					}
				}
				else if(source.getSourceType() == CellType.SKILLBARCELL)
				{
					if(skillItem && skillItem.getTemplate().getPrepareTime(skillItem.level) == 0)
					{
						action = DragActionType.DRAGIN;
						dispatchEvent(new HangupCellEvent(HangupCellEvent.DRAG_IN,skillItem,_place));
					}
				}
			}
			return action;
		}
		
		override public function dragStop(data:IDragData):void
		{
			if(data.action != DragActionType.DRAGIN && data.action != DragActionType.ONSELF && data.action != DragActionType.UNDRAG)
			{
//				dispatchEvent(new Event(DRAG_OUT));
				dispatchEvent(new HangupCellEvent(HangupCellEvent.DRAG_OUT,null,_place));
			}
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
		}
	}
}