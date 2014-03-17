package sszt.core.socketHandlers.pay
{
	
	import com.adobe.serialization.json.JSON;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.events.ActivityEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class QQBugGoodsSocketHandler extends BaseSocketHandler
	{
		public function QQBugGoodsSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_QQ_BUY_GOODS;
		}
		
		override public function handlePackage():void
		{
			var res:String = _data.readString();
			var obj:Object = JSON.decode(res);
			JSUtils.dialogBuy(obj);
			
//			var id:int = _data.readShort(); // 各个活动id
//			var groupId:int = _data.readShort(); 
//			if(res)
//			{
//				var obj:Object= GlobalData.openActivityInfo.activityDic[groupId];
//				if(obj)
//				{
//					obj.idArray.push(id);
//				}
//					
//				ModuleEventDispatcher.dispatchModuleEvent(new ActivityEvent(ActivityEvent.GET_AWARD,{id:id}));
//			}
//			handComplete();
		}
		
		
		public static function send(zoneId:int,Domain:String,ShopItemId:int,ShopItemNum:int,openKey:String,pf:String,pfKey:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_QQ_BUY_GOODS);
			pkg.writeInt(ShopItemId);
			pkg.writeInt(ShopItemNum);
			pkg.writeShort(zoneId);
			pkg.writeString(openKey);
			pkg.writeString(pf);
			pkg.writeString(pfKey);
			pkg.writeString(Domain);
//			pkg.writeByte(groupId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}