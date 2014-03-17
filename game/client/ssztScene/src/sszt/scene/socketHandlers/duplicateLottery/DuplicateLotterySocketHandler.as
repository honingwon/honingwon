package sszt.scene.socketHandlers.duplicateLottery
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class DuplicateLotterySocketHandler extends BaseSocketHandler
	{
		public function DuplicateLotterySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_LOTTERY;
		}
		
		override public function handlePackage():void
		{
			var duplicateId:int = _data.readInt();
			var itemId:int = _data.readInt();
			var itemCount:int = _data.readInt();
			if(!itemId && !itemCount)//代表副本奖励可抽取
			{
				sceneModule.facade.sendNotification(SceneMediatorEvent.DUPLICATE_LOTTERY_ATTENTIION);
			}
			else//副本奖励已经抽取
			{
				if(sceneModule.duplicateLotteryPanel)
				{
					var itemInfo:ItemInfo = new ItemInfo();
					itemInfo.templateId = itemId;
					itemInfo.count = itemCount;
					sceneModule.duplicateLotteryPanel.getResult(itemInfo);
				}
			}
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_LOTTERY);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}