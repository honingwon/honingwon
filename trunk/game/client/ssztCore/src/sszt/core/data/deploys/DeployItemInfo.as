package sszt.core.data.deploys
{
	import flash.utils.ByteArray;

	public class DeployItemInfo
	{
		/**
		 * 类型
		 */		
		public var type:int;
		/**
		 * 描述
		 */		
		public var descript:String;
		/**
		 * 参数
		 */		
		public var param1:Number;
		public var param2:Number;
		public var param3:Number;
		public var param4:Number;
		public var formatIndex:int;//保存文字对应的format在list中的index值 目前只在DeployEventType.ITEMTIP中使用
		/**
		 * 随机参数
		 */		
		public var param:Object;
		
		public function DeployItemInfo()
		{
		}
		
		public function parseData(data:String):void
		{
			var array:Array = data.split("$");
			type = array[0];
			descript = array[1];
			param1 = array[2];
			param2 = array[3];
			param3 = array[4];
			param4 = array[5];
		}
	}
}