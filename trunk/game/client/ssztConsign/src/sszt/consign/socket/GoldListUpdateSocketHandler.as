package sszt.consign.socket
{
	import sszt.consign.ConsignModule;
	import sszt.consign.data.GoldConsignItem;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GoldListUpdateSocketHandler extends BaseSocketHandler
	{
		public function GoldListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_YUANBAO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			for(var i:int = 0;i<len;i++)
			{
				var listId:Number = _data.readNumber();
				var isExit:Boolean = _data.readBoolean();
				if(!isExit)
				{
					module.goldConsignInfo.removeItem(listId);	
				}else
				{
					var item:GoldConsignItem = module.goldConsignInfo.getItem(listId);
					if(item)
					{
						item.update(_data.readInt(),_data.readInt(),_data.readInt());
					}else
					{
						item = new GoldConsignItem(listId,_data.readInt(),_data.readInt(),_data.readInt());
						module.goldConsignInfo.addItem(item);
					}
				}
			}
		}
		
		public static function sendYuanbaoListQuery():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_YUANBAO_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get module():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
	}
}