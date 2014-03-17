package sszt.interfaces.scene
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import sszt.interfaces.dispose.IDispose;
	
	public interface IScene extends IEventDispatcher,IDispose
	{
		/**
		 * 移动物体
		 * 发出事件通知渲染器重新渲染物体位置和相关排序
		 * @param obj
		 * 
		 */		
		function move(obj:ISceneObj,scenePt:Point):void;
		/**
		 * 添加物体
		 * 发事对应事件
		 * @param obj
		 * @return 
		 * 
		 */		
		function addChild(obj:ISceneObj):ISceneObj;
		/**
		 * 删除物体
		 * @param obj
		 * 
		 */		
		function removeChild(obj:ISceneObj):void;
		/**
		 * 取得视窗引用
		 * @return 
		 * 
		 */		
		function getViewPort():IViewPort;
		/**
		 * 添加效果
		 * @param effect
		 * 
		 */		
		function addEffect(effect:DisplayObject):void;
		
		/**
		 * 添加到地图层，在所在物品下面，地图上面
		 * @param obj
		 * 
		 */		
		function addToMap(obj:DisplayObject):void;
		/**
		 * 添加物品到control层
		 * @param obj
		 * 
		 */		
		function addControl(obj:DisplayObject):void;
		
		function get width():uint;
		
		function get height():uint;
		/**
		 * 地图数据
		 * @return 
		 * 
		 */		
		function get mapData():IMapData;
		
		function getSceneObjsByPos(row:int,col:int):Array;
	}
}
