package sszt.socket
{
	import flash.utils.ByteArray;
	
	import sszt.constData.CommonConfig;
	import sszt.interfaces.socket.*;
	
	public class PackageOut extends ByteArray implements IPackageOut 
	{
		
		private var _code:int;
		private static var _index:int = 0;
		public function PackageOut(code:int)
		{
			_code = code;
			writeShort(0);
			writeByte(0);
//			trace(_index,CommonConfig.PROTOCOLKEY,_index^CommonConfig.PROTOCOLKEY);
			writeByte(_index^CommonConfig.PROTOCOLKEY);
			writeShort(code);
			_index++;
		}
		public function writeNumber(n:Number):void
		{
			var t:ByteArray = new ByteArray();
			t.writeUnsignedInt(int((n / 0xFFFFFFFF)));
			t.writeUnsignedInt(int(n));
			writeBytes(t);
			t = null;
		}
		public function writeString(str:String):void
		{
			if (str == null){
				writeShort(0);
				writeUTFBytes("");
			} else {
				writeUTF(str);
			};
		}
		public function get code():int
		{
			return (_code);
		}
		public function setPackageLen():void
		{
			var t:ByteArray = new ByteArray();
			t.writeShort((length - 2));
			this[0] = t[0];
			this[1] = t[1];
		}
		public function doCompress():void
		{
			var head:ByteArray;
			position = 0;
			head = new ByteArray();
			readBytes(head, 0, 6);
			position = 6;
			var tmp:ByteArray = new ByteArray();
			readBytes(tmp, 0, (length - 6));
			tmp.compress();
			length = 0;
			writeBytes(head);
			writeBytes(tmp);
			this[2] = 1;
		}
		public function writeDate(date:Date):void
		{
			writeInt(int((date.getTime() / 1000)));
		}
		
	}
}