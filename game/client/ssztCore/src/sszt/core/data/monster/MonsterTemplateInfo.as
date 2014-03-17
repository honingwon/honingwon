package sszt.core.data.monster
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.characterActionInfos.SceneMonsterActionInfos;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;

	public class MonsterTemplateInfo extends EventDispatcher implements ICharacterInfo
	{
		public var monsterId:int;
		public var name:String;
		public var picPath:String;
		public var maxHp:int;
//		private var _style:Vector.<int>;
		private var _style:Array;
		public var centerX:int;
		public var centerY:int;
		public var sceneId:int;
		public var level:int;
		public var rndPoints:Array;
//		public var monsterWidth:int;
//		public var monsterHeight:int;
		public var picWidth:int = 50;
		public var picHeight:int = 135;
		public var attack:int;
		public var defense:int;
		public var monsterHp:int;
		public var type:int;
		public var camp:int;
		
		public var frameRates:Dictionary = new Dictionary;
		
		public function MonsterTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			monsterId = data.readInt();
			name = data.readUTF();
			picPath = data.readUTF();
			maxHp = data.readInt();
//			_style = Vector.<int>([int(picPath)]);
			_style = [int(picPath)];
			var localPoint:Array = data.readUTF().split(",");
			centerX = localPoint[0];
			centerY = localPoint[1];
			sceneId = data.readInt();
			level = data.readShort();
			
			rndPoints = [];
			var s:String = data.readUTF();
			var tmp:Array = s.split("|");
			for each(var st:String in tmp)
			{
				if(st != "")
				{
					var pr:Array = st.split(",");
					var p:Point = new Point(int(pr[0]),int(pr[1]));
					rndPoints.push(p);
				}
			}
			
//			picWidth = data.readInt();
//			picHeight = data.readInt();
			attack = data.readInt();
			defense = data.readInt();
			
//			monsterHp = data.readInt();
			type = data.readInt();
			camp = data.readShort();
			picWidth = data.readInt();
			picHeight = data.readInt();
			
			var _frameRates:Array = data.readUTF().split("|");
			var _frameRates1:Array ; 
			for(var i:int = 0 ;  i < _frameRates.length ; ++i)
			{
				_frameRates1 = _frameRates[i].split(",");
				if(_frameRates1.length ==2)
					frameRates[_frameRates1[0]] =  _frameRates1[1];
			}
		}
		
		public function getAPoint():Point
		{
			if(rndPoints.length > 0)
			{
				return rndPoints[int(Math.random() * rndPoints.length)];
			}
			return new Point(centerX,centerY);
		}
		
		public function get characterId():uint
		{
			return monsterId;
		}
//		public function get style():Vector.<int>
		public function get style():Array
		{
			return _style;
		}
//		public function set style(value:Vector.<int>):void
		public function set style(value:Array):void
		{
			_style = value;
		}
		public function getSex():int{return 0;}
		public function getCareer():int{return 0;}
		public function getMounts():Boolean{return false;}
		
		
		/**
		 * 传入layerType,返回对应的单元图片长宽
		 * @param type
		 * @return 
		 * 
		 */		
		public function getPicWidth():int { return picWidth; }
		public function getPicHeight():int { return picHeight; }
		
		public function getPartStyle(categoryId:int):int{return 0;}
		public function getLayerInfoById(id:int):ILayerInfo{return null;}
		public function getDefaultLayer(category:int):ILayerInfo{return null;}
		/**
		 * 默认动作
		 * @return 
		 * 
		 */		
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return SceneCharacterActions.DEFAULT;
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
		public function getDistance(selfX:Number,selfY:Number):Number
		{
			return Point.distance(new Point(centerX,centerY),new Point(selfX,selfY));
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