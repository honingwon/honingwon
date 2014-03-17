package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.marriage.MarriageModule;
	
	public class MarriageRelationChangeSocketHandler extends BaseSocketHandler
	{
		/**
		 * 妾变妻，之后妻自动变妾
		 * */
		public function MarriageRelationChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_CHANGE;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			var userId:Number = _data.readNumber();
			if(success)
			{
//				module.marriageRelationList.changeRelation(userId);
				MarriageRelationListSocketHandler.send();
			}
			handComplete();
		}
		
		public function get module():MarriageModule
		{
			return _handlerData as MarriageModule;
		}
		
		public static function send(userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MARRY_CHANGE);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}