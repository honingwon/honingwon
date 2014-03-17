package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.doubleSit.DoubleSitPanel;
	import sszt.scene.components.lifeExpSit.LifeExpSitPanel;
	import sszt.scene.components.medicinesCaution.MedicinesCautionPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class MedicinesCautionMediator extends Mediator
	{
		public static const NAME:String = "medicinesCautionMediator";
		
		public function MedicinesCautionMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SHOW_MEDICINES_CAUTION_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch(notification.getName())
			{
				case SceneMediatorEvent.SHOW_MEDICINES_CAUTION_PANEL:
					showMedicinesCautionPanel(data.medicinesType);
					break;
			}
		}
		
		public function showMedicinesCautionPanel(medicinesType:int):void
		{
			if(sceneModule.medicinesCautionPanel == null)
			{
				sceneModule.medicinesCautionPanel = new MedicinesCautionPanel(this, medicinesType);
				GlobalAPI.layerManager.addPanel(sceneModule.medicinesCautionPanel);
				sceneModule.medicinesCautionPanel.addEventListener(Event.CLOSE,medicinesCautionPanelCloseHandler);
			}
		}
		private function medicinesCautionPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.medicinesCautionPanel)
			{
				sceneModule.medicinesCautionPanel.removeEventListener(Event.CLOSE,medicinesCautionPanelCloseHandler);
				sceneModule.medicinesCautionPanel = null;
			}
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}