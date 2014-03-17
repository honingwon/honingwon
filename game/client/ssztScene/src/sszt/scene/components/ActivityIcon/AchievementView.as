package sszt.scene.components.ActivityIcon
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;

	public class AchievementView extends BaseIconView
	{
		
		protected static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		private var _effect:BaseLoadEffect;
		
		private var _targetAmount:AmountFlashView;
		
		public function AchievementView()
		{
			super();
//			_index = 2;
			init();
			initEvent();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new AchievementView() as IActivityView;
			}
			return instance;
		}
		
		
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnScoreAsset") as MovieClip);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = false;
			
		}
		
		override protected function initEvent():void
		{
			// TODO Auto Generated method stub
			super.initEvent();
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardA);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetList);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardA);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetList);
		}
		
		private function getTargetAwardA(evt:ModuleEvent):void
		{
			setTargetNum(int(evt.data.num));
		}
		
		private function updateTargetList(evt:ModuleEvent):void
		{
			setTargetNum(int(evt.data.num));
		}
		
		private function setTargetNum(num:int):void
		{
			var tarNum:int=0;
			var achNum:int=0;
			var i:int=0;
			for(;i<TargetUtils.TARGET_TYPE_NUM;i++)
			{
				tarNum += TargetUtils.getTargetCompleteNum(i);
			}
			i = 1;
			for(;i<=TargetUtils.ACH_TYPE_NUM;i++)
			{
				achNum += TargetUtils.getAchCompleteNum(i);
			}
			var totalNum:int = tarNum + achNum;
			if(totalNum > 0)
			{
				_effect.visible = true;
				
				if(!_targetAmount)
				{
					_targetAmount = new AmountFlashView();
					_targetAmount.move(34,1);
					addChild(_targetAmount);
				}
				_targetAmount.setValue(totalNum.toString());
				
			}else{
				_effect.visible = false;
				
				if(_targetAmount && _targetAmount.parent)
				{
					_targetAmount.parent.removeChild(_targetAmount);
					_targetAmount = null;
				}
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
//			QuickTips.show("成就系统暂未开放！");
			SetModuleUtils.addTarget();
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("成就系统",null,new Rectangle(e.stageX,e.stageY,0,0));
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
			if(_targetAmount && _targetAmount.parent)
			{
				_targetAmount.parent.removeChild(_targetAmount);
				_targetAmount = null;
			}
			instance = null;
			
			if(parent) parent.removeChild(this);
		}
		
	}
}