package sszt.core.socketHandlers.scene
{
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.changeInfos.ToSceneData;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	
	public class MapEnterSocketHandler extends BaseSocketHandler
	{
		public function MapEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_ENTER;
		}
		
		override public function handlePackage():void
		{			
			var mapId:int = _data.readInt();
			if(mapId != 0)
			{
				var toScene:ToSceneData = new ToSceneData();
				toScene.id = mapId;
				toScene.bornX = _data.readInt();
				toScene.bornY = _data.readInt();
				SetModuleUtils.setToScene(toScene);
				
				ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.CLOSE_NPCTASKPANEL));
			}
			
			handComplete();
		}
		
		public static function sendMapEnter(doorId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MAP_ENTER);
			pkg.writeInt(doorId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}