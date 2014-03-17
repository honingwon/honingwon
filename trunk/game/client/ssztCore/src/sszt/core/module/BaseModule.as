package sszt.core.module
{
	import sszt.core.data.module.ModuleInfo;
	import sszt.core.data.module.ModuleList;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.module.IModule;
	
	import flash.display.Sprite;
	
	public class BaseModule extends Sprite implements IModule
	{
		protected var moduleInfo:ModuleInfo;
		
		public function BaseModule()
		{
			super();
		}
		
		public function get moduleId():int
		{
			return 0;
		}
		
		public function setup(prev:IModule, data:Object=null):void
		{
			moduleInfo = ModuleList.getInfo(moduleId);
			initEvent();
		}
		
		protected function initEvent():void
		{
		}
		protected function removeEvent():void
		{
		}
		
		public function free(next:IModule):void
		{
			dispose();
		}
		
		public function configure(data:Object):void
		{
		}
		
		public function getBackTo():int
		{
			return 0;
		}
		
		public function getBackToParam():Object
		{
			return null;
		}
		
		
		public function assetsCompleteHandler():void
		{
		}
		
		
		public function dispose():void
		{
			removeEvent();
			moduleInfo = null;
			if(parent)parent.removeChild(this);
			dispatchEvent(new ModuleEvent(ModuleEvent.MODULE_DISPOSE));
		}
	}
}