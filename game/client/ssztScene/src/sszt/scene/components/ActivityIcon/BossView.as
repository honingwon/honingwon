package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.socketHandlers.challenge.ChallengeInfoSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ChallengeEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;

	/**
	 * 试炼 
	 * @author chendong
	 * 
	 */	
	public class BossView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		private var _effect:BaseLoadEffect;
		private var _targetAmount:AmountFlashView;
		
		public function BossView()
		{
			super();
			init();
			initEvent();
			
			
		}
		
		override public function show(arg1:int=0, arg2:Object=null, isDispatcher:Boolean=false):void
		{
			// TODO Auto Generated method stub
			super.show(arg1, arg2, isDispatcher);
			ChallengeInfoSocketHandler.send();
		}
		
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new BossView() as IActivityView;
			}
			return instance;
		}
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnBossAsset") as MovieClip);
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
			super.initEvent();
			ModuleEventDispatcher.addModuleEventListener(ChallengeEvent.CHALLENGE_BOSS_INFO,numUpdateHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			ModuleEventDispatcher.removeModuleEventListener(ChallengeEvent.CHALLENGE_BOSS_INFO,numUpdateHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
			
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function changeSceneHandler(e:SceneModuleEvent):void
		{
			if(MapTemplateList.isChallenge(GlobalData.currentMapId))
			{
				ChallengeInfoSocketHandler.send();
			}
		}
		
		private function numUpdateHandler(event:Event):void
		{
			if(this.parent)
			{
				var num:int = GlobalData.challInfo.num;
				num = 10 - num
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
			if(GlobalData.selfPlayer.level >= 45)
			{
				if(!_targetAmount)
				{
					_targetAmount = new AmountFlashView();
					_targetAmount.move(34,1);
					addChild(_targetAmount);
				}
				_btn.filters = [];
				_targetAmount.setValue(num.toString());
			}
			else
			{
				_btn.filters = [new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0])];
			}
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
			if(GlobalData.selfPlayer.level < 45)
			{
				SetModuleUtils.addActivity(new ToActivityData(2,0,26));
			}
			else
			{
				SetModuleUtils.addChallenge();
			}
			
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("BOSS试炼",null,new Rectangle(e.stageX,e.stageY,0,0));
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