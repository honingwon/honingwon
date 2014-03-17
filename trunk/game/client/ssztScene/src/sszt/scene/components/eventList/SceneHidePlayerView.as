package sszt.scene.components.eventList
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.button.MBitmapButton;
	
	import sszt.constData.CommonConfig;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.EventMediator;
	import sszt.scene.mediators.SceneMediator;
	import mhsm.ui.HidePlayerBtn;
	
	public class SceneHidePlayerView extends Sprite
	{
		private var _mediator:EventMediator;
		private var _hidePlayerBtn:MBitmapButton;
		private var _select:Boolean;
		public function SceneHidePlayerView(argMediator:EventMediator)
		{
			super();
			_mediator = argMediator;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			mouseEnabled = false;
			_hidePlayerBtn = new MBitmapButton(new HidePlayerBtn());
			_hidePlayerBtn.move(175,5);
			addChild(_hidePlayerBtn);
			_hidePlayerBtn.visible = false;
			
			gameSizeChangeHandler(null);
		}
		
		private function initEvents():void
		{
			_hidePlayerBtn.addEventListener(MouseEvent.CLICK,showClickHandler);
			_hidePlayerBtn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_hidePlayerBtn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvents():void
		{
			_hidePlayerBtn.removeEventListener(MouseEvent.CLICK,showClickHandler);
			_hidePlayerBtn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_hidePlayerBtn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function showClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_select = SharedObjectManager.hidePlayerCharacter.value;
			_select = !_select;
			SharedObjectManager.setHidePlayerCharacter(_select);
//			SharedObjectManager.hidePlayerCharacter.value = _select;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.showOrHidePlayerStyle"),null,new Rectangle(e.stageX,e.stageY,0,0));
//			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.seeMoreGameMsg"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 193;
			y = CommonConfig.GAME_HEIGHT - 194;
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			if(_hidePlayerBtn)
			{
				_hidePlayerBtn.dispose();
				_hidePlayerBtn = null;
			}
			if(parent)parent.removeChild(this);
		}
			
	}
}