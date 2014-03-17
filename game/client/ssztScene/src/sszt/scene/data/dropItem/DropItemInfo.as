package sszt.scene.data.dropItem
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class DropItemInfo extends BaseSceneObjInfo implements ICharacterInfo
	{
		public var id:int;
		public var templateId:int;
		private var _template:ItemTemplateInfo;
		public var dropOwnerId:Number;
		
		
		public var picPath:String;
		public var picWidth:int = 50 ;
		public var picHeight:int = 135;
		public var frameRates:Dictionary = new Dictionary;
		
		/**
		 * DropItemStateType
		 */		
		private var _state:int;
		/**
		 * 客户端判段能不能捡，挂机时捡东西没有马上消息。会不停地捡
		 */		
		public var canClientPickup:Boolean = true;
		
		public function DropItemInfo()
		{
		}
		
		public function get state():int
		{
			return _state;
		}
		public function set state(value:int):void
		{
			if(_state == value)return;
			_state = value;
			dispatchEvent(new DropItemUpdateEvent(DropItemUpdateEvent.STATE_UPDATE));
		}
		
		override public function getObjId():Number
		{
			return id;
		}
		
		override public function getObjType():int
		{
			return MapElementType.FALL_PROP;
		}
		
		public function canPick(list:Array):Boolean
		{
			if(canClientPickup)
			{
				if(state != DropItemStateType.LOCK)return true;
				if(list.length > 0)
				{
					for(var i:int = 0; i < list.length; i++)
					{
						if(dropOwnerId == list[i].getObjId())return true;
					}
				}
				else
				{
					if(dropOwnerId == GlobalData.selfPlayer.userId)return true;
				}
			}
			return false;
		}
		
		public function getTemplate():ItemTemplateInfo
		{
			if(_template == null)
			{
				_template = ItemTemplateList.getTemplate(templateId);
			}
			return _template;
		}
		
		public function getCategory():int
		{
			return getTemplate().categoryId;
		}
		public function getQuality():int
		{
			return getTemplate().quality;
		}
		
		public function get characterId():uint
		{
			return templateId;
		}
		public function get style():Array
		{
			return [int(_template.picPath)];
		}
		public function getSex():int
		{
			return 0;
		}
		public function getPicWidth():int { return picWidth; }
		public function getPicHeight():int { return picHeight; }
		public function getPartStyle(categoryId:int):int
		{
			return 0;
		}
		
		public function getLayerInfoById(id:int):ILayerInfo{return null;}
		public function getCareer():int{return 0;}
		public function getDefaultLayer(id:int):ILayerInfo{return null;}
		public function getMounts():Boolean{return false;}
		public function getWeaponStrength():int
		{
			return 0;
		}
		public function getWindStrength():int{return 0;}
		public function getMountsStrengthLevel():int{return 0;}
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return  null;
		}
		public function getHideWeapon():Boolean { return false; }
		public function getHideSuit():Boolean{return false;}
		public function getDefaultActionType(type:String):int
		{
			return ActionType.STAND;
		}
		
		public function getFrameRate(actionType:int):int
		{
			if(frameRates.hasOwnProperty(actionType))
			{
				return frameRates[actionType];
			}
			else if(frameRates.hasOwnProperty(0))
			{
				return frameRates[0];
			}
			return 3;
		}
		
	}
}