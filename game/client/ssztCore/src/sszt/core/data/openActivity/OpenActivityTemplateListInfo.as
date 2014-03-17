package sszt.core.data.openActivity
{
	import flash.utils.ByteArray;

	public class OpenActivityTemplateListInfo
	{
		public var id:int //编号
		public var group_id:int //活动组编号1:首充2:开服充值,3:开服消费
		public var is_open:int//是否开放
		public var type:int//活动类型0:充值,1:消耗
		public var time_type:int//活动时间类型0:具体时间,1:开服之后几天,
		public var open_time:String//开放时间
		public var start_time:int//活动开始时间
		public var end_time:int//活动结束时间
		public var need_num:int//活动充值/消耗数量
		public var item:int//活动奖励
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			group_id = data.readInt();
			is_open = data.readInt();
			type = data.readInt();
			time_type = data.readInt();
			open_time = data.readUTF();
			start_time = data.readInt();
			end_time = data.readInt();
			need_num = data.readInt();
			item = data.readInt();
		}
	}
}