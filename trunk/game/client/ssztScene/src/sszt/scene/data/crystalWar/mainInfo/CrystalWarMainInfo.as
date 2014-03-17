package sszt.scene.data.crystalWar.mainInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneCrystalWarUpdateEvent;
	

	public class CrystalWarMainInfo extends EventDispatcher
	{
		public var itemInfoList:Array;
		public var personalKillNum:int;
		public var personalScore:int;
		public var todayHonorNum:int;
		public var allHonorNum:int;
		
		public function CrystalWarMainInfo()
		{
			itemInfoList = [];
		}
		
		public function update():void
		{
			listSortOn();
			dispatchEvent(new SceneCrystalWarUpdateEvent(SceneCrystalWarUpdateEvent.CRYSTAL_MAIN_INFO_UPDATE));
		}
		
		public function updateInfo():void
		{
			dispatchEvent(new SceneCrystalWarUpdateEvent(SceneCrystalWarUpdateEvent.CRYSTAL_MAIN_INFO_PERSONALINFO_UPDATE));
		}
		
		public function listSortOn():void
		{
			itemInfoList.sortOn(["campScore"],[Array.NUMERIC|Array.DESCENDING]);
			for(var i:int = 0;i < itemInfoList.length;i++)
			{
				itemInfoList[i].rankNum = i+1;
			}
		}
		
		public function getItem(argCampName:String):CrystalWarClubItemInfo
		{
			for each(var i:CrystalWarClubItemInfo in itemInfoList)
			{
				if(i.campName == argCampName)
				{
					return i;
				}
			}
			return null;
		}
	}
}