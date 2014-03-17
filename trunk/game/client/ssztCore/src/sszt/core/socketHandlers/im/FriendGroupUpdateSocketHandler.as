package sszt.core.socketHandlers.im
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.im.GroupItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FriendGroupUpdateSocketHandler extends BaseSocketHandler
	{
		public function FriendGroupUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.FRIEND_GROUP_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var groupItem:GroupItemInfo = new GroupItemInfo();
			groupItem.gId  = _data.readNumber();
			if(_data.readBoolean())
			{
				groupItem.gName = _data.readString();
				if(GlobalData.imPlayList.getGroup(groupItem.gId))
				{
					GlobalData.imPlayList.reNameGroup(groupItem.gId,groupItem.gName);
				}else
				{
					GlobalData.imPlayList.addGroup(groupItem);
				}				
			}
			
			handComplete();
		}
		
		public static function sendUpate(gId:Number,name:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.FRIEND_GROUP_UPDATE);
			pkg.writeNumber(gId);
			pkg.writeString(name);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}