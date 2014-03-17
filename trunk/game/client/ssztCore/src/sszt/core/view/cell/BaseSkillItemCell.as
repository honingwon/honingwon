package sszt.core.view.cell
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.view.timerEffect.TimerEffect;
	import sszt.core.view.tips.SkillTemplateTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	
	public class BaseSkillItemCell extends BaseSkillCell
	{
		protected var _skillInfo:SkillItemInfo;
		private var _timerEffect:TimerEffect;
		
		public function BaseSkillItemCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		public function get skillInfo():SkillItemInfo
		{
			return _skillInfo;
		}
		
		override public function getSourceType():int
		{
			return CellType.SKILLCELL;
		}
		
		override public function getSourceData():Object
		{
			return _skillInfo;
		}
		
		public function set skillInfo(value:SkillItemInfo):void
		{
			if(_skillInfo == value)return;
			if(_skillInfo)
			{
				_skillInfo.removeEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,lockUpdateHandler);
				_skillInfo.removeEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,cooldownUpdateHandler);
			}
			_skillInfo = value;
			if(_skillInfo)
			{
				_skillInfo.addEventListener(SkillItemInfoUpdateEvent.LOCKUPDATE,lockUpdateHandler);
				_skillInfo.addEventListener(SkillItemInfoUpdateEvent.COOLDOWN_UPDATE,cooldownUpdateHandler);
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
			}
		}
		
		protected function lockUpdateHandler(evt:SkillItemInfoUpdateEvent):void
		{
			if(_skillInfo)
			{
				locked = _skillInfo.lock;
			}
		}
		
		protected function cooldownUpdateHandler(e:SkillItemInfoUpdateEvent):void
		{
			//如果是辅助技能
			if( _skillInfo.getTemplate().activeType == 1) return;
			if(_skillInfo.isInCooldown)
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
		
		/**
		 * 设置未学习技能格子信息
		 * @param value 技能模版信息，一般为SkillTemplateInfo类型
		 * @see sszt.core.data.skill SkillTemplateInfo
		 */
		override public function set info(value:ILayerInfo):void
		{
			super.info = value;
			locked = true;
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			if(_skillInfo)
			{
				setChildIndex(_timerEffect,numChildren - 1);
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(_skillInfo)TipsUtil.getInstance().show(_skillInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			else if(_info)TipsUtil.getInstance().show(_info,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_skillInfo || _info)TipsUtil.getInstance().hide();
		}
	}
}