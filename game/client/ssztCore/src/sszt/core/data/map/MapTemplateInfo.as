package sszt.core.data.map
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class MapTemplateInfo
	{
		public var mapId:int;
		public var type:int;
		public var name:String;
		public var music:int;
		public var minLevel:int;
		public var maxLevel:int;
		//地图索引
		public var mapIndex:int;
		/**
		 * 地图是否已开通
		 * 0:未开通
		 * 1:已开通
		 */
		public var isOpen:Boolean;
		//默认跳转点
		public var defalutPoint:Point;
		
		public var mapPath:String;
		
		public var areaList:Array;
		/**
		 * 安全区
		 */		
		public var safeList:Array;
		/**
		 * 挂机路线
		 */		
		public var attackPath:Array;
		
		public function MapTemplateInfo()
		{
			areaList = [];
			safeList = [];
			attackPath = [];
		}
		
		public function parseData(data:ByteArray):void
		{
			mapId = data.readInt();
			mapPath = String(data.readInt());
			type = data.readByte();
			name = data.readUTF();
			var requireMent:Array = data.readUTF().split("|");
			if(requireMent.length == 2)
			{
				minLevel = requireMent[0].split(",")[1];
				maxLevel = requireMent[1].split(",")[1];
			}
			music = data.readInt();
			
			
			mapIndex = data.readInt();
			isOpen = data.readBoolean();
			var arr:Array = data.readUTF().split(",");
			if(arr.length == 2)
				defalutPoint = new Point(int(arr[0]),int(arr[1]));
			
			var str:String = data.readUTF();
			if(str != "")
			{
				var path:Array = str.split("|");
				for(var i:int = 0; i < path.length; i++)
				{
					var s:Array = path[i].split(",");
					attackPath.push(new Point(s[0],s[1]));
				}
			}
			
		}
		
	}
}
