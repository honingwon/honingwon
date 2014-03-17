package sszt.core.data.furnace
{
	import flash.utils.ByteArray;

	public class LuckComposeTemplateInfo
	{
//		public var materialTemplateId:int; //原始橙装ID
//		public var targetTempId:int;		//目标橙装ID
//		public var needCount:int;			//需求数量
//		public var copper:int;						//消耗铜币
		
		public var formulaId:int;
		public var type:int;
		public var bigType:int;
		public var createId:int;
		public var createAmount:int;
		public var successRate:int;
		public var copper:int;
		public var material:Array = [];
		
		public function parseData(argData:ByteArray):void
		{
			formulaId = argData.readInt();
			type = argData.readInt();
			bigType = argData.readInt();
			createId = argData.readInt();
			createAmount = argData.readInt();
			successRate = argData.readInt();
			copper = argData.readInt();
			for(var i:int = 0; i < 6; i++)//目前只支持6个材料的合成
			{
				var id:int = argData.readInt();
				var num:int = argData.readInt();
				if(id > 0 && num > 0)
					material.push({id:id,num:num});
			}
		}
	}
}