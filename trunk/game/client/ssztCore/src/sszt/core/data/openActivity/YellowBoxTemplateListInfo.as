package sszt.core.data.openActivity
{
	import flash.utils.ByteArray;

	public class YellowBoxTemplateListInfo
	{
		public var id:int;
		public var types:int;//类型,0.每日礼包,1,每日年费礼包,2,豪华礼包,3升级礼包,4升级黄钻礼包,5,新手礼包
		public var level:int;//等级,每日礼包对应的黄钻等级,升级礼包对应人物等级
		public var awards_type:int;//奖励类型:0物品,1:属性
		public var awards:String;//黄钻奖励
		public var templateIdArray:Array=[]; //物品模板id数据
		public var templateNumArray:Array=[]; //物品模板数量数据
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			types = data.readInt();
			level = data.readInt();
			awards_type = data.readInt();
			awards = data.readUTF();
			var awardsArray:Array = awards.split("|");
			var awardsSub:Array;
			for(var i:int=0;i<awardsArray.length;i++)
			{
				awardsSub = awardsArray[i].toString().split(",");
				if(awardsSub.length >= 2)
				{
					templateIdArray.push(awardsSub[0]);
					templateNumArray.push(awardsSub[1]);
				}
			}
		}
	}
}