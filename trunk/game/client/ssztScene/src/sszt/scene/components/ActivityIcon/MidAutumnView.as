package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	/**
	 * 中秋活动 
	 * @author chendong
	 * 
	 */	
	public class MidAutumnView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		private var _countDown:CountDownView;
		private var _endTime:int = 1388073600;
		private var _startTime:int = 1388073600;
		/**
		 * 是否开启按钮 
		 */
		private static var _isShow:Boolean = true;
		
		public function MidAutumnView()
		{
			super();
			init();
			initEvent();
			initData();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new MidAutumnView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(arg1:int=0,arg2:Object =null,isDispatcher:Boolean=false):void
		{
			super.show(arg1,arg2,isDispatcher);
		}
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnMidAutumnAsset2") as MovieClip);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			addChild(_btn);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(55,18);
			_countDown.move(0,55);
			addChild(_countDown);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
		}
		
		
		private function initData():void
		{
			OpenActivityTemplateList.activityTypeRecArray1;
			_startTime = (OpenActivityTemplateList.activityTypeRecArray1[0] as OpenActivityTemplateListInfo).start_time;
			_endTime = (OpenActivityTemplateList.activityTypeRecArray1[0] as OpenActivityTemplateListInfo).end_time;
			var t:int = _endTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000  < 0  ? 0:_endTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000 ;
			var t1:int = _startTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000;
			if(t1 > 0)
			{
				_countDown.start(0);
			}
			else
			{
				_countDown.start( t );
			}			
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_countDown.addEventListener(Event.COMPLETE,hide);
		}
		private function onClick(e:MouseEvent):void
		{
			_effect.visible = false;
			SetModuleUtils.addMidAutmnActivity();
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.midAutumn"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			// TODO Auto Generated method stub
			super.removeEvent();
			_countDown.removeEventListener(Event.COMPLETE,hide);
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
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