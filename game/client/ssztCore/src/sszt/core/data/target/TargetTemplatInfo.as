package sszt.core.data.target
{
	import flash.utils.ByteArray;

	public class TargetTemplatInfo
	{
		/**
		 * 编号 
		 */		
		public var target_id:int;
		
		/**
		 * 成就图片编号 
		 */
		public var pic:int;
		
		/**
		 * 类型 0:目标,1:成就
		 */
		public var type:int;
		
		/**
		 * 0:目标类型 
		 * 1:成就类型 
		 */		
		public var taclass:int;
		
		/**
		 *标题
		 */
		public var title:String;
		
		/**
		 *内容 
		 */
		public var content:String;
		
		/**
		 * 提示 
		 */
		public var tip:String;
		
		/**
		 * 目标奖励 物品id
		 */
		public var awardsId:int;
		
		/**
		 * 目标奖励 物品数量
		 */
		public var awardsNum:int;
		
		/**
		 * 成就奖励 绑定元宝 
		 */
		public var bindYuanbao:int;
		
		/**
		 * 成就奖励 奖励成就值
		 */
		public var achievement:int;
		
		/**
		 * 成就奖励 属性奖励
		 */
		public var attribute:int;
		
		/**
		 * 成就目标总数 
		 */
		public var totalNum:int;
		
		
		public function parseData(data:ByteArray):void
		{
			target_id = data.readInt();
			pic = data.readInt();
			type = data.readInt();
			taclass = data.readInt();
			title = data.readUTF();
			content = data.readUTF();
			tip = data.readUTF();
			var awards:String = data.readUTF();
			if(awards != '0')
			{
				var itemInfoList:Array = awards.split(",");
				if(itemInfoList.length == 2)
				{
					awardsId = int(itemInfoList[0]);
					awardsNum = int(itemInfoList[1]);
				} 
			}
			totalNum = data.readInt();
			bindYuanbao = data.readInt();
			achievement = data.readInt();
			attribute = data.readInt();
		}
	}
}