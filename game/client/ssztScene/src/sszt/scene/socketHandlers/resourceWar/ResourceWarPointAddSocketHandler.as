package sszt.scene.socketHandlers.resourceWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class ResourceWarPointAddSocketHandler extends BaseSocketHandler
	{
		public function ResourceWarPointAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_RESOURCE_POINT_ADD;
		}
		
		override public function handlePackage():void
		{
			var addedPoint:int = _data.readInt();
			if(addedPoint > 0)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.resourceWar.pointAdd',addedPoint));
			}
			var collectPoint:int = _data.readInt();//采集
			var killPoint:int  = _data.readInt();//击杀
			var combo:int = _data.readInt();
			var totalPoint:int = collectPoint + killPoint;
			module.resourceWarInfo.updateMyPoint(totalPoint, collectPoint, killPoint,combo);
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send() : void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_RESOURCE_POINT_ADD);
			GlobalAPI.socketManager.send(pkg);
		} 
	}
}