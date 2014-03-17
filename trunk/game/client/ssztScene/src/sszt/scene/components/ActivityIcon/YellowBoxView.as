package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.YellowBoxTemplateList;
	import sszt.core.data.openActivity.YellowBoxTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.YellowBoxEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	/**
	 * 黄钻特权
	 * @author chendong
	 * 
	 */	
	public class YellowBoxView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		/**
		 * 是否显示特效 
		 */
		private static var _isEffectShow:Boolean = true;
		
		/**
		 * 0:登录已经点击按钮过, 1:登录已经未击按钮过
		 */
		private var _isLogin:int = 1;
		
		public function YellowBoxView()
		{
			super();
//			_index = 7;
			init();
			initEvent();
			initData();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new YellowBoxView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(arg1:int=0,arg2:Object =null,isDispatcher:Boolean=false):void
		{
//			if(_isEffectShow)
//			{
//				_effect.visible = true;
//			}
			
			initData();
			super.show(arg1,arg2,isDispatcher);
		}
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnYellowVipAsset") as MovieClip);
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
			// TODO Auto Generated method stub
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.addModuleEventListener(YellowBoxEvent.GET_INFO,yellowBoxViewInfo);
		}
		
		
		private function initData():void
		{
//			if(_isEffectShow || _isLogin == 1 || (!GlobalData.yellowBoxInfo.isReceNewPack || GlobalData.yellowBoxInfo.receDayPack == 0 || getLevlUp(GlobalData.yellowBoxInfo.levelUpPack)))
//			{
//				_effect.visible = true;
//			}
//			else
//			{
//				_effect.visible = false;
//			}
			if(GlobalData.tmpIsYellowVip == 1)
			{
				if(_isEffectShow || _isLogin == 1 || (!GlobalData.yellowBoxInfo.isReceNewPack || GlobalData.yellowBoxInfo.receDayPack == 0 || getLevlUp(GlobalData.yellowBoxInfo.levelUpPack)))
				{
					_effect.visible = true;
				}
				else
				{
					_effect.visible = false;
				}
			}
			else
			{
				if(_isEffectShow || _isLogin == 1)
				{
					_effect.visible = true;
				}
				else
				{
					_effect.visible = false;
				}
			}
		}
		
		private function getLevlUp(returnLevel:int=0):Boolean
		{
			var isReturn:Boolean = false;
			var templateObj:YellowBoxTemplateListInfo;
			var temArray:Array = YellowBoxTemplateList.yellowBoxTypeTwoArray;
			for(var i:int=0;i<temArray.length;i++)
			{
				templateObj = temArray[i];
				if(templateObj.level > returnLevel && GlobalData.selfPlayer.level >= templateObj.level)
				{
					isReturn = true;
					break;
				}
			}
			return isReturn;
		}
		
		private function yellowBoxViewInfo(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function onClick(e:MouseEvent):void
		{
			_isLogin = 0;
			_isEffectShow = false;
			_effect.visible = false;
			initData();
			SetModuleUtils.addYellowBox();
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.yellowBox"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			
			ModuleEventDispatcher.removeModuleEventListener(YellowBoxEvent.GET_INFO,yellowBoxViewInfo);
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