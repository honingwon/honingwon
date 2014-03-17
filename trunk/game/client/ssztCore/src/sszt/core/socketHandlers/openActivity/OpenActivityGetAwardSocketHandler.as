package sszt.core.socketHandlers.openActivity
{
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ActivityEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class OpenActivityGetAwardSocketHandler extends BaseSocketHandler
	{
		public function OpenActivityGetAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.PLAYER_ACTIVE_OPEN_SERVER_AWARD;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var res:Boolean = _data.readBoolean();  //领取成功或失败
			var id:int = _data.readShort(); // 各个活动id
			var groupId:int = _data.readShort(); 
			if(res)
			{
				var obj:Object= GlobalData.openActivityInfo.activityDic[groupId];
				if(obj)
				{
					obj.idArray.push(id);
				}
					
				ModuleEventDispatcher.dispatchModuleEvent(new ActivityEvent(ActivityEvent.GET_AWARD,{id:id}));
			}
			handComplete();
		}
		
		/**
		 *  
		 * @param id 各个活动id
		 * @param groupId 2:"充值礼包"，3："消费礼包",4："冲级礼包"
		 */
		public static function send(id:int,groupId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ACTIVE_OPEN_SERVER_AWARD);
			pkg.writeShort(id);
			pkg.writeByte(groupId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}