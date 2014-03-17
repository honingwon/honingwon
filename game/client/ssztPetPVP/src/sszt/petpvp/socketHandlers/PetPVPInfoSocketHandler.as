package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	
	public class PetPVPInfoSocketHandler extends BaseSocketHandler
	{
		public function PetPVPInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_INFO;
		}
		
		override public function handlePackage():void
		{
			var i:int;
			
			var myPetsInfo:Array = [];
			var myPetsLen:int = _data.readByte();
			var myPetItemInfo:PetPVPPetItemInfo;
			for(i = 0; i < myPetsLen; i++)
			{
				myPetItemInfo = new PetPVPPetItemInfo();
				myPetItemInfo.parseData(_data);
				myPetsInfo.push(myPetItemInfo);
			}
			
			var rankInfo:Array = [];
			var rankInfoLen:int = _data.readByte();
			var rankItemInfo:PetPVPPetItemInfo;
			for(i = 0; i < rankInfoLen; i++)
			{
				rankItemInfo = new PetPVPPetItemInfo();
				rankItemInfo.parseData(_data);
				rankInfo.push(rankItemInfo);
			}
			
			var logInfo:Array = [];
			var logInfoLen:int = _data.readByte();
			var logItemInfo:PetPVPLogItemInfo;
			for(i = 0; i < logInfoLen; i++)
			{
				logItemInfo = new PetPVPLogItemInfo();
				logItemInfo.parseData(_data);
				logInfo.push(logItemInfo);
			}
			
			var awardList:Array = [];
			var awardListLen:int = _data.readByte();
			var award:int;
			for(i = 0; i < awardListLen; i++)
			{
				award = _data.readInt();
				awardList.push(award);
			}
			
			var remainingTimes:int = _data.readInt();
			var totalTimes:int = _data.readInt();
			var lastTime:int = _data.readInt();
			var awardState:Boolean = _data.readBoolean();
			
			module.petPVPInfo.updateAll(myPetsInfo,rankInfo,logInfo,awardList,remainingTimes,totalTimes,lastTime,awardState);
			
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}