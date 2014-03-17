package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.activity.ActiveTemplateInfoList;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActiveStartEvents;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	
	public class SevenActivityView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		
		
		public function SevenActivityView()
		{
			super();
			//			_index = 11;
			init();
			initEvent();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new SevenActivityView() as IActivityView;
			}
			return instance;
		}
		public function hideEffect():void
		{
			_effect.visible = false;
		}
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnCarnivalAsset") as MovieClip);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = false;
		}
		
		override public function show(arg1:int=0, arg2:Object=null, isDispatcher:Boolean=false):void
		{
			super.show(arg1, arg2, isDispatcher);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function onClick(e:MouseEvent):void
		{
			SetModuleUtils.addSevenActivity();
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.sevenActivity"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
		
		override protected function removeEvent():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			super.removeEvent();
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
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