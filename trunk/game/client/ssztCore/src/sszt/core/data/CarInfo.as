package sszt.core.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.core.data.characterActionInfos.SceneCarActionInfo;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class CarInfo extends EventDispatcher implements ICharacterInfo
	{
//		private var _style:Vector.<int>;
		private var _style:Array;
		public var picWidth:int = 50 ;
		public var picHeight:int = 135;
		public var frameRates:Dictionary = new Dictionary;
		public function CarInfo(id:int = 1)
		{
			super();
//			_style = Vector.<int>([1]);
			_style = [id];
		}
		
		public function get characterId():uint
		{
			return 1;
		}
		
		public function get style():Array
		{
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
			return null;
		}
		
		public function getDefaultLayer(category:int):ILayerInfo
		{
			return null;
		}
		
		public function getWeaponStrength():int
		{
			return 0;
		}
		public function getWindStrength():int{return 0;}
		public function getMountsStrengthLevel():int{return 0;}
		public function getHideWeapon():Boolean { return false; }
		public function getHideSuit():Boolean{return false;}
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return SceneCarActionInfo.STAND;
		}
		
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