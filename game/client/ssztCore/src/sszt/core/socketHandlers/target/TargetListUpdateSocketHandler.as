package sszt.core.socketHandlers.target
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 目标列表更新 
	 * @author chendong
	 * 
	 */	
	public class TargetListUpdateSocketHandler extends BaseSocketHandler
	{
		public function TargetListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TARGET_LIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var len:int = _data.readShort();
			var num:int = _data.readByte(); //未领取数量
			var targetData:TargetData;
			for(var i:int; i<len; i++)
			{
				targetData = new TargetData();
				targetData.target_id = _data.readInt();
				targetData.num = _data.readInt(); //当前的次数
//				targetData.totalNum = _data.readInt(); //总次数
				targetData.isReceive = _data.readBoolean();
				targetData.isFinish = _data.readBoolean();
				if(TargetTemplateList.getTargetByIdTemplate(targetData.target_id))
				{
					if(TargetTemplateList.getTargetByIdTemplate(targetData.target_id).type == 0)
					{
						GlobalData.targetInfo.targetByIdDic[targetData.target_id] = targetData
					}
					else
					{
						GlobalData.targetInfo.achByIdDic[targetData.target_id] = targetData
					}
				}
			}
			GlobalData.targetInfo.num = num;
			ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.UPDATE_TARGET_LIST,{num:num}));
			handComplete();
		}
		
		
		/**
		 * 更新 目标列表
		 */
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TARGET_LIST_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}