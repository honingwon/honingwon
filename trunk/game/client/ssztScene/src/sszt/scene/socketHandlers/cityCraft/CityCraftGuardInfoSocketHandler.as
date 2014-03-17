package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.cityCraft.CityCraftGuardItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftGuardInfoSocketHandler extends BaseSocketHandler
	{
		public function CityCraftGuardInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readByte();
			var i:int =0;
			var item:CityCraftGuardItemInfo;
			var list:Array = new Array();
			for(;i<len;i++)
			{
				item = new CityCraftGuardItemInfo();
				item.position = _data.readByte();
				item.type = _data.readByte();
				list.push(item);
			}
			GlobalData.cityCraftInfo.updateGuardList(list);
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_GUARD_INFO;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_GUARD_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}