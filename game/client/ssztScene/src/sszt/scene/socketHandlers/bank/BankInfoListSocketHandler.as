package sszt.scene.socketHandlers.bank
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.bank.BankInfoItem;
	
	public class BankInfoListSocketHandler extends BaseSocketHandler
	{
		public function BankInfoListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var i:int=0;
			var type:int;
			var item:BankInfoItem;
			var itemDic:Dictionary = module.bankInfo.InfoDic;
			for(i;i<len;i++)
			{
				type = _data.readShort();
				item = itemDic[type];
				item.money = _data.readInt();
				item.state = _data.readInt();
				item.addTime = _data.readInt();
			}
			module.bankInfo.updateBankInfo();
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.BANK_LIST;
		}		
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BANK_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}