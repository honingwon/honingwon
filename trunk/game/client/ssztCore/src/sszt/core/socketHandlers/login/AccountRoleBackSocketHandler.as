package sszt.core.socketHandlers.login
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class AccountRoleBackSocketHandler extends BaseSocketHandler
	{
		public function AccountRoleBackSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACCOUNT_USERSLIST_RETURN;
		}
		
		override public function handlePackage():void
		{
			
		}
	}
}