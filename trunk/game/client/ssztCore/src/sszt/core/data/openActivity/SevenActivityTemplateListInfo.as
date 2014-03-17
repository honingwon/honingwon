package sszt.core.data.openActivity
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;

	public class SevenActivityTemplateListInfo
	{
		public var id:int; //编号
		public var title:String; //标题
		public var content:String; //内容
		public var rewardFirstThreeDic:Dictionary = new Dictionary();//第1-3名物品奖励   [名次+职业]
		public var item:int; //全民奖励
		public var count:int;//全民奖励的数量
		public var end_time:int;//结束时间
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			title = data.readUTF();
			content = data.readUTF();
			
			var rewardFirstThreeStr:String = data.readUTF();
			var rewardFirstThreeArr:Array = rewardFirstThreeStr.split("|");
			var rewardFirstThreeItemStr:String;
			var rewardFirstThreeItemArr:Array;
			for(var i:int = 0; i < rewardFirstThreeArr.length; i++)
			{
				rewardFirstThreeItemStr = rewardFirstThreeArr[i];
				rewardFirstThreeItemArr = rewardFirstThreeItemStr.split(",");
				rewardFirstThreeDic[(rewardFirstThreeItemArr[0]+rewardFirstThreeItemArr[1])] = rewardFirstThreeItemArr[2];
			}
			
			item = data.readInt();
			count = data.readInt();
			end_time = data.readInt();
		}
	}
}