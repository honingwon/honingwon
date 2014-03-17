package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class FriendGetListSocketHandler extends BaseSocketHandler
	{
		public function FriendGetListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_GET_LIST;
		}
		
		override public function handlePackage():void
		{
			GlobalData.imPlayList.loadData(_data);
			
			handComplete();
		}
	}
}