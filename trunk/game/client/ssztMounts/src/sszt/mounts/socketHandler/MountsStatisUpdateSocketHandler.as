package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsStatisUpdateSocketHandler extends BaseSocketHandler
	{
		public function MountsStatisUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_STAIRS_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsStatisSuccess"));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsStatisFail"));
			}
			handComplete();
		}
		
		public static function send(mountsId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_STAIRS_UPDATE);
			pkg.writeNumber(mountsId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}