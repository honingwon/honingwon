package sszt.scene.components.copyGroup.sec
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class CopyTowerCountDownView extends Sprite
	{
		private static var instance:CopyTowerCountDownView;
		private var label1:MAssetLabel;
		private var label2:MAssetLabel;
		private var labelValue:MAssetLabel;
		private var countDownView:CountDownView;
		
		
		public function CopyTowerCountDownView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			label1 = new MAssetLabel(LanguageManager.getWord("ssztl.scene.currentMonsterNum"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			label1.move(0,0);
			addChild(label1);
			
			labelValue = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			labelValue.move(82,0);
			addChild(labelValue);
			
			label2 = new MAssetLabel(LanguageManager.getWord("ssztl.scene.nextMonsterLeftTime"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			label2.move(0,15);
			addChild(label2);
			
			countDownView = new CountDownView();
			addChild(countDownView);
			countDownView.move(129,15);
			
			mouseEnabled = mouseChildren = false;
		}
		
		public static function getInstance():CopyTowerCountDownView
		{
			if(instance == null)
			{
				instance = new CopyTowerCountDownView();
			}
			return instance;
		}
		
		public function show(currentLevel:int,totalLevel:int,nextTime:int):void
		{
			if(!parent) 
			{
				GlobalAPI.layerManager.getPopLayer().addChild(this);
				this.x = CommonConfig.GAME_WIDTH - 350;
				this.y = 85;
			}
			labelValue.setValue(currentLevel + "/" + totalLevel);
			countDownView.start(nextTime);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			countDownView.addEventListener(Event.CHANGE,changeHandler);
		}
		
		private function changeHandler(evt:Event):void
		{
			QuickTips.show(LanguageManager.getWord("ssztl.scene.beReady"));
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH - 350;
		}
		
		public function dispose():void
		{
			countDownView.removeEventListener(Event.CHANGE,changeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			if(parent) parent.removeChild(this);	
		}
	}
}