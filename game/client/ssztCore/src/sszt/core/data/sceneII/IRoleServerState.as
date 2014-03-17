package sszt.core.data.sceneII
{
	/**
	 * 服务器状态(需要跟服务器同步的状态)
	 * @author Administrator
	 * 
	 */	
	public interface IRoleServerState
	{
		/**
		 * 普通状态
		 * 
		 */		
		function doCommon():void;
		/**
		 * 战斗状态
		 * 
		 */		
		function doFight():void;
		/**
		 * 吟唱状态
		 * 
		 */		
		function doWaitFight():void;
		/**
		 * 击倒状态
		 * 
		 */		
		function doHitDown():void;
		/**
		 * 死亡状态
		 * 
		 */		
		function doDead():void;
		/**
		 * 
		 * 
		 */		
		function dispose():void;
	}
}