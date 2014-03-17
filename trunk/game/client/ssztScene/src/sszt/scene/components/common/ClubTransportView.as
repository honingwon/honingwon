package sszt.scene.components.common
{
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ClubTransportView extends MSprite
	{
		private var _countDown:CountDownView;
		private var _label:MAssetLabel;
		
		public function ClubTransportView()
		{
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			this.x = CommonConfig.GAME_WIDTH - 310;
			this.y = 50;
			this.mouseEnabled = this.mouseChildren = false;
			
			_label = new MAssetLabel(LanguageManager.getWord("ssztl.scene.clubTransportTime"),MAssetLabel.LABELTYPE6);
			addChild(_label);
			
			_countDown = new CountDownView();
			_countDown.move(90,0);
			_countDown.setColor(0xb3e5db);
			addChild(_countDown);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_countDown.addEventListener(Event.COMPLETE,completeHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_countDown.removeEventListener(Event.COMPLETE,completeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH - 350;
		}
		
		private function completeHandler(e:Event):void
		{
			GlobalData.setClubTransportTime(0);
		}
		
		public function setTime(second:Number):void
		{
			_countDown.start(second);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			super.dispose();
		}
	}
}