package sszt.interfaces.loader
{
	import flash.events.IEventDispatcher;
	import flash.system.LoaderContext;
	
	import sszt.interfaces.dispose.IDispose;
	
	public interface ILoader extends IEventDispatcher,IDispose
	{
		function loadSync(context:LoaderContext = null):void;
		function cancel():void;
		function get isStart():Boolean;
		function get path():String;
		function set path(value:String):void;
		function get isFinish():Boolean;
		function addCallBack(callBack:Function):void;
		function setDataFormat(value:String):void;
		function getData():*;
	}
}