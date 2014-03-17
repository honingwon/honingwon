package sszt.socket
{
	import flash.utils.ByteArray;
	
	public class ByteUtils 
	{
		
		public static function ToHexDump(description:String, dump:ByteArray, start:int, count:int):String
		{
			var text:String;
			var hex:String;
			var j:int;
			var val:Number;
			var hexDump:String = "";
			if (description != null){
				hexDump = (hexDump + description);
				hexDump = (hexDump + "\n");
			}
			var end:int = (start + count);
			var i:int = start;
			while (i < end) 
			{
				text = "";
				hex = "";
				j = 0;
				while (j < 16) 
				{
					if ((j + i) < end){
						val = dump[(j + i)];
						if (val < 16)
						{
							hex = (hex + (("0" + val.toString(16)) + " "));
						} 
						else {
							hex = (hex + (val.toString(16) + " "));
						}
						if (val >= 32 && val <= 127)
						{
							text = text + String.fromCharCode(val);
						} 
						else {
							text = text + ".";
						}
					} 
					else {
						hex = hex + "   ";
						text = text + " ";
					}
					j++;
				}
				hex = hex + "  ";
				hex = hex + text;
				hex = hex + "\n";
				hexDump = hexDump + hex;
				i = i + 16;
			}
			return hexDump;
		}
		
	}
}