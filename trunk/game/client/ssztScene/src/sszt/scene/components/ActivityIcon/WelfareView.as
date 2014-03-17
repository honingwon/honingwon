package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.VipType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.events.WelfareEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;

	public class WelfareView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		private var _effect:BaseLoadEffect;
		
		public function WelfareView()
		{
			super();
//			_index = 3;
			init();
			initEvent();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new WelfareView() as IActivityView;
			}
			return instance;
		}
		
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnWelfareAsset") as MovieClip);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = true;
		}
		private function onClick(e:MouseEvent):void
		{
//			QuickTips.show("福利系统暂未开放！");
			SetModuleUtils.addWelfarePanel();
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("点击可查看活动公告，每日福利",null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		override protected function initEvent():void
		{
			super.initEvent();
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.AWARD_GET_UPDATE,updateHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.AWARD_GET_UPDATE,updateHandler);
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function updateHandler(evt:WelfareEvent):void
		{
			var visible:Boolean;
			var isChargeUser:Boolean =  GlobalData.selfPlayer.money > 0;
			var isVip:Boolean = GlobalData.selfPlayer.getVipType() > VipType.NORMAL;
			
			
			
			if(
				GlobalData.loginRewardData.got &&
				GlobalData.loginRewardData.gotDuplicate &&
				GlobalData.loginRewardData.gotDuplicate &&
				GlobalData.loginRewardData.gotOffLineTimes &&
				GlobalData.loginRewardData.gotMultiDuplicateNum &&
				(!isVip || (GlobalData.selfPlayer.isVipBindYuanbaoGot && GlobalData.selfPlayer.isVipBuffGot && GlobalData.selfPlayer.isVipCopperGot)) &&
				(!isChargeUser || GlobalData.loginRewardData.gotChargeUser)
			)
			{
				visible = false;

			}
			else
			{
				visible = true;
			}
			
			_effect.visible = visible;
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