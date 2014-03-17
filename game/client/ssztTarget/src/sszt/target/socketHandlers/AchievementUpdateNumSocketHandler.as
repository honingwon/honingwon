package sszt.target.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.target.TargetModule;
	import sszt.target.events.AchievementEvent;
	
	/**
	 * 更新当前成就和总成就点数 
	 * @author chendong
	 * 
	 */	
	public class AchievementUpdateNumSocketHandler extends BaseSocketHandler
	{
		public function AchievementUpdateNumSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.UPDATE_ACHIEVEMENT;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			
			var currentNum:int = _data.readInt(); //当前成就点数
			var totalNum:int = _data.readInt(); //总成就点数
			GlobalData.targetInfo.achCurrentNum = currentNum;
			GlobalData.targetInfo.achTotalNum = totalNum;
//			ModuleEventDispatcher.dispatchModuleEvent(new AchievementEvent(AchievementEvent.UPDATE_ACH_NUM,{currentNum:currentNum,totalNum:totalNum}));
			handComplete();
		}
		
		public function get targetModule():TargetModule
		{
			return _handlerData as TargetModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.UPDATE_ACHIEVEMENT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}