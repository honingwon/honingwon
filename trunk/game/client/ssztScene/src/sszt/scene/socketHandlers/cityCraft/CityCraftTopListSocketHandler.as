package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.cityCraft.CityCraftRankItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CityCraftTopListSocketHandler extends BaseSocketHandler
	{
		public function CityCraftTopListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var HP:int  = _data.readInt();
			var myPoint:int = _data.readShort();
			var myCamp:int = _data.readByte();
			var len:int = _data.readShort();
			var i:int=0;
			var rank:CityCraftRankItemInfo;
			var rankList:Array = [];
			for(i;i<len;i++)
			{
				rank = new CityCraftRankItemInfo();
				rank.nick = _data.readUTF();
				rank.point = _data.readShort();
				rank.camp = _data.readByte();
				rankList.push(rank);
			}
			GlobalData.cityCraftInfo.updateTopList(HP,myPoint,myCamp,rankList);
//			var sceneModule:SceneModule = _handlerData as SceneModule;
//			sceneModule.cityCraftPanel.updateRankList(HP,myPoint,myCamp,rankList);
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_TOP_LIST;
		}		
	}
}