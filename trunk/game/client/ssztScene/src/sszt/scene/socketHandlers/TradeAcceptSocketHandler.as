package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TradeAcceptSocketHandler extends BaseSocketHandler
	{
		public function TradeAcceptSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_ACCEPT;
		}
		
		override public function handlePackage():void
		{
//			s >> c:
//			int:8 返回同意交易请求结果
//			0 => 主动拒绝
//				1 => 同意且成功
//				2 => 同意但失败(发起方离线)
//				3 => 同意但失败(发起方pk状态）
//					4 => 同意但失败(发起方交易中)
//					5 => 同意但失败(自己交易中)
//					6 => 同意但失败(自己pk状态) 
//					7 => 未知错误
			var result:int = _data.readByte();
			var id:int = 0;
			if(result != 0)
			{
				SetModuleUtils.addBag(); //打开背包面板
			}
			switch(result)
			{
				case 0:
					break;
				case 1:
//					id = _data.readNumber();  //发起方玩家id
//				    (_handlerData as SceneModule).facade.sendNotification(SceneMediatorEvent.SHOW_TRADEDIRECT,{id:id}); //打开交易面板
//					SetModuleUtils.addBag(); //打开背包面板
					break;
				case 2:
				    QuickTips.show(LanguageManager.getWord('ssztl.trade.offLine'));
					break;
				case 3:
					QuickTips.show(LanguageManager.getWord('ssztl.trade.inPK'));
					break;
				case 4:
					QuickTips.show(LanguageManager.getWord('ssztl.trade.inTrade'));
					break;
				case 5:
					QuickTips.show(LanguageManager.getWord('ssztl.trade.selfInTrade'));
					break;
				case 6:
					QuickTips.show(LanguageManager.getWord('ssztl.trade.selfInPK'));
					break;
				case 7:
					QuickTips.show(LanguageManager.getWord('ssztl.trade.onKonwError'));
					break;
			}
			
			handComplete();
		}
		
		public static function sendAccept(result:Boolean,id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRADE_ACCEPT);
			pkg.writeBoolean(result);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}