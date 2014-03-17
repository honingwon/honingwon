package sszt.socket
{
	import flash.utils.ByteArray;
	import sszt.constData.CommonConfig;
	import sszt.interfaces.socket.*;
	
	public class PackageIn extends ByteArray implements IPackageIn 
	{
		
		private var _code:int;
		private var _packageLen:int;
		private var _autoDecode:Boolean;
		
		public function PackageIn(src:ByteArray, len:int, autoDecode:Boolean=true)
		{
			super();
			var i:int;
			src.readBytes(this, 0, len);
			if (CommonConfig.protocolSeer > -1 && autoDecode){
				i = 0;
				while (i < length) {
					this[i] = (this[i] ^ CommonConfig.protocolSeer);
					i++;
				}
			}
			_packageLen = readShort() + 2;
			var isComplete:Boolean = readBoolean();
			_code = readShort();
//			trace("PackageIn:" + _code);
			if (isComplete){
				doUncompress();
			}
		}
		public function readNumber():Number
		{
			readShort();
			var t:Number = readShort();
			return (t << 8) * 0x0100 * 0x0100 * 0x0100 + readUnsignedInt();
		}
		public function readString():String
		{
			return readUTF();
		}
		public function readId():String
		{
			return readUTFBytes(32);
		}
		public function readDate64():Date
		{
			return new Date(readNumber());
		}
		public function readDate():Date
		{
			return new Date(Number(readInt()) * 1000);
		}
		public function get packageLen():int
		{
			return _packageLen;
		}
		public function get code():int
		{
			return _code;
		}
		public function doUncompress():void
		{
			var tmp:ByteArray;
			position = CommonConfig.PACKAGE_HEAD_SIZE;
			tmp = new ByteArray();
			readBytes(tmp, 0, (_packageLen - CommonConfig.PACKAGE_HEAD_SIZE));
			tmp.uncompress();
			position = CommonConfig.PACKAGE_HEAD_SIZE;
			writeBytes(tmp, 0, tmp.length);
			_packageLen = (CommonConfig.PACKAGE_HEAD_SIZE + tmp.length);
			position = CommonConfig.PACKAGE_HEAD_SIZE;
		}
		
	}
}