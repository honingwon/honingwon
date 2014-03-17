package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsExpUpdateSocketHandler extends BaseSocketHandler
	{
		public function MountsExpUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_EXP_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var mounts:MountsItemInfo = GlobalData.mountsList.getMountsById(id);
			mounts.updateExp(_data.readByte(),_data.readNumber());
			
			handComplete();
		}
	}
}