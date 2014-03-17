package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.marriage.MarriageModule;
	import sszt.marriage.data.MarriageRelationItemInfo;
	import sszt.marriage.data.MarriageRelationList;
	
	public class DivorceSocketHandler extends BaseSocketHandler
	{
		public function DivorceSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.DIVORCE;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			var marryId:Number = _data.readNumber();
//			module.marriageRelationList.divorce(marryId);
			if(success)
			{
				MarriageRelationListSocketHandler.send();
			}
			handComplete();
		}
		
		public function get module():MarriageModule
		{
			return _handlerData as MarriageModule;
		}
		
		/**
		 * @param type 1普通，2强制收费		
		 * */
		public static function send(marryId:Number,type:int = 2):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.DIVORCE);
			pkg.writeNumber(marryId);
			pkg.writeShort(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}