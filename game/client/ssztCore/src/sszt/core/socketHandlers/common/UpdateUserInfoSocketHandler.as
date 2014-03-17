package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	
	public class UpdateUserInfoSocketHandler extends BaseSocketHandler
	{
		public function UpdateUserInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.UPDATE_USER_INFO;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.updateUserInfo(
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readNumber(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				_data.readInt(),
				0,
				0,
				_data.readInt()
			);
			handComplete();
		}
	}
}