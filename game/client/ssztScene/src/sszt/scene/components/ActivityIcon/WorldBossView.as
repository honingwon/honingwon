package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.worldBossInfo.WorldBossUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.worldBoss.GetWorldBossNumSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;

	public class WorldBossView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		private var _effect:BaseLoadEffect;
		private var _targetAmount:AmountFlashView;
		
		
		public function WorldBossView()
		{
			super();
//			_index = 6;
			init();
			initEvent();
			
			GetWorldBossNumSocketHandler.send();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new WorldBossView() as IActivityView;
			}
			return instance;
		}
		
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnWorldBossAsset") as MovieClip);
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
			GlobalData.worldBossInfo.addEventListener(WorldBossUpdateEvent.UPDATE_REMAINING_NUM,numUpdateHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function numUpdateHandler(event:Event):void
		{
			if(this.parent)
			{
				var num:int = GlobalData.worldBossInfo.remainingNum;
				if(num == 0)
				{
					removeBossNum()
				}
				else
				{
					setBossNum(num);
				}
			}
		}
		
		private function setBossNum(num:int):void
		{
			if(!_targetAmount)
			{
				_targetAmount = new AmountFlashView();
				_targetAmount.move(34,1);
				addChild(_targetAmount);
			}
			_targetAmount.setValue(num.toString());
		}
		
		private function removeBossNum():void
		{
			if(_targetAmount && _targetAmount.parent)
			{
				_targetAmount.parent.removeChild(_targetAmount);
				_targetAmount = null;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
//			QuickTips.show("BOSS试炼系统即将开放！");
			SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.BOSS,0));
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.worldBoss"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			instance = null;
			
			if(parent) parent.removeChild(this);
		}
		
	}
}