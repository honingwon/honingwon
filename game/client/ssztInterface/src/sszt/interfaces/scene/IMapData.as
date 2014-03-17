package sszt.interfaces.scene
{
	import flash.events.IEventDispatcher;
	
	public interface IMapData extends IEventDispatcher
	{
//		/**
//		 * 地图单元格数据
//		 * @return 
//		 * 
//		 */		
//		function getGridSource():Array;
//		function getMapId():int;
//		function getName():String;
		/**
		 * 地图长宽
		 * @return 
		 * 
		 */		
		function getWidth():int;
		function getHeight():int;
		function dispatchRender():void;
//		/**
//		 * 走路单元格数
//		 * @return 
//		 * 
//		 */		
//		function getMaxGridCountX():int;
//		function getMaxGridCountY():int;
//		/**
//		 * 服务器广播格子数
//		 * @return 
//		 * 
//		 */		
//		function getMaxServerGridCountX():int;
//		function getMaxServerGridCountY():int;
		
//		function jumpList:Vector.<>;
	}
}