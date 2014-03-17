package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.iconInfo.TradeIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class TradeIconBtn extends BaseIconBtn
	{
		private var _tradeIconBtn:MBitmapButton;
		public function TradeIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipTrade");
		}
		
		override protected function initView():void
		{
			super.initView();
			_tradeIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconTradeAsset") as BitmapData);
			addChild(_tradeIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			var tmpTradeTopInfo:TradeIconInfo;
			GlobalAPI.tickManager.removeTick(GlobalData.quickIconInfo);
			if(GlobalData.quickIconInfo.tradeIconInfoList.length > 0)
			{
				tmpTradeTopInfo = GlobalData.quickIconInfo.tradeIconInfoList[0];
			}
			else
			{
				return;
			}
			
			if(_quickIconMediator.sceneModule.getTradeAlert != null)
			{
				_quickIconMediator.sceneModule.getTradeAlert.dispose();
			}
			//_quickIconMediator.sceneModule.getTradeAlert = MTimerAlert.show(15,MAlert.REFUSE,"[" + tmpTradeTopInfo.serverId + "]" + tmpTradeTopInfo.nick + LanguageManager.getWord("ssztl.scene.inviteTrade"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,getTradeAlertCloseHandler);
			_quickIconMediator.sceneModule.getTradeAlert = MTimerAlert.show(15,MAlert.REFUSE, tmpTradeTopInfo.nick + LanguageManager.getWord("ssztl.scene.inviteTrade"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,getTradeAlertCloseHandler);
			
			function getTradeAlertCloseHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.AGREE)
				{
					_quickIconMediator.sendTradeAccept(tmpTradeTopInfo.id,true);
				}
				else
				{
					_quickIconMediator.sendTradeAccept(tmpTradeTopInfo.id,false);
				}
				_quickIconMediator.sceneModule.getTradeAlert = null;
				GlobalData.quickIconInfo.removeFromTradeList(tmpTradeTopInfo.id);
				GlobalAPI.tickManager.addTick(GlobalData.quickIconInfo);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_tradeIconBtn)
			{
				_tradeIconBtn.dispose();
				_tradeIconBtn = null;
			}
		}
	}
}