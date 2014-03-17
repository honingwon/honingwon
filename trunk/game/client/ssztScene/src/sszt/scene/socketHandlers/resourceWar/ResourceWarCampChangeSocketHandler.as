package sszt.scene.socketHandlers.resourceWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.ui.container.MAlert;
	
	public class ResourceWarCampChangeSocketHandler extends BaseSocketHandler
	{
		public function ResourceWarCampChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_RESOURCE_CAMP_CHANGE;
		}
		
		override public function handlePackage():void
		{
			var successful:Boolean = _data.readBoolean();
			var errorCode:int = _data.readInt();
			if(successful)
			{
				GlobalData.selfPlayer.updateCampType();
			}
			else
			{
				MAlert.show('errorCode' + errorCode)
			}
			
			handComplete();
		}
		
		public static function send(campType:int) : void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_RESOURCE_CAMP_CHANGE);
			pkg.writeInt(campType);
			GlobalAPI.socketManager.send(pkg);
		} 
	}
}