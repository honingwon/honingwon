package sszt.core.pool
{
	import sszt.core.view.effects.BaseCountEffectPool;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffectPool;
	import sszt.core.view.effects.BaseLoadMoveEffect;
	import sszt.core.view.effects.BaseLoadMoveEffectPool;
	import sszt.core.view.effects.QuealityMoveEffectPool1;
	import sszt.core.view.effects.QuealityMoveEffectPool2;
	import sszt.core.view.effects.QuealityMoveEffectPool3;
	import sszt.core.view.effects.QuealityMoveEffectPool4;

	public class CommonEffectPoolManager
	{
		public static var baseEffectManager:PoolManager;
		
		public static var baseLoaderEffectManager:PoolManager;
		
		public static var baseCountEffectManager:PoolManager;
		
		public static var baseLoadMoveEffectManager:PoolManager;
		
//		public static var qualityMoveEffectManager1:PoolManager;
//		public static var qualityMoveEffectManager2:PoolManager;
//		public static var qualityMoveEffectManager3:PoolManager;
//		public static var qualityMoveEffectManager4:PoolManager;
		
		public static function setup():void
		{
			baseEffectManager = new PoolManager(12);
			baseEffectManager.setClass(BaseEffect);
			
			baseLoaderEffectManager = new PoolManager(50);
			baseLoaderEffectManager.setClass(BaseLoadEffectPool);
			
			baseCountEffectManager = new PoolManager(6);
			baseCountEffectManager.setClass(BaseCountEffectPool);
			
			baseLoadMoveEffectManager = new PoolManager(15);
			baseLoadMoveEffectManager.setClass(BaseLoadMoveEffectPool);
			
//			qualityMoveEffectManager1 = new PoolManager(20);
//			qualityMoveEffectManager1.setClass(QuealityMoveEffectPool1);
//			
//			qualityMoveEffectManager2 = new PoolManager(20);
//			qualityMoveEffectManager2.setClass(QuealityMoveEffectPool2);
//			
//			qualityMoveEffectManager3 = new PoolManager(20);
//			qualityMoveEffectManager3.setClass(QuealityMoveEffectPool3);
//			
//			qualityMoveEffectManager4 = new PoolManager(20);
//			qualityMoveEffectManager4.setClass(QuealityMoveEffectPool4);
		}
	}
}