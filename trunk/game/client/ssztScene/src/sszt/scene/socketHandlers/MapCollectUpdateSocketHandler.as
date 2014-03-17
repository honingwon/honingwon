package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.collects.CollectItemInfo;
	
	public class MapCollectUpdateSocketHandler extends BaseSocketHandler
	{
		public function MapCollectUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MAP_COLLECT_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			for(var i:int = 0; i < len; i++)
			{
				var id:int = _data.readInt();
				//0消亡，1普通采集，2任务物品
				var state:int = _data.readByte();
				if(state != 0)
				{
					var item:CollectItemInfo = sceneModule.sceneInfo.collectList.getItem(id);
					var templateId:int = _data.readInt();
					if(item == null)
					{
						item = new CollectItemInfo();
						item.id = id;
						item.templateId = templateId;
					}
					item.setScenePos(_data.readShort(),_data.readShort());
					sceneModule.sceneInfo.collectList.addItem(item);
				}
				else
				{
					//删除
					sceneModule.sceneInfo.collectList.removeItem(id,true);
					
				}
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}