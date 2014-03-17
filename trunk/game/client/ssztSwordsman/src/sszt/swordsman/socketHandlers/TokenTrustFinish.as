package sszt.swordsman.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.SwordsmanModule;
	
	/**
	 * 立即完成江湖令任务 
	 * @author chendong
	 * 
	 */	
	public class TokenTrustFinish extends BaseSocketHandler
	{
		public function TokenTrustFinish(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TOKEN_TRUST_FINISH;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			if(_data.readBoolean())
			{
				//立即完成成功
				ModuleEventDispatcher.dispatchModuleEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.RIGHT_NOW_COMPLETE));
			}
			else
			{
				//失败
			}
		}
		
		public function get swordsmanModule():SwordsmanModule
		{
			return _handlerData as SwordsmanModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TOKEN_TRUST_FINISH);
			GlobalAPI.socketManager.send(pkg);
		}
		
	}
}