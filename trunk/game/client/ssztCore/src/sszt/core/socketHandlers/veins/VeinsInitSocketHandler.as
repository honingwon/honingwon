package sszt.core.socketHandlers.veins
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.veins.VeinsInfo;
	import sszt.core.data.veins.VeinsListUpdateEvent;
	import sszt.core.socketHandlers.BaseSocketHandler;


	/**
	 * 穴位信息初始化，只收不发。
	 * */
	public class VeinsInitSocketHandler extends BaseSocketHandler
	{
		public function VeinsInitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VEINS_INIT;
		}
		
		override public function handlePackage():void
		{
			var cd:Number = _data.readNumber();
			var acupontType:int = _data.readInt();
			GlobalData.veinsInfo.veinsCD = cd;
			GlobalData.veinsInfo.veinsAcupointUping = acupontType;
			var len:int = _data.readShort();
			for(var i:int = 0; i < len; i++)
			{
				var type:int = _data.readInt();	
				
				var veins:VeinsInfo = GlobalData.veinsInfo.getVeinsByAcupointType(type);
				
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
				if(acupontType == type)
					veins.isUping = true;
				if(add)
				{
					GlobalData.veinsInfo.addVeins(veins);
				}
//				else
//				{
//					veins.dataUpdate();
//				}
				
			}
			if(!GlobalData.veinsInfo.hasInit)
			{
				GlobalData.veinsInfo.hasInit = true;
//				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.VEINS_REFRESH));
				GlobalData.veinsInfo.dataUpdate(VeinsListUpdateEvent.REFASH_VEINS);
			}			
			handComplete();
		}
	}
}