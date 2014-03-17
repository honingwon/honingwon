package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class TradeItemAddSocketHandler extends BaseSocketHandler
	{
		public function TradeItemAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_ITEM_ADD;
		}
		
		override public function handlePackage():void
		{
			if(_data.readByte() == 1)
			{
//				_data.readInt();
//				_data.readNumber();
				var place:int = _data.readInt();
				sceneModule.sceneInfo.tradeDirectInfo.addSelfItem(place);
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		/**
		 * 
		 * @param playerId 对方ID
		 * @param place
		 * 
		 */		
		public static function sendItemAdd(playerId:Number,place:int = 0):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRADE_ITEM_ADD);
			pkg.writeInt(1);
			pkg.writeNumber(playerId);
			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}