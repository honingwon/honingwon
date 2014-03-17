package sszt.interfaces.pool
{
	import sszt.interfaces.dispose.IDispose;
	
	public interface IPoolManager extends IDispose
	{
		function setClass(cl:Object):void;
		function getObj(param:Object):IPoolObj;
		function removeObj(obj:IPoolObj):void;
		function clear():void;
		function getItemCount():int;
	}
}