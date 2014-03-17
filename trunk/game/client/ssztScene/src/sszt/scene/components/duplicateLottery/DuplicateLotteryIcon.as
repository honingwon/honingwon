package sszt.scene.components.duplicateLottery
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.*;
	import flash.utils.setInterval;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.EffectType;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.DuplicateLotteryMediator;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.core.manager.LanguageManager;
	import flash.text.TextFormatAlign;
	
	import ssztui.scene.FBLotterTagAsset;
	
	public class DuplicateLotteryIcon extends MSprite
	{
		public var _mediator:DuplicateLotteryMediator;
		private var _effect:BaseLoadEffect;
		private var _tag:Bitmap;
		private var _clickBg:MSprite;
		private var _txtLeftTime:MAssetLabel;
		private var _counter:uint = 10;
		private var _intervalId:uint;
		
		
		public function DuplicateLotteryIcon(mediator:DuplicateLotteryMediator)
		{
			super();
			_mediator = mediator;
			setPosition();
			initEvent();			
			duplicateLotterySetInterval();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this.buttonMode  = true;
			_clickBg = new MSprite();
			_clickBg.graphics.beginFill(0,0);
			_clickBg.graphics.drawRect(-50,-50,100,100);
			_clickBg.graphics.endFill();
			addChild(_clickBg);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.LOTTERY_ENTER_EFFECT));
			_effect.play();
			addChild(_effect);
			
			_tag = new Bitmap(new FBLotterTagAsset());
			_tag.x = -32;
			_tag.y = 8;
			addChild(_tag);
			
			_txtLeftTime = new MAssetLabel("",MAssetLabel.LABELTYPE14,TextFormatAlign.CENTER);
			_txtLeftTime.move(-3,27);
			addChild(_txtLeftTime);
			_txtLeftTime.setValue("10"+LanguageManager.getWord("ssztl.common.timeoutToOpen"));
		}
		
		private function duplicateLotterySetInterval():void
		{
			_counter = 10;			
			_intervalId = setInterval(myRepeatingFunction,1000);
		}
		
		private function myRepeatingFunction():void 
		{             
			_counter--;
			_txtLeftTime.setValue(_counter+LanguageManager.getWord("ssztl.common.timeoutToOpen"));
			if(_counter == 0)
			{
				_mediator.autoGetDulicateLottery();
				clearInterval(_intervalId);
			}
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			setPosition();
		}
		
		private function setPosition():void
		{
			x = CommonConfig.GAME_WIDTH/2;
			y = 190;
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(parent)
			{				
				clearInterval(_intervalId);
				parent.removeChild(this);
			}
			super.dispose();
		}
	}
}