package sszt.interfaces.module
{
	import flash.events.IEventDispatcher;
	
	import sszt.interfaces.dispose.IDispose;

	public interface IModule extends IEventDispatcher,IDispose
	{
		function get moduleId():int;
		function setup(prev:IModule,data:Object = null):void;
		function free(next:IModule):void;
		/**
		 * 进入相同模块
		 * @param data
		 * 
		 */		
		function configure(data:Object):void;
		function getBackTo():int;
		function getBackToParam():Object;
		function assetsCompleteHandler():void;
	}
}