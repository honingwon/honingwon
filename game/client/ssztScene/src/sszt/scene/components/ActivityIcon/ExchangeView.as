package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	
	/**
	 * 兑换
	 * 
	 */	
	public class ExchangeView extends MSprite
	{
		private static var instance:ExchangeView;
		
		private var _btn:MAssetButton1;
		private var _targetAmount:AmountFlashView;
		
		public function ExchangeView()
		{
			super();
			init();
			initEvent();
		}
		public static function getInstance():ExchangeView
		{
			if(instance == null)
			{
				instance = new ExchangeView() as ExchangeView;
			}
			return instance;
		}
		
		private function init():void
		{
			if(GlobalData.functionFriendInviteEnabled)
			{
				x = 318;
			}
			else
			{
				x = 258;
			}
			y = 40;
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.SceneExchangeBtnAsset") as MovieClip);
			addChild(_btn);
			
			_targetAmount = new AmountFlashView();
			_targetAmount.move(20,-5);
			addChild(_targetAmount);
			_targetAmount.setValue('');
		}
		private function onClick(e:MouseEvent):void
		{
			SetModuleUtils.addActivity(new ToActivityData(4,0));
		}
		public function show(arg1:int = 0,arg2:Object=null,isDispatcher:Boolean=false,num:int = 0):void
		{
			if(!parent)
			{
				GlobalAPI.layerManager.getModuleLayer().addChild(this);
			}
			_targetAmount.setValue(num.toString());
		}
		public function hide(isDispatcher:Boolean=true):void
		{
			if(parent && parent.contains(this) )
			{
//				GlobalAPI.layerManager.getModuleLayer().removeChild(this);
				instance.dispose();
			}
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.exchangeBtnTip"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function initEvent():void
		{
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvent():void
		{
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
			if(_targetAmount)
			{
				_targetAmount.dispose();
				_targetAmount = null;
			}
			instance = null;
			
			if(parent) parent.removeChild(this);
		}
		
	}
}