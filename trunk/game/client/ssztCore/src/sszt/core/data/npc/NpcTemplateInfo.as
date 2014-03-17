package sszt.core.data.npc
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneNpcCharacterActions;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.core.utils.ArrayUtil;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	
	public class NpcTemplateInfo extends MapElementInfo implements ICharacterInfo
	{
		public var name:String;
		public var funcName:String;
		public var dialog:String;
		public var picPath:String;
		public var iconPath:String;
		public var deploys:Array;
		public var sceneId:int;
		public var rndPoints:Array;
		public var picWidth:int = 50 ;
		public var picHeight:int = 135;
		
		public var frameRates:Dictionary = new Dictionary;
		
		public function NpcTemplateInfo()
		{
			deploys = [];
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			name = data.readUTF();
			funcName = data.readUTF();
			picPath = data.readUTF();
			iconPath = data.readUTF();
			dialog = data.readUTF();
			sceneId = data.readInt();
			setScenePos(data.readShort(),data.readShort());
			
			var deploys1:Array = ArrayUtil.trimStringArray(data.readUTF().split("|"));
			var deploysLen:int = deploys1.length;
			for(var i:int = 0; i < deploysLen; i++)
			{
				var deploy:DeployItemInfo = new DeployItemInfo();
				deploy.parseData(deploys1[i]);
				deploys.push(deploy);
			}
			picWidth = data.readInt();
			picHeight = data.readInt();
			var _frameRates:Array = data.readUTF().split("|");
			var _frameRates1:Array ; 
			for(var j:int = 0 ;  j< _frameRates.length ; ++j)
			{
				_frameRates1 = _frameRates[j].split(",");
				if(_frameRates1.length ==2)
					frameRates[_frameRates1[0]] =  _frameRates1[1];
			}
			
//			rndPoints = [];
//			var s:String = data.readUTF();
//			var tmp:Array = s.split("|");
//			for each(var st:String in tmp)
//			{
//				if(st != "")
//				{
//					var pr:Array = st.split(",");
//					var p:Point = new Point(int(pr[0]),int(pr[1]));
//					rndPoints.push(p);
//				}
//			}
//			
//			picWidth = data.readInt();
//			picHeight = data.readInt();
		}
		
		public function getAPoint():Point
		{
//			if(rndPoints.length > 0)
//			{
//				return rndPoints[int(Math.random() * rndPoints.length)];
//			}
			return new Point(sceneX,sceneY);
		}
		
		public function get characterId():uint
		{
			return templateId;
		}
		public function get style():Array
		{
			return [int(picPath)];
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
		public function getHideWeapon():Boolean { return false; }
		public function getHideSuit():Boolean{return false;}
		public function getWindStrength():int{return 0;}
		public function getMountsStrengthLevel():int{return 0;}
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return SceneNpcCharacterActions.STAND;
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
