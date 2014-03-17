package sszt.core.socketHandlers.entrustment
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.entrustment.EntrustmentItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class StartEntrustingSocketHandler extends BaseSocketHandler
	{
		public function StartEntrustingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.START_ENTRUSTING;
		}
		
		override public function handlePackage():void
		{
			var info:EntrustmentItemInfo = new EntrustmentItemInfo();
			info.templateId = _data.readInt();
			info.count= _data.readInt();
			info.pillItemTemplateId = _data.readInt();
			info.endTime = _data.readInt();
			GlobalData.entrustmentInfo.currentEntrustment = info;
			
			GlobalData.entrustmentInfo.isInEntrusting = true;
//			QuickTips.show('开始神游...');
			handComplete();
		}
		
		public static function send(entrustmentTemplateId:int,times:int,pillItemTemplateId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.START_ENTRUSTING);
			pkg.writeInt(entrustmentTemplateId);
			pkg.writeInt(times);
			pkg.writeInt(pillItemTemplateId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}