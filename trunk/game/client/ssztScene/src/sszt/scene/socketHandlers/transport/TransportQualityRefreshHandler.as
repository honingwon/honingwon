package sszt.scene.socketHandlers.transport
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TransportQualityRefreshHandler extends BaseSocketHandler
	{
		public function TransportQualityRefreshHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var quality:int = _data.readByte();
			sceneModule.facade.sendNotification(SceneMediatorEvent.SHOW_ACCEPT_TRANSPORT_PANEL,quality);
			var isSuc:int = _data.readByte();
			var copper:int = _data.readInt();
			if(isSuc)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.refreshTransportSuccess",copper));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.refreshTransportFail",copper));
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRANSPORT_QUALITY_REFRESH;
		}
		
		public static function send(isAutoRef:Boolean,quality:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRANSPORT_QUALITY_REFRESH);
			pkg.writeBoolean(isAutoRef);
			pkg.writeByte(quality);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
	}
}