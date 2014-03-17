package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsQualityUpdateSocketHandler extends BaseSocketHandler
	{
		public function MountsQualityUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_QUALITY_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsQualitySuccess"));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsQualityFail"));
			}
			handComplete();
		}
		
		public static function send(mountsId:Number, useFu:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_QUALITY_UPDATE);
			pkg.writeNumber(mountsId);
			pkg.writeBoolean(useFu);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}