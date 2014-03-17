package sszt.core.data.friendship
{
	import flash.utils.ByteArray;

	public class FriendshipTemplateInfo
	{
		
		
		public var level:int; //友好度等级
		public var amity:int; //友好度值
		public var totalAmity:int;//总友好度值
		public var name:String;//友好度等级名称
		public var awardData:String;//奖励
		public var awardTypeArray:Array=[];//奖励类型 1:攻击力
		public var awardValueArray:Array=[];//奖励值
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt()
			amity = data.readInt()
			totalAmity = data.readInt()
			name = data.readUTF();
			awardData = data.readUTF();
			var tempAwardArray:Array = awardData.split(",");
			if(tempAwardArray.length >= 2)
			{
				awardTypeArray.push(tempAwardArray[0]);
				awardValueArray.push(tempAwardArray[1]);
			}
		}
	}
}