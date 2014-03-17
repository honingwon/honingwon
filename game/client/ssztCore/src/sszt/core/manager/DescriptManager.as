package sszt.core.manager
{
	import flash.utils.Dictionary;
	
	public class DescriptManager 
	{
		
		private static var _words:Dictionary = new Dictionary();
		
		public static function setup(data:String):void
		{
			var s:String;
			var n:int;
			var name:String;
			var value:String;
			var t:String = data;
			data = data.split("\\n").join("\n");
			data = data.split("\\t").join("\t");
			var list:Array = data.split("\r\n");
			var nnnn:int = list.length;
			var i:int;
			while (i < nnnn) {
				s = list[i];
				if (s != ""){
					if (s.indexOf("//") != 0){
						n = s.indexOf(":");
						if (n != -1){
							name = s.substring(0, n);
							value = s.substr((n + 1));
							_words[name] = value;
						};
					};
				};
				i++;
			};
		}
		public static function getDescription(id:String):String
		{
			return _words[id] == null ? "" : _words[id];
		}
		
		public static function getWord(id:String, ..._args) : String
		{
			var i:int;
			var s:String = _words[id];
			if (s != null){
				if (_args.length > 0){
					i = 0;
					while (i < _args.length) {
						s = s.split((("{" + (i + 1)) + "}")).join(_args[i]);
						i++;
					};
				};
				return (s);
			};
			return ("");
		}
		
	}
}
