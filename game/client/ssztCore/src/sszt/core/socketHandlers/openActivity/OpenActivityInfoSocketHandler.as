package sszt.core.socketHandlers.openActivity
{
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ActivityEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 开服相关活动  
	 * @author chendong
	 * 
	 */	
	public class OpenActivityInfoSocketHandler extends BaseSocketHandler
	{
		public function OpenActivityInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.PLAYER_ACTIVE_OPEN_SERVER;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var leng:int = _data.readByte(); //
			var i:int = 0;
			var groupId:int = 0; //1:"充值礼包"，2："消费礼包",3："冲级礼包"
			var totalValue:int = 0; //累计值
			var getedLeng:int = 0; // 已经领取礼品的数量
			var j:int = 0;
			var id:int = 0; //各个活动id
			var idArray:Array;
			var obj:Object;
			for(;i<leng;i++)
			{
				obj = {};
				idArray = [];
				obj.groupId = groupId = _data.readByte();
				obj.totalValue = totalValue = _data.readInt();
				obj.openTime = _data.readNumber();//活动结束时间
				getedLeng = _data.readByte();
				for(;j<getedLeng;j++)
				{
					id = _data.readShort(); 
					idArray.push(id);
				}
				j = 0;
				obj.idArray = idArray;
				GlobalData.openActivityInfo.activityDic[obj.groupId] = obj;
			}
			ModuleEventDispatcher.dispatchModuleEvent(new ActivityEvent(ActivityEvent.GET_OPEN_SERVER_DATA));
			handComplete();
		}
		
		/**
		 * 发送到服务端
		 */
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ACTIVE_OPEN_SERVER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}