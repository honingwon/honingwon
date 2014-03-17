package sszt.core.data.furnace
{
	import flash.utils.ByteArray;

	public class CuiLianTemplateInfo
	{
		public var id:int;//武魂ID
		public var teamId:int;//分组ID
		public var place:int;//装备位置
		public var name:String;//名称
		public var level:int;//等级
		public var description:String;//描述
		public var needId:int//升级需要的道具ID
		public var needCount:int//升级需要的道具数量
		public var needExp:int;//升级需要的经验
		public var nextId:int;//下一级武魂ID
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			teamId = data.readInt();
			place = data.readInt();
			name = data.readUTF();
			level = data.readInt();
			description = data.readUTF();
			needId = data.readInt();
			needCount = data.readInt();
			needExp = data.readInt();
			nextId = data.readInt();
		}
	}
}