package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsAttUpdateSocketHandler extends BaseSocketHandler
	{
		public function MountsAttUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_ATT_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var mounts:MountsItemInfo = GlobalData.mountsList.getMountsById(id);

			mounts.diamond = _data.readByte();
			mounts.star = _data.readByte();
			mounts.stairs = _data.readByte();
			mounts.grow = _data.readByte();
			mounts.quality = _data.readByte();
			
				
			PackageUtil.parseMountsProperty(mounts,_data);
			mounts.update();
			
			
			handComplete();
		}
		
	
	}
}