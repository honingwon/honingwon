package sszt.core.data.scene
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import sszt.core.data.MapElementType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;

	public class DoorTemplateInfo extends MapElementInfo
	{
		public var mapId:int;
		public var nextMapId:int;
		public var toDoorId:int;
		
		public var rndPoints:Array;
		
		public function DoorTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			mapId = data.readInt();
			nextMapId = data.readInt();
			toDoorId = data.readInt();
			setScenePos(data.readShort(),data.readShort());
			
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
			return new Point(sceneX,sceneY);
		}
		
		/**
		 * 能否过去
		 * @return 
		 * 
		 */		
		public function canTo():Boolean
		{
			return true;
		}
		
		override public function getObjType():int
		{
			return MapElementType.DOOR;
		}
		
		
		public function getDoorName() : String
		{
//			if (DoorTemplateList.isCopyDoor(templateId))
//			{
//				return LanguageManager.getWord("ssztl.copy.CopyExitPoint");
//			}
			return MapTemplateList.list[this.nextMapId].name;
		}
		
	}
}