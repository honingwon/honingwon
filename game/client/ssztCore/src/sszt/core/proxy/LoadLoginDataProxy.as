package sszt.core.proxy
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.interfaces.loader.ILoader;
	
	public class LoadLoginDataProxy
	{
		public static function loadFriendData():void
		{
			var loader:ILoader = GlobalAPI.loaderAPI.createRequestLoader(GlobalAPI.pathManager.getWebServicePath("friendlist.ashx"),{u:GlobalData.selfPlayer.userId},loadFriendComplete);
			loader.loadSync();
		}
		private static function loadFriendComplete(loader:ILoader):void
		{
			var data:ByteArray = loader.getData() as ByteArray;
//			GlobalData.imPlayList.loadData(data);
		}
	}
}

//
//var loader:ILoader = GlobalAPI.loaderAPI.createRequestLoader(GlobalAPI.pathManager.getWebServicePath("friendlist.ashx"),null,loadComplete);
//loader.loadSync(); 
//function loadComplete(loader:ILoader):void
//{
//	var data:ByteArray = loader.getData() as ByteArray;
//	if(data.readBoolean())
//	{
//		data.readUTF();
//		var len:int = data.readInt();
//		for(var i:int = 0;i<len;i++)
//		{
//			var player:ImPlayerInfo = new ImPlayerInfo();
//			player.parseData(data);
//			if(player.friendState == ImPlayerType.FRIEND)
//			{
//				GlobalData.imPlayList.addFriend(player);
//			}else if(player.friendState == ImPlayerType.BLACK)
//			{
//				GlobalData.imPlayList.addBlack(player);
//			}
//		}
//	} 
//}