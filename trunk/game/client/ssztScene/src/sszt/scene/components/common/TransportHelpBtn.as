package sszt.scene.components.common
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class TransportHelpBtn extends MSprite
	{
		private var _helpBtn:MBitmapButton;
		private var _mediator:SceneMediator;
		private var _count:int = 0;
		
		public function TransportHelpBtn(mediator:SceneMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
//			_helpBtn = new MBitmapButton(new TransportHelpAsset());
			_helpBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.TransportHelpAsset") as BitmapData);
			addChild(_helpBtn);
			gameSizeChangeHandler(null);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_helpBtn.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_helpBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(GlobalData.selfPlayer.clubId == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotAskHelp"));
				return;
			}
			if(_count > 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.onlyOnce"));
				return;
			}
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			_mediator.transportHelp();
			_count++;
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH/2 + 56;
			this.y = CommonConfig.GAME_HEIGHT - 150;
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_helpBtn)
			{
				_helpBtn.dispose();
				_helpBtn = null;
			}
			_mediator = null;
			super.dispose();
		}
	}
}