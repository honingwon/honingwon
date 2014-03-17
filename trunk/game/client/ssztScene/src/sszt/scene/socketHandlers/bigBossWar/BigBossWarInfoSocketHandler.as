package sszt.scene.socketHandlers.bigBossWar
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.bigBossWar.BigBossWarRankingItemInfo;
	
	public class BigBossWarInfoSocketHandler extends BaseSocketHandler
	{
		public function BigBossWarInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BIG_BOSS_WAR_INFO;
		}
		
		override public function handlePackage():void
		{
			var list:Array = [];
			var myDamage:int = _data.readInt();
			var totalDamage:int = _data.readInt();
			var nick:String = _data.readUTF();
			var place:int;
			var itemInfo:BigBossWarRankingItemInfo;
			var len:int = _data.readShort();
			for(var i:int = 0; i < len; i++)
			{
				itemInfo = new BigBossWarRankingItemInfo();
				itemInfo.place = i + 1;
				itemInfo.nick = _data.readUTF();
				itemInfo.damage = _data.readInt();
				list.push(itemInfo);
			}
			module.bigBossWarInfo.updateDamageInfo(list,myDamage,totalDamage,nick);
			handComplete();
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
	}
}