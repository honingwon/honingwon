package sszt.scene.data.copyIsland
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	
	public class CIKingInfo extends EventDispatcher
	{
		public var passTime:int;
		public var mapId:int;
//		public var styleList:Array;
		public var kingPos:Dictionary;
		public static var kingStageList:Array = [3,6,9,10,13,16,19,20,23,26,29,30];
		public var kingPosList:Array = [[new Point(1233,493),new Point(1454,492),new Point(1672,494)],
															[new Point(1031,726),new Point(1144,817),new Point(1291,888)],
															[new Point(641,1591),new Point(803,1592),new Point(961,1598)],
															[new Point(764,1205),new Point(951,1197),new Point(1133,1200)],
															[new Point(1233,493),new Point(1454,492),new Point(1672,494)],
															[new Point(934,959),new Point(1171,959),new Point(1408,959)],
															[new Point(535,1124),new Point(690,1224),new Point(845,1124)],
															[new Point(1205,938),new Point(1385,938),new Point(1575,938)],
															[new Point(427,577),new Point(596,577),new Point(770,574)],
															[new Point(324,559),new Point(748,559),new Point(534,559)],
															[new Point(1336,1275),new Point(1522,1279),new Point(1712,1281)],
															[new Point(474,497),new Point(677,497),new Point(867,497)],];
		public function CIKingInfo(target:IEventDispatcher=null)
		{
			super(target);
			kingPos = new Dictionary();
			initKingPos();
		}
		
		public function getKingPos(stage:int):CIKingPosInfo
		{
			return kingPos[stage];
		}
		
		public function initKingPos():void
		{
			var tmpInfo:CIKingPosInfo;
			for(var i:int = 0;i < kingStageList.length;i++)
			{
				tmpInfo = new CIKingPosInfo();
				tmpInfo.stageId = kingStageList[i];
				for(var j:int = 0;j < kingPosList[i].length;j++)
				{
					tmpInfo.pointList.push(kingPosList[i][j]);
				}
				kingPos[tmpInfo.stageId] = tmpInfo;
			}
		}
		
		public function updateKingTime():void
		{
			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_KINGTIME_UPDATE));
		}
			
	}
}