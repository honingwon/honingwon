package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.MayaCopyEntranceView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.PetPVPModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	public class MayaIconView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		
		public function MayaIconView()
		{
			super();
			init();
			initEvent();
		}
		
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new MayaIconView() as IActivityView;
			}
			return instance;
		}
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnMayaAsset") as MovieClip);
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
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.UPDATE_ICON_VIEW,updateIconViewHandler);
		}
		
		private function onClick(e:MouseEvent):void
		{
			_effect.visible = false;
			//断玩家等级是否达到
			if(GlobalData.selfPlayer.level < 45)
			{
				QuickTips.show("45级以后才可进入！");
//				SetModuleUtils.addActivity(new ToActivityData(2,0,29));
			}
			else
			{
				SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,10));
			}
//			MayaCopyEntranceView.getInstance().show(function():void{
//				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_NPC_COPY_PANEL,{npcId:102136,levelId:0,copyType:0}));
//			});
		}
		
		protected function updateIconViewHandler(e:PetPVPModuleEvent):void
		{
			var value:Boolean = e.data as Boolean;
			_effect.visible = value;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show('圣地',null,new Rectangle(e.stageX,e.stageY,0,0));
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