package sszt.core.data.pet
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.core.data.LayerInfo;
	import sszt.core.data.characterActionInfos.ScenePetCharacterActions;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class PetTemplateInfo extends LayerInfo implements ICharacterInfo 
	{
//		private var _style:Vector.<int>;
		public var name:String;
		public var quality:int;
		private var _style:Array;
		public var picWidth:int = 50 ;
		public var picHeight:int = 135;
		public var frameRates:Dictionary = new Dictionary;
		public function PetTemplateInfo()
		{
			super();
			_style = new Array(1);
		}
		
		
		public function parseData(data:ByteArray) : void
		{
			templateId = data.readInt();
			picPath = iconPath = data.readUTF();
//			name = data.readUTF();
		}
		
		
		public function get characterId():uint
		{
			return templateId;
		}
		
//		public function get style():Vector.<int>
		public function get style():Array
		{
			if(_style == null)
			{
//				_style = new Vector.<int>();
				_style = [];
				_style.push(int(picPath));
			}
			return _style;
		}
		
		public function getSex():int
		{
			return 0;
		}
		
		public function getCareer():int
		{
			return 0;
		}
		
		public function getMounts():Boolean
		{
			return false;
		}
		
		public function getPicWidth():int { return picWidth; }
		public function getPicHeight():int { return picHeight; }
		
		public function getPartStyle(categoryId:int):int
		{
			return 0;
		}
		
		public function getLayerInfoById(id:int):ILayerInfo
		{
			return this;
		}
		
		public function getDefaultLayer(category:int):ILayerInfo
		{
			return null;
		}
		
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return ScenePetCharacterActions.STAND;
		}
		public function getDefaultActionType(type:String):int
		{
			return ActionType.STAND;
		}
		public function getWeaponStrength():int
		{
			return 0;
		}
		public function getHideWeapon():Boolean { return false; }
		public function getHideSuit():Boolean{return false;}
		
		public function getWindStrength():int{return 0;}
		public function getMountsStrengthLevel():int{return 0;}
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{}
		public function dispatchEvent(event:Event):Boolean{return false;}
		public function hasEventListener(type:String):Boolean{return false;}
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{}
		public function willTrigger(type:String):Boolean{return false;}
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