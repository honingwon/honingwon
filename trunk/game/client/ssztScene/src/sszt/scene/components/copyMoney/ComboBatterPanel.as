package sszt.scene.components.copyMoney
{
	import com.greensock.TweenLite;
	
	import fl.controls.ProgressBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import mx.effects.Tween;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.duplicate.DuplicateMoneyInfo;
	import sszt.scene.events.SceneDuplicateMoneyUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.scene.ComboBarAsset;
	import ssztui.scene.ComboNumberAsset0;
	import ssztui.scene.ComboNumberAsset1;
	import ssztui.scene.ComboNumberAsset2;
	import ssztui.scene.ComboNumberAsset3;
	import ssztui.scene.ComboNumberAsset4;
	import ssztui.scene.ComboNumberAsset5;
	import ssztui.scene.ComboNumberAsset6;
	import ssztui.scene.ComboNumberAsset7;
	import ssztui.scene.ComboNumberAsset8;
	import ssztui.scene.ComboNumberAsset9;
	import ssztui.scene.ComboTextAsset;
	import ssztui.scene.ComboTrackAsset;
	
	public class ComboBatterPanel extends Sprite implements ITick
	{
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		private var _bg:IMovieWrapper;
		
		private var _numClass:Array = [ComboNumberAsset0,ComboNumberAsset1,ComboNumberAsset2,ComboNumberAsset3,ComboNumberAsset4,ComboNumberAsset5,ComboNumberAsset6,ComboNumberAsset7,ComboNumberAsset8,ComboNumberAsset9]
		private var _viewComboAdd:MAssetLabel;
		private var _timeBar:ProgressBar1;
		private var _comboShow:Sprite;
		private var _numbers:Array;
		private var _txtCombo:Bitmap;
		
		private var _comboTickTime:int;
//		private var batterTickTime:int;
		
		public function ComboBatterPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
		}
		private function initialView():void
		{
			x = 96;
			y = 158;
			mouseEnabled = false;
			_container = new Sprite();			
			addChild(_container);
			_container.mouseEnabled = false;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,252,60),new Bitmap(new ComboTrackAsset() as BitmapData)),				
				]);
			_container.addChild(_bg as DisplayObject);
			_container.visible = false;
			
			_timeBar = new ProgressBar1(new Bitmap(new ComboBarAsset() as BitmapData),1,100,250,60,false,false);
			_container.addChild(_timeBar as DisplayObject);
			_timeBar.mouseEnabled = false;
			
			_txtCombo = new Bitmap(new ComboTextAsset() as BitmapData);
			_txtCombo.y = 6;
			_container.addChild(_txtCombo as DisplayObject);
			
			_numbers = new Array;
			_comboShow = new Sprite();
			_comboShow.x = 25;
			_comboShow.y = -16;
			_container.addChild(_comboShow as DisplayObject);
			
		}
		private function initialEvents():void
		{
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO, updateCombo);
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_KILL_BOSS, updateKillBoss);
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO_STATE, updateComboTickState);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		private function removeEvents():void
		{
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO, updateCombo);
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_KILL_BOSS, updateKillBoss);
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO_STATE, updateComboTickState);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		public function update(times:int,dt:Number = 0.04):void
		{
			_comboTickTime --;
			if(_comboTickTime > 0)
				_timeBar.setCurrentValue(_comboTickTime);
		}
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = 96;
			y = 158;
		}
		private function updateComboTickState(e:SceneDuplicateMoneyUpdateEvent):void
		{
			GlobalAPI.tickManager.addTick(this);
		}
		private function updateKillBoss(e:SceneDuplicateMoneyUpdateEvent):void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		private function updateCombo(e:SceneDuplicateMoneyUpdateEvent):void
		{
			var num:int = duplicateMonyeInfo.cutterBatterNum;
			if(num > 0)
			{
				if(!_container.visible)
				{
					GlobalAPI.tickManager.addTick(this);
					_container.visible = true;
				}
				setNumbers(num);
				_comboTickTime = duplicateMonyeInfo.batterTickTime * 25;
				_timeBar.setValue(_comboTickTime, _comboTickTime);
				
			}
			else
			{
				_container.visible = false;
				GlobalAPI.tickManager.removeTick(this);
				duplicateMonyeInfo.batterTickTime = _comboTickTime = 0;
			}
			
		}
		private function setNumbers(combo:int):void
		{
			_comboShow.scaleX = _comboShow.scaleY = 1;
			_comboShow.x = 25;
			_comboShow.y = -16;			
			while(_comboShow.numChildren>0){
				_comboShow.removeChildAt(0);
			}
			
			var comboStr:String = combo.toString();
			for(var i:int=0; i<comboStr.length; i++)
			{
				var mc:Bitmap = new Bitmap(new _numClass[int(comboStr.charAt(i))] as BitmapData);
				mc.x = _comboShow.width - i*3;
				_comboShow.addChild(mc);
			}
			_txtCombo.x = _comboShow.x + _comboShow.width;
			TweenLite.from(_comboShow,0.2,{scaleX:2.5,scaleY:2.5,x:-29,y:-87});
		}
		public function show():void
		{
			
		}
		public function hide():void
		{
			
		}
		public function get duplicateMonyeInfo():DuplicateMoneyInfo
		{
			return _mediator.duplicateMonyeInfo;
		}
		public function dispose():void
		{
			removeEvents();
			GlobalAPI.tickManager.removeTick(this);	
			if(parent)parent.removeChild(this);
		}
			
	}
}