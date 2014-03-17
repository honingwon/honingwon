package 
{
	import flash.utils.ByteArray;

	public class WordFilter
	{
		/**
		 * 聊天非法词
		 */		
		public var chatFilterWords:Array = [];
		/**
		 * 注册非法词
		 */		
		public var nameFilterWords:Array = [];
		/**
		 * 非法字符
		 */		
		public var filterChars:Array = ["#","@","%",":","/","\\",",","'","<",">"];
		
		
		public function setup(data:Array = null):void
		{
			if(data == null)return;
			if(data.length == 0)return;
			nameFilterWords = String(data[0]).split(",");
			chatFilterWords = String(data[1]).split(",");
			var t:Array = chatFilterWords;
			if(nameFilterWords[nameFilterWords.length - 1] == null)nameFilterWords.splice(nameFilterWords.length - 1,1);
			if(chatFilterWords[chatFilterWords.length - 1] == null)chatFilterWords.splice(chatFilterWords.length - 1,1);
		}
		
		/**
		 * 检测字符串
		 * @param str
		 * @return 
		 * 
		 */		
		public function checkNameAllow(str:String):Boolean
		{
			var i:int;
			for(i = 0; i < chatFilterWords.length; i++)
			{
				if(chatFilterWords[i] != "")
					if(str.indexOf(chatFilterWords[i]) > -1)
						return false;
			}
			for(i = 0; i < nameFilterWords.length; i++)
			{
				if(nameFilterWords[i] != "")
					if(str.indexOf(nameFilterWords[i]) > -1)
						return false;
			}
			for(i = 0; i < filterChars.length; i ++)
			{
				if(str.indexOf(filterChars[i]) > -1)
					return false;
			}
			return true;
		}
		
		public function checkLen(str:String):int
		{
			var result:int = 0;
			for(var i:int = 0; i < str.length; i++)
			{
				var b:ByteArray = new ByteArray();
				b.writeUTFBytes(str.charAt(i));
				if(b.length == 1)result++;
				else result += 2;
			}
			return result;
		}
	}
}
