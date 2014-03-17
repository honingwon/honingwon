package sszt.scene.components.copyGroup.sec
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class CopyCountDownView extends Sprite
	{
		private static var instance:CopyCountDownView;
		private static var _label:MAssetLabel;
		private var _countDownView:CountDownView;
		private var _outDuplicate:MCacheAssetBtn1;
		
		
		public function CopyCountDownView()
		{
			super();
			init();
		}
		
		public static function getInstance():CopyCountDownView
		{
			if(instance == null)
			{
				instance = new CopyCountDownView();
			}
			return instance;
		}
		
		private function init():void
		{
			_label = new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyLeftTime"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_label.move(0,0);
			addChild(_label);
			
			_countDownView = new CountDownView();
			_countDownView.move(82,0);
			addChild(_countDownView);
			
			_outDuplicate = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_outDuplicate.move(30,30);
			addChild(_outDuplicate);
			
//			mouseEnabled = mouseChildren = false;
		}
		
		public function show(seconds:int):void
		{
			if(!parent) GlobalAPI.layerManager.getPopLayer().addChild(this);
			this.x = CommonConfig.GAME_WIDTH - 350;
			this.y = 70;
			_countDownView.addEventListener(Event.COMPLETE,completeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_outDuplicate.addEventListener(MouseEvent.CLICK,quitDuplicate);
			_countDownView.start(seconds);
			
		}
		private function quitDuplicate(evt:Event):void
		{
			var message:String;
			if(GlobalData.copyEnterCountList.isPKCopy()&& GlobalData.selfPlayer.pkState == 0) message = LanguageManager.getWord("ssztl.scene.isSureBeLoser");
			else message = LanguageManager.getWord("ssztl.scene.isSureLeaveCopy");
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
			function leaveAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					CopyLeaveSocketHandler.send();
				}
			}
		}
		private function completeHandler(evt:Event):void
		{
			dispose();
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH - 350;
		}
		
		public function dispose():void
		{
			_countDownView.removeEventListener(Event.COMPLETE,completeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_outDuplicate.removeEventListener(MouseEvent.CLICK,quitDuplicate);
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			if(_outDuplicate)
			{
				_outDuplicate.dispose();
				_outDuplicate = null;
			}
			_label = null;
			instance = null;
			if(parent) parent.removeChild(this);
		}
	}
}