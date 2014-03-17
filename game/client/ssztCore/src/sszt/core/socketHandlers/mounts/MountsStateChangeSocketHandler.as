package sszt.core.socketHandlers.mounts
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsStateChangeSocketHandler extends BaseSocketHandler
	{
		public function MountsStateChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_STATE_CHANGE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readByte();
			for(var i:int = 0; i < len; i++)
			{
				var id:Number = _data.readNumber();
				var mounts:MountsItemInfo = GlobalData.mountsList.getMountsById(id);
				mounts.changeState(_data.readByte());
			}
			handComplete();
		}
		
		public static function send(id:Number,state:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_STATE_CHANGE);
			pkg.writeNumber(id);
			pkg.writeByte(state);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}