package sszt.core.data.copy
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class CopyTemplateItem
	{
		public var id:int;
		public var name:String;
		public var descript:String;
		public var dayTimes:int;
		public var npcId:int;
		public var recommend:int;              //推荐度
		public var type:int;                  //副本刷怪类型
		public var showType:int;              //显示类型
		public var minLevel:int;
		public var maxLevel:int;
		public var minPlayer:int;
		public var maxPlayer:int;
		public var needYuanBao:int;
		public var needBindYuanBao:int;
		public var needCopper:int;
		public var needBindCopper:int;
		public var needItemId:int;
		public var countTime:int;
		public var mission:Array;
		public var award:Array;
		public var isDynamic:Boolean;         //是否动态副本
		public var taskId:int;               //前置任务
		public var isShowInActivity:Boolean; //是否显示在活动界面
		public var recommendValue:Array;	  //推荐战斗力等信息
		
		public function CopyTemplateItem()
		{
			super();
			recommendValue = [];
		}
		
		public function parseDate(data:ByteArray):void
		{
			id = data.readInt();
			name = data.readUTF();
			descript = data.readUTF();
			dayTimes = data.readShort();
			npcId = data.readInt();
			recommend = data.readShort();
			type = data.readShort();
			showType = data.readShort();
			minLevel = data.readShort();
			maxLevel = data.readShort();
			minPlayer = data.readShort();
			maxPlayer = data.readShort();
			needYuanBao = data.readInt();
			needBindYuanBao = data.readInt();
			needCopper = data.readInt();
			needBindCopper = data.readInt();
			needItemId = data.readInt();
			countTime = data.readInt();
			mission = data.readUTF().split(",");
			award = data.readUTF().split(",");	
			isDynamic = data.readBoolean();
			taskId = data.readInt();
			isShowInActivity = data.readBoolean();
			var temp:Array = data.readUTF().split("|");	
			for(var i:int = 0; i < temp.length; i++)
			{
				var temp1:Array = temp[i].split(",");
				recommendValue.push(temp1);
			}
		}
	}
}