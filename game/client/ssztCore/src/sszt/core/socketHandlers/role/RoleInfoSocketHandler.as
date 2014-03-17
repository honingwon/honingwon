package sszt.core.socketHandlers.role
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class RoleInfoSocketHandler extends BaseSocketHandler
	{
		public function RoleInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_INFO;
		}
		
		override public function handlePackage():void
		{
			var tmpRoleInfo:RoleInfo = new RoleInfo();
			var tmpPlayerInfo:DetailPlayerInfo = new DetailPlayerInfo();
			var tmpEquipList:Array = new Array(RoleInfo.EQUIP_SIZE);
			
			tmpPlayerInfo.userId = _data.readNumber();
			PackageUtil.readDetailPlayer(tmpPlayerInfo,_data);
			var length:int = _data.readInt();
			for(var i:int = 0;i<length;i++)
			{
				var itemInfo:ItemInfo = new ItemInfo();
				itemInfo.place = _data.readInt();
				PackageUtil.readItem(itemInfo,_data);
				tmpEquipList.push(itemInfo);
			}
			
			tmpRoleInfo.equipList = tmpEquipList;
			tmpRoleInfo.playerInfo = tmpPlayerInfo;
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.ROLEINFO_UPDATE,tmpRoleInfo));
			
			handComplete();
		}
		
		public static function sendPlayerId(playerId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_INFO);
			pkg.writeNumber(playerId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}