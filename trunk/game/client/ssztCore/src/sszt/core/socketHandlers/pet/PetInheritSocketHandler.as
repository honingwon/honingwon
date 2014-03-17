package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.PetModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class PetInheritSocketHandler extends BaseSocketHandler
	{
		public function PetInheritSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_INHERIT;
		}
		
		override public function handlePackage():void
		{
			QuickTips.show(LanguageManager.getWord('ssztl.pet.inheritOk'));
			ModuleEventDispatcher.dispatchPetEvent(new PetModuleEvent(PetModuleEvent.XISUI_SUCCESS));
			handComplete();
		}
		
		public static function send(id1:Number,id2:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_INHERIT);
			pkg.writeNumber(id1);
			pkg.writeNumber(id2);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}