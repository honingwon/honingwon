package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.PetPVPModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	public class PetPVPIconView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _countDown:CountDownView;
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		
		public function PetPVPIconView()
		{
			super();
			init();
			initEvent();
		}
		
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new PetPVPIconView() as IActivityView;
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
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnPetPvpAsset") as MovieClip);
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
			
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.UPDATE_ICON_VIEW,updateIconViewHandler);
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.UPDATE_COUNT_DOWN,updateCountDownHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.UPDATE_ICON_VIEW,updateIconViewHandler);
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.UPDATE_COUNT_DOWN,updateCountDownHandler);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(GlobalData.petList.petCount > 0)
			{
				SetModuleUtils.addPetPVP();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord('ssztl.petpvp.hasNoPet'));
			}			
			_effect.visible = false;
		}
		
		protected function updateCountDownHandler(e:PetPVPModuleEvent):void
		{
			var value:int = e.data as int;
			startCountDown(value);
		}
		
		protected function updateIconViewHandler(e:PetPVPModuleEvent):void
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
//			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.worldBoss"),null,new Rectangle(e.stageX,e.stageY,0,0));
			TipsUtil.getInstance().show('宠物斗坛',null,new Rectangle(e.stageX,e.stageY,0,0));
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