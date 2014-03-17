package sszt.core.data.collect
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class CollectTemplateInfo extends EventDispatcher implements ICharacterInfo
	{
		public var id:int;
		public var type:int;
		public var minLevel:int;
		public var maxLevel:int;
		public var awardHp:int;
		public var awardMp:int;
		public var awardLifeExp:int;
		public var awardExp:int;
		public var awardYuanBao:int;
		public var awardBindCopper:int;
		public var awardCopper:int;
		public var collectTime:int;
		public var rebornTime:int;
		public var picPath:String;
		public var sceneId:int;
		public var centerX:int;
		public var centerY:int;
		
		public var name:String;
		public var quality:int;
		
//		private var _style:Vector.<int>;
		private var _style:Array;
		
		public var rndPoints:Array;
		public var picWidth:int = 50;
		public var picHeight:int = 135;
		
		
		public var frameRates:Dictionary = new Dictionary;
		
		public function CollectTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			type = data.readInt();
			minLevel = data.readInt();
			maxLevel = data.readInt();
			awardHp = data.readInt();
			awardMp = data.readInt();
			awardLifeExp = data.readInt();
			awardExp = data.readInt();
			awardYuanBao = data.readInt();
			awardBindCopper = data.readInt();
			awardCopper = data.readInt();
			collectTime = data.readInt();
			rebornTime = data.readInt();
			picPath = data.readUTF();
//			_style = Vector.<int>([int(picPath)]);
			_style = [int(picPath)];
			sceneId = data.readInt();
			var center:Array = data.readUTF().split(",");
			centerX = int(center[0]);
			centerY = int(center[1]);
			//读掉出生点
//			data.readUTF();
			
			quality = data.readInt();
			
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
			return id;
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
			return null;
		}
		
		public function getDefaultActionType(type:String):int
		{
			return 0;
		}
		
		public function getWeaponStrength():int
		{
			return 0;
		}
		public function getWindStrength():int{return 0;}
		public function getMountsStrengthLevel():int{return 0;}
		public function getHideWeapon():Boolean { return false; }
		public function getHideSuit():Boolean{return false;}
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