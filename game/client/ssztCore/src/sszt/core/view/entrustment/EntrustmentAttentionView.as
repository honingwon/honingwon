package sszt.core.view.entrustment
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.entrustment.EntrustmentItemInfo;
	import sszt.core.data.entrustment.EntrustmentTemplateItem;
	import sszt.core.data.entrustment.EntrustmentTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.entrustment.QuickEntrustmentSocketHandler;
	import sszt.core.socketHandlers.entrustment.StopEntrustingSocketHandler;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class EntrustmentAttentionView extends MSprite
	{
		private static var  instance:EntrustmentAttentionView;
		
		private var _bg:IMovieWrapper;
		private var _info:EntrustmentItemInfo;
		private var _title:MAssetLabel;
		
		private var _countDownView:CountDownView;
		private var _btnStop:MCacheAssetBtn1;
		private var _btnQuickComplete:MCacheAssetBtn1;
		
		private const BOTTOM:int = 125;
		private const RIGHT:int = 10;
		private const WIDTH:int = 241;
		private const HEIGHT:int = 115;
		
		public function EntrustmentAttentionView()
		{
			super();
			initEvent();
		}
		
		public static function getInstance():EntrustmentAttentionView
		{
			if(!instance)
			{
				instance = new EntrustmentAttentionView();
			}
			return instance;
		}
		
		public function show(info:EntrustmentItemInfo):void
		{
			_info = info;
			var templateInfo:EntrustmentTemplateItem = EntrustmentTemplateList.getTemplateById(info.templateId);
			var time:int = GlobalData.systemDate.getSystemDate().getTime() / 1000;
			var leftSeconds:int = _info.endTime - time;
			_countDownView.start(leftSeconds);
			
			if(!parent)
				GlobalAPI.layerManager.getPopLayer().addChild(this);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,241,115)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(66,40,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.leftTime"),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);

			_title = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_title.textColor = 0xff9900;
			_title.move(120,10);
			addChild(_title);
			_title.setHtmlValue(LanguageManager.getWord("ssztl.activity.entrustmentTitle2"));
			
			_countDownView = new CountDownView();
			_countDownView.textField.textColor = 0x33ff00;
			_countDownView.move(126,40);
			addChild(_countDownView);
			
			_btnStop = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.end'));
			_btnStop.move(48,67);
			addChild(_btnStop);
			
			_btnQuickComplete = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.task.finishRightNow'));
			_btnQuickComplete.move(123,67);
			addChild(_btnQuickComplete);
			
			gameSizeChangeHandler(null);
		}
		
		private function initEvent():void
		{
			_btnStop.addEventListener(MouseEvent.CLICK,btnStopClickedHandler);
			_btnQuickComplete.addEventListener(MouseEvent.CLICK,btnQuickCompleteClickedHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			move(CommonConfig.GAME_WIDTH - WIDTH - RIGHT,CommonConfig.GAME_HEIGHT - HEIGHT - BOTTOM);
		}
		
		private function removeEvent():void
		{
			_btnStop.removeEventListener(MouseEvent.CLICK,btnStopClickedHandler);
			_btnQuickComplete.removeEventListener(MouseEvent.CLICK,btnQuickCompleteClickedHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		protected function btnQuickCompleteClickedHandler(event:MouseEvent):void
		{
			//至尊vip免费
			if(GlobalData.selfPlayer.getVipType() == VipType.BESTVIP)
			{
				MAlert.show(LanguageManager.getWord("ssztl.entrustment.completeVIPAlert"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES,null,confirmHandler);
			}
			else
			{
				var entrustmentTemplateInfo:EntrustmentTemplateItem = EntrustmentTemplateList.getTemplateById(_info.templateId);
				MAlert.show(LanguageManager.getWord("ssztl.entrustment.completeAlert",entrustmentTemplateInfo.yuanbaoCost * _info.count),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,confirmHandler);
			}
			
			
			function confirmHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					QuickEntrustmentSocketHandler.send();
				}
			}
		}
		
		protected function btnStopClickedHandler(event:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.entrustment.stopAlert"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,confirmHandler);
			function confirmHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					StopEntrustingSocketHandler.send();
				}
			}
		}	
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			instance = null;
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView =null;
			}
			if(_btnStop)
			{
				_btnStop.dispose();
				_btnStop =null;
			}
			if(_btnQuickComplete)
			{
				_btnQuickComplete.dispose();
				_btnQuickComplete =null;
			}
		}
	}
}