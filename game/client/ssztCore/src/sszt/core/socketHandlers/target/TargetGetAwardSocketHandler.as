package sszt.core.socketHandlers.target
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class TargetGetAwardSocketHandler extends BaseSocketHandler
	{
		public function TargetGetAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TARGET_GET_AWARD;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var targetId:int = _data.readInt(); //目标id
			var num:int = _data.readByte(); //剩余未领取数量
			var suc:Boolean = _data.readBoolean(); //领取成功
			if(suc) 
			{
				var targetData:TargetData;
				targetData = new TargetData();
				targetData.target_id = targetId;
				targetData.isReceive = true;
				targetData.isFinish = true;
				if(TargetTemplateList.getTargetByIdTemplate(targetData.target_id).type == 0)
				{
					GlobalData.targetInfo.targetByIdDic[targetData.target_id] = targetData
				}
				else
				{
					GlobalData.targetInfo.achByIdDic[targetData.target_id] = targetData
				}
				ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.GET_TARGET_AWARD,{targetId:targetId,num:num}));
			}
			GlobalData.targetInfo.num = num;
			handComplete();
		}
		
		/**
		 * 获得目标奖励
		 * @param targetId 目标id
		 */
		public static function getTargetAwardById(targetId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TARGET_GET_AWARD);
			pkg.writeInt(targetId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}