package sszt.core.socketHandlers.bag
{
	import flash.geom.Point;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.itemPick.ItemPickManager;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemPlaceUpdateSocketHandler extends BaseSocketHandler
	{
		public function ItemPlaceUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_PLACE_UPDATE;
		}
		

		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var item:ItemInfo;
//			var list:Vector.<ItemInfo> = new Vector.<ItemInfo>();
			var list:Array = [];
			var pickType:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				var place:int = _data.readInt();
				item = new ItemInfo();
				item.place = place;
				item.isExist = _data.readBoolean();
				if(!item.isExist)
				{
					if(item)
						item.isExist = false;
				}
				else
				{
					pickType = _data.readByte();
					
					PackageUtil.readItem(item,_data);
					
					if(CategoryType.isEquip(item.template.categoryId))
					{
						var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(TaskItemList.EQUIP_STRENGHT_TASK);
						if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false && item.strengthenLevel>0)
						{
							TaskClientSocketHandler.send(taskInfo.taskId,0);
						}
						taskInfo = GlobalData.taskInfo.getTask(TaskItemList.EQUIP_REBUILD_TASK);
						if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false && item.freePropertyVector.length>0)
						{
							TaskClientSocketHandler.send(taskInfo.taskId,0);
						}
					}
					if(pickType > 10)
						GlobalData.bagInfo.addItemEvetList(item);
					if (pickType == 11)
					{
						ItemPickManager.getInstance().pickItem(item.templateId);
					}
					else if (pickType == 12)
					{
						ItemPickManager.getInstance().pickItem(item.templateId, new Point(CommonConfig.GAME_WIDTH - 220, 200));
					}
					else if (pickType == 13)
					{
						ItemPickManager.getInstance().pickItem(item.templateId);
					}
				}
				list.push(item);
			}
			GlobalData.bagInfo.updateItems(list);
			
			handComplete();
		}
	}
}