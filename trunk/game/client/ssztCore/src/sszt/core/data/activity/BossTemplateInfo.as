package sszt.core.data.activity
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import sszt.constData.BossType;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;

	public class BossTemplateInfo
	{
		public var id:int;
		
		/**
		 * 0 固定间隔时间刷新, 1 固定时间点刷新
		 */
		public var type:int;
		
		/**
		 * boss所在地图
		 */
		public var mapId:int;
		
		/**
		 * 间隔时间刷新类boss刷新间隔时间
		 */
		public var interval:int;
		
		/**
		 * 固定时间点刷新类boss刷新时间点组
		 */
		public var constant:Array;
		
		public var name:String;
		
		public var level:int;
		
		public var description:String;
		
		public var drop:Array;
		
		/**
		 * boss重生位置
		 */
		public var relivePositions:Array = new Array();
		
		/**
		 * 传送能够到达的地图，间隔时间刷新类boss为boss所在地图，固定时间点刷新类boss为boss地图入口传送门所在的地图
		 */
		public var transportMapId:int;
		
		/**
		 * 传送能够到达的地图点，间隔时间刷新类boss为boss的重生点，固定时间点刷新类boss为boss地图入口传送门所在的点
		 */
		public var transportPosition:Point;
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			type = data.readInt();
			mapId = data.readInt();
			interval = data.readInt();
			constant = data.readUTF().split(",");
			name = data.readUTF();
			level = data.readInt();
			description = data.readUTF();
			drop = data.readUTF().split("|");
			var relivePositionsStr:Array = data.readUTF().split('|');
			var transportPositionXY:Array = data.readUTF().split(',');
			if(transportPositionXY.length == 1)
			{
				transportPositionXY = null;
			}
			
			var relivePositionXY:Array;
			var point:Point;
			for(var i:int = 0; i < relivePositionsStr.length; i++)
			{
				relivePositionXY = (relivePositionsStr[i] as String).split(',');
				point = new Point(int(relivePositionXY[0]), int(relivePositionXY[1]));
				relivePositions.push(point);
			}
			
			if(type == BossType.INTERVAL)
			{
				transportMapId = mapId;
				if(!transportPositionXY)
					transportPosition = relivePositions[0];
				else
					transportPosition = new Point(transportPositionXY[0], transportPositionXY[1]);
			}
			else
			{
				var door:DoorTemplateInfo = DoorTemplateList.getDoorByNextMapId(mapId)[0];
				transportMapId = door.mapId;
				transportPosition = new Point(transportPositionXY[0], transportPositionXY[1]);
			}
		}
	}
}