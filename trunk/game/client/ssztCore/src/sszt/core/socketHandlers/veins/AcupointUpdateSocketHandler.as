package sszt.core.socketHandlers.veins
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.veins.VeinsInfo;
	import sszt.core.data.veins.VeinsListUpdateEvent;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class AcupointUpdateSocketHandler extends BaseSocketHandler
	{
		public function AcupointUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VEINS_ACUPOINT_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var acupointType:int = _data.readInt();
//			GlobalData.veinsInfo.veinsAcupointUping = acupointType;			
			var veins:VeinsInfo = GlobalData.veinsInfo.getVeinsByAcupointType(acupointType);
			var add:Boolean = false;
			if(veins == null)
			{
				veins = new VeinsInfo();
				veins.acupointType = acupointType;
				add = true;
			}
			veins.acupointLv = _data.readInt();
			var cdTime:Number = _data.readNumber();
			if(cdTime > 0)
			{
				GlobalData.veinsInfo.veinsAcupointUping = acupointType;
				veins.isUping = true;				
			}
			else
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.VEINS_UPGRADE));
				GlobalData.veinsInfo.veinsAcupointUping = 0;
				veins.isUping = false;
			}
			GlobalData.veinsInfo.veinsCD = cdTime;
			if(add)
			{
				GlobalData.veinsInfo.addVeins(veins);
			}
			else
			{
				GlobalData.veinsInfo.dataUpdate(VeinsListUpdateEvent.UPDATE_VEINS, acupointType);
			}
			
			
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.VEINS_ACUPOINT_UPDATE);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}