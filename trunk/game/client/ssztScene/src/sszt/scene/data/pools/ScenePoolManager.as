package sszt.scene.data.pools
{
	import sszt.core.pool.PoolManager;

	public class ScenePoolManager
	{
		private static var _hasSetup:Boolean;
		
		public static var bloodMovieManager:PoolManager;
		
		public static function setup():void
		{
			if(!_hasSetup)
			{
				_hasSetup = true;
				
				bloodMovieManager = new PoolManager(40);
				bloodMovieManager.setClass(BloodMoviePool);
				
				
			}
		}
	}
}