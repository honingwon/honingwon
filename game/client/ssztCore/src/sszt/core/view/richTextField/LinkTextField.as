package sszt.core.view.richTextField
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.view.tips.TipsUtil;
	
	public class LinkTextField extends Sprite
	{
		/**
		 * linkText类型,0为物品，1为人物，2为NPC，3为怪物
		 */		
		public var linkType:int;
		public var id:Number;
		public var linkName:String;
		public var line:int;
		
		public var deployInfo:DeployItemInfo;
		
		public function LinkTextField(width:int)
		{
			buttonMode = true;
			tabEnabled = false;
			super();
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,width,18);
			graphics.endFill();
			
			initEvent();
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if(deployInfo.type == DeployEventType.ITEMTIP || deployInfo.type == DeployEventType.PLAYER_MENU || deployInfo.type == DeployEventType.TASK_TIP)
			{
//				deployInfo.param3 = e.stageX;
//				deployInfo.param4 = e.stageY;
				deployInfo.param4 = e.stageX * 100000 + e.stageY;
			}
			DeployEventManager.handle(deployInfo);
		}
		
		public function dispose():void
		{
			removeEvent();
			deployInfo = null;
		}
	}
}