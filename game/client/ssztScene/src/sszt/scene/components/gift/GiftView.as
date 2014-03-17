package sszt.scene.components.gift
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.ActivityIcon.BaseIconView;
	import sszt.scene.components.ActivityIcon.IActivityView;
	import sszt.scene.components.smallMap.SmallMapView;
	import sszt.scene.socketHandlers.PlayerDairyAwardListSocketHandler;
	import sszt.scene.socketHandlers.PlayerDairyAwardSocketHandler;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;

	/**
	 * 在线奖励
	 * @author chendong
	 */	
	public class GiftView extends BaseIconView 
	{
		protected static var instance:IActivityView;
//		/**
//		 * 是否可领取
//		 * true可领取,fale不可领取 
//		 */
//		private var _canGet:Boolean = false;
		/**
		 * 在线奖励按钮 
		 */
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		private var _canGet:Boolean;
		private var _timer:uint;
		
		public function GiftView()
		{
			super();
			init();
			initEvent();
			_timer = setInterval(
				function():void{
					PlayerDairyAwardListSocketHandler.send();
				},
				60*1000
			);
		}
		
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new GiftView() as IActivityView;
			}
			return instance;
		}
		
		private function init():void
		{	
			var btnAsset:MovieClip = AssetUtil.getAsset("ssztui.scene.TopBtnAwardAsset") as MovieClip;
			if(btnAsset)
			{
				_btn = new MAssetButton1(btnAsset);
				addChild(_btn);
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			
		}
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			var btnAsset:MovieClip = AssetUtil.getAsset("ssztui.scene.TopBtnAwardAsset") as MovieClip;
			_btn = new MAssetButton1(btnAsset);
			addChild(_btn);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.ONLINE_REWARD_CAN_GET,onlineRewardCanGetHandler);
		}
		
		private function onlineRewardCanGetHandler(e:SceneModuleEvent):void
		{
			_canGet = e.data as Boolean;
			if(_canGet)
			{
				playEffect();
			}
			else
			{
				stopEffect();
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,clickHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.ONLINE_REWARD_CAN_GET,onlineRewardCanGetHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
		}
		
		protected function clickHandler(evt:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ONLINE_REWARD_PANEL));
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			var message:String = "";
			if(_canGet)
				message = LanguageManager.getWord("ssztl.scene.getAward");
			else 
				message = LanguageManager.getWord("ssztl.scene.waitForAwordValue");
			TipsUtil.getInstance().show(message,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function playEffect():void
		{
			if(_effect)
			{
				_effect.play(SourceClearType.NEVER);
				addChild(_effect);
			}
		}
		
		private function stopEffect():void
		{
			if(_effect && _effect.parent)
			{
				_effect.stop();
				_effect.parent.removeChild(_effect);
			}
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
			clearInterval(_timer);
			stopEffect();
//			GlobalAPI.tickManager.removeTick(this);
			if(_effect)
			{
				_effect.dispose();
				_effect = null;
			}
//			if(_frame && _frame.parent)
//			{
//				_frame.parent.removeChild(_frame);
//				_frame = null;
//			}
//			_asset = null;
			
			if(_btn)
			{
				_btn.dispose();
				_btn = null;
			}
			instance = null;
			if(parent) parent.removeChild(this);
		}
	}
}