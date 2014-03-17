package sszt.core.utils
{
	import flash.utils.ByteArray;

	public class WordFilterUtils
	{
		/**
		 * 聊天非法词
		 */		
		public static var chatFilterWords:Array = [];
		/**
		 * 注册非法词
		 */		
		public static var nameFilterWords:Array = [];
		/**
		 * 非法字符
		 */		
		public static var filterChars:Array = ["#","@","%",":","/","\\",",","'","<",">"];
		/**
		 * 替换字符
		 */		
//		private static var REPLACECHARS:Array = ["!","@","#","$","%","^","&","*"];
		private static var REPLACECHARS:Array = ["*"];
		/**
		 * 聊天过滤字符
		 */		
		private static var chatFilters:Array = ["&","<",">","\'","\"","\r","\n"];
		/**
		 * 聊天替换字符
		 */		
		private static var chatReplaces:Array = ["&amp;","&lt;","&gt;","&ldquo;","&rdquo;","",""];
		
//		private static var regs:Array = [
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(出.*?售)/ig),data:0.5},
//			{reg:new RegExp(/(销.*?售)/ig),data:0.5},
//			{reg:new RegExp(/(经.*?销)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5},
//			{reg:new RegExp(/(元.*?宝)/ig),data:0.5}
//		];
		
		
		public static function setup(data:Array = null):void
		{
			if(data == null)return;
			if(data.length == 0)return;
			nameFilterWords = String(data[0]).split(",");
			chatFilterWords = String(data[1]).split(",");
			var t:Array = chatFilterWords;
			if(nameFilterWords[nameFilterWords.length - 1] == null)nameFilterWords.splice(nameFilterWords.length - 1,1);
			if(chatFilterWords[chatFilterWords.length - 1] == null)chatFilterWords.splice(chatFilterWords.length - 1,1);
		}
		
		private static function getReplaceWord(word:String):String
		{
			if(word == null)return "";
			var len:int = word.length;
			var replace:String = "";
			var replaceLen:int = REPLACECHARS.length;
			for(var i:int = 0; i < len; i++)
			{
				replace += REPLACECHARS[int(Math.random() * replaceLen)];
			}
			return replace;
		}
		
		/**
		 * 过滤替换非法字符
		 * @param str
		 * @return 
		 * 
		 */		
		public static function filterWords(str:String):String
		{
			str = str.replace(/ /g,"");
			for(var i:int = 0; i < chatFilterWords.length; i++)
			{
				var arr:Array = str.split(chatFilterWords[i]);
				if(arr.length > 0)
				{
					str = arr.join(getReplaceWord(chatFilterWords[i]));
				}
			}
			return str;
		}
		
		/**
		 * 聊天过滤
		 * @param str
		 * @return 
		 * 
		 */		
		public static function filterChatWords(str:String):String
		{
			return str;
			str = str.replace(/ /g,"");
			str = filterWords(str);
			for(var i:int = 0; i < chatFilters.length; i++)
			{
				var arr:Array = str.split(chatFilters[i]);
				if(arr.length > 0)
					str = arr.join(chatReplaces[i]);
			}
			return str;
		}
		
		/**
		 * 检测字符串
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkNameAllow(str:String):Boolean
		{
			var i:int;
			str = str.replace(/ /g,"");
			for(i = 0; i < chatFilterWords.length; i++)
			{
				if(chatFilterWords[i] != "")
				{
					if(str.indexOf(chatFilterWords[i]) > -1)return false;
				}
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
		
		/**
		 * 检测字符串长度
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkLen(str:String):int
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
		
		/**
		 * 截取对应长度文本
		 * @param str
		 * @param len
		 * @return 
		 * 
		 */		
		public static function getLenString(str:String,len:int):String
		{
			var result:String = "";
			var current:int = 0;
			for(var i:int = 0; i < str.length; i++)
			{
				var b:ByteArray = new ByteArray();
				b.writeUTFBytes(str.charAt(i));
				if(b.length == 1)current++;
				else current += 2;
				if(current < len)
				{
					result += str.charAt(i);
				}
				else
				{
					break;
				}
			}
			return result;
		}
	}
}
