package sszt.scene.socketHandlers.resourceWar
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.resourceWar.ResourceWarCampRankItemInfo;
	import sszt.scene.data.resourceWar.ResourceWarUserRankItemInfo;
	
	public class ResourceWarResultSocketHandler extends BaseSocketHandler
	{
		public function ResourceWarResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_RESOURCE_RESULT;
		}
		
		override public function handlePackage():void
		{
			//功勋
			var exploit:int = _data.readInt();
//			GlobalData.selfPlayer.exploit += exploit;
			GlobalData.pvpInfo.exploit += exploit;
			var i:int;
			
			var campRankList:Array = new Array();
			var campRankItem:ResourceWarCampRankItemInfo;
			for(i = 1; i <= 3; i++)
			{
				campRankItem = new ResourceWarCampRankItemInfo();
				campRankItem.killingPoint = _data.readInt();
				campRankItem.collectingPoint = _data.readInt();
				campRankItem.totalPoint = campRankItem.killingPoint + campRankItem.collectingPoint;
				campRankItem.campType = i;
				campRankList.push(campRankItem);
			}
			campRankList.sortOn(['totalPoint'],[Array.NUMERIC]);
			campRankList.reverse();
			
			for(i = 1; i <= 3; i++)
			{
				campRankItem = campRankList[i - 1];
				campRankItem.place = i;
			}
			
			var len:int = _data.readShort();
			var rankItem:ResourceWarUserRankItemInfo;
			var rankList:Array = new Array();
			for(i = 1; i <= len; i++)
			{
				rankItem = new ResourceWarUserRankItemInfo();
				rankItem.place = i;
				rankItem.parseData(_data);
				rankList.push(rankItem);
			}
			
			module.resourceWarInfo.updateWarResult(rankList, campRankList,exploit);
			
			handComplete();
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}