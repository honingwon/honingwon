/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-24 下午3:08:12 
 * 
 */ 
package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.components.treasureHunt.TreasurePanel;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.proxy.SceneLoadMapDataProxy;

	public class TreasureMediator extends Mediator
	{
		public static const NAME:String = "treasureMediator";
		
		public function TreasureMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [SceneMediatorEvent.OPEN_TREASURE_MAP];
		}
		
		override public function handleNotification(notification:INotification) : void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.OPEN_TREASURE_MAP:
				{
					this.initTreasureMap(notification.getBody() as ItemInfo);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		private function initTreasureMap(item:ItemInfo):void
		{
			if (sceneModule.treasurePanel == null)
			{
				sceneModule.treasureInfo.treasureMap = item;
				sceneModule.treasurePanel = new TreasurePanel(this, item);
				sceneModule.treasurePanel.addEventListener(Event.CLOSE, treasurePanelCloseHandler);
				GlobalAPI.layerManager.addPanel(sceneModule.treasurePanel);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotOpenTwoTreasureMap"));
			}
			
		}
		
		private function treasurePanelCloseHandler(event:Event) : void
		{
			if (sceneModule.treasurePanel)
			{
				sceneModule.treasurePanel.removeEventListener(Event.CLOSE, treasurePanelCloseHandler);
				sceneModule.treasurePanel = null;
			}
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function loadMapPre(id:int, loadComplete:Function = null) : void
		{
			SceneLoadMapDataProxy.loadTreasureMap(id, loadComplete);
		}
		
		public function openMap(place:int) : void
		{
//			OpenTreasureMapSocketHandler.send(place);
		}
		
		public function identifyMap(place:int) : void
		{
//			IdentifyTreasureMapSocketHandler.send(place);
		}
	}
}