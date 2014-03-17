package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import scene.events.SceneEvent;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.ui.button.MAssetButton1;
	
	public class CityCraftAuctionView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _countDown:CountDownView;
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		
		public function CityCraftAuctionView()
		{
			super();
			init();
			initEvent();
		}
		
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new CityCraftAuctionView() as IActivityView;
			}
			return instance;
		}
		
		private function init():void
		{
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(55,18);
			_countDown.move(0,55);
			addChild(_countDown);
			_countDown.visible = false;
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnCityAsset2") as MovieClip);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = true;			
		}		
		
		override protected function initEvent():void
		{
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CITY_CRAFT_NEW_AUCTION,updateIconViewHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CITY_CRAFT_NEW_AUCTION,updateIconViewHandler);
		}
		
		private function onClick(e:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_AUCTION_PANEL));						
			_effect.visible = false;
		}
		
		protected function updateCountDownHandler(e:SceneModuleEvent):void
		{
			var value:int = e.data as int;
			startCountDown(value);
		}
		
		protected function updateIconViewHandler(e:SceneModuleEvent):void
		{
			var value:Boolean = e.data as Boolean;
			_effect.visible = value;
		}
		
		public function startCountDown(time:int):void
		{
			_countDown.visible = true;
			_countDown.start(time);
			_countDown.addEventListener(Event.COMPLETE,completePay);
			_effect.visible = false;
		}
		
		private function completePay(e:Event):void
		{
			_countDown.removeEventListener(Event.COMPLETE,completePay);
			_countDown.visible = false;
			_effect.visible = true;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show('竞拍攻打权',null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function layout(e:SceneModuleEvent):void
		{
			if(e.data != instance)
			{
				setPosition();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(_btn)
			{
				_btn.dispose();
				_btn = null;
			}
			if(_effect)
			{
				_effect.dispose();
				_effect = null;
			}
			
			instance = null;
			if(parent) parent.removeChild(this);
		}
		
	}
}