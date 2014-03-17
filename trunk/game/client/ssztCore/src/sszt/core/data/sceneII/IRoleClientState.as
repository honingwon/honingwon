package sszt.core.data.sceneII
{
	/**
	 * 客户端状态(不需要跟服务器同步的状态)
	 * @author Administrator
	 * 
	 */	
	public interface IRoleClientState
	{
		/**
		 * 普通状态
		 * 
		 */		
		function doCommon():void;
		/**
		 * 杀一只怪
		 * 
		 */		
		function doKillOne():void;
		/**
		 * 挂机状态
		 * 
		 */		
		function doHangup():void;
		/**
		 * 挂机捡道具
		 * 
		 */		
		function doHangupPick():void;
		/**
		 * 普通走路
		 * 
		 */		
		function doWalk():void;
		/**
		 * 坐骑走路
		 * 
		 */		
		function doMountWalk():void;
		/**
		 * 打坐
		 * 
		 */		
		function doSit():void;
		/**
		 * 双修
		 * 
		 */		
		function doDoubleSit():void;
		/**
		 * 采集
		 * 
		 */		
		function doCollect():void;
		function dispose():void;
	}
}