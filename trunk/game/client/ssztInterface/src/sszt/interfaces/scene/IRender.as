package sszt.interfaces.scene
{
	import flash.events.IEventDispatcher;

	public interface IRender extends IEventDispatcher
	{
		/**
		 * 根据icamera将iscene里的物体转为iviewport中显示
		 * 
		 */		
		function render():void;
	}
}