package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
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
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	/**
	 * 首冲 
	 * @author chendong
	 * 
	 */	
	public class FirstPayView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		
		/**
		 * 是否开启按钮 
		 */
		private static var _isShow:Boolean = true;
		/**
		 * 1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级 
		 */		
		private var groupId:int = 1;
		
		public function FirstPayView()
		{
			super();
			init();
			initEvent();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new FirstPayView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(arg1:int=0,arg2:Object =null,isDispatcher:Boolean=false):void
		{
			if(isGetAward())
			{
				return;
			}
			super.show(arg1,arg2,isDispatcher);
		}
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnFirstPayAsset") as MovieClip);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
		}
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getAwardDataFirst);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardDataFirst);
		}
		private function onClick(e:MouseEvent):void
		{
			_effect.visible = false;
			SetModuleUtils.addFirstRecharge();
		}
		
		private function getAwardDataFirst(evt:ModuleEvent):void
		{
			if(isGetAward())
			{
				dispose();
			}
		}
		
		private function isGetAward():Boolean
		{
			var obj:Object = GlobalData.openActivityInfo.activityDic[groupId];
			if(obj && obj.idArray && (obj.idArray as Array).length >0 )
			{
				return true;
			}
			return false;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if(GlobalData.functionYellowEnabled)
				TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.firstPayTip"),null,new Rectangle(e.stageX,e.stageY,0,0));
			else
				TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.firstPayTip2"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardDataFirst);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getAwardDataFirst);
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