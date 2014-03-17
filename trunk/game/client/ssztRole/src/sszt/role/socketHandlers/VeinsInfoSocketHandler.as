package sszt.role.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.data.veins.VeinsInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.role.RoleModule;
	
	
	/**
	 * 获取其他玩家穴位信息
	 * */
	public class VeinsInfoSocketHandler extends BaseSocketHandler
	{
		public function VeinsInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VEINS_INFO;
		}
		
		override public function handlePackage():void
		{
			var userId:Number = _data.readNumber();
			var userRoleInfo:RoleInfo = roleModulel.roleInfoList[userId];
			var len:int = _data.readShort();
			for(var i:int = 0; i < len; i++)
			{
				var type:int = _data.readInt();	
				
				var veins:VeinsInfo = userRoleInfo.veins.getVeinsByAcupointType(type);
				
				var add:Boolean = false;
				if(veins == null)
				{
					veins = new VeinsInfo();
					veins.acupointType = type;
					add = true;
				}
				veins.acupointLv = _data.readInt();
				veins.genguLv = _data.readInt();
				veins.luck = _data.readInt();
				if(add)
				{
					userRoleInfo.veins.addVeins(veins);
				}
			}
			if(!userRoleInfo.veins.hasInit)
			{
				userRoleInfo.veins.hasInit = true;
				userRoleInfo.updateVeins();
			}	
			handComplete();
		}
		
		public function get roleModulel():RoleModule
		{
			return _handlerData as RoleModule;
		}
		
		public static function sendPlayerId(playerId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.VEINS_INFO);
			pkg.writeNumber(playerId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}