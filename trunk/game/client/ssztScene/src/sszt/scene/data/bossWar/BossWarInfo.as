package sszt.scene.data.bossWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.scene.events.SceneAcroSerUpdateEvent;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	
	public class BossWarInfo extends EventDispatcher
	{
		public var list:Dictionary;         //所有Boss剩余时间
		public var selectId:int = -1;
		
		public var acrossList:Dictionary;
		public var acrossSelectId:int = -1;
		public function BossWarInfo(target:IEventDispatcher=null)
		{
			list = new Dictionary();
			acrossList = new Dictionary();
			super(target);
		}
		
		public function setData(ids:Array,times:Array):void
		{
			for(var i:int = 0;i<ids.length;i++)
			{
				list[ids[i]] = times[i];
			}
			dispatchEvent(new SceneBossWarUpdateEvent(SceneBossWarUpdateEvent.BOSS_WAR_MAIN_INFO_UPDATE,ids));
			updateSelect(selectId);
		}
		
		public function updateSelect(argSelectId:int):void
		{
			selectId = argSelectId;
			dispatchEvent(new SceneBossWarUpdateEvent(SceneBossWarUpdateEvent.BOSS_FOCUSE_UPDATE,selectId));
		}
		
		public function updateSingleBoss(argBossId:int,argTime:int):void
		{
			list[argBossId] = argTime;
			if(argBossId == selectId)
			{
				dispatchEvent(new SceneBossWarUpdateEvent(SceneBossWarUpdateEvent.BOSS_FOCUSE_UPDATE,selectId));
			}
		}
		
		public function getTime(argId:int):int
		{
			return list[argId];
		}
		//-----------------------------------------跨服boss-------------------------------------//
		public function setAcrossData(ids:Array,times:Array):void
		{
			for(var i:int = 0;i<ids.length;i++)
			{
				acrossList[ids[i]] = times[i];
			}
			dispatchEvent(new SceneAcroSerUpdateEvent(SceneAcroSerUpdateEvent.ACROSER_BOSS_WAR_MAIN_INFO_UPDATE,ids));
			updateAcroBossSelectId(acrossSelectId);
		}
		
		public function updateAcroBossSelectId(argSelectId:int):void
		{
			acrossSelectId = argSelectId;
			dispatchEvent(new SceneAcroSerUpdateEvent(SceneAcroSerUpdateEvent.ACROSER_BOSS_FOCUSE_UPDATE,acrossSelectId));
		}
		
		public function updateAcroSingleBoss(argBossId:int,argTime:int):void
		{
			acrossList[argBossId] = argTime;
			if(argBossId == acrossSelectId)
			{
				dispatchEvent(new SceneAcroSerUpdateEvent(SceneAcroSerUpdateEvent.ACROSER_BOSS_FOCUSE_UPDATE,acrossSelectId));
			}
		}
		
		public function getAcrossBossTime(argId:int):int
		{
			return acrossList[argId];
		}
	}
}