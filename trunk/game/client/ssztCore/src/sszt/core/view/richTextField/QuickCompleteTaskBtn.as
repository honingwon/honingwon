package sszt.core.view.richTextField
{
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.TaskQuickCompleteSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MYuanbaoAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class QuickCompleteTaskBtn extends MCacheAssetBtn1
	{
		private var _info:DeployItemInfo;
		public function QuickCompleteTaskBtn()
		{
			super(0, 3, LanguageManager.getWord('ssztl.task.finishRightNow'));
		}
		
		public function set info(value:DeployItemInfo) : void
		{
			this._info = value;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			this.addEventListener(MouseEvent.CLICK,clickHandler)
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			this.removeEventListener(MouseEvent.CLICK,clickHandler)
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			if(GlobalData.selfPlayer.userMoney.yuanBao < 2)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
				return;
			}
			MYuanbaoAlert.show(LanguageManager.getWord("ssztl.common.quickCompleteTask",2), LanguageManager.getWord("ssztl.common.alertTitle"),MYuanbaoAlert.OK|MYuanbaoAlert.CANCEL,null,confirmMAlertHandler);
			//param1 任务id，param2 要完成的任务数量
			function confirmMAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MYuanbaoAlert.OK)
				{
					TaskQuickCompleteSocketHandler.sendSubmit(_info.param1);
				}
			}
		}
	}
}