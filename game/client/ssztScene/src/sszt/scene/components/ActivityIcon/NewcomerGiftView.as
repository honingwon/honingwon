package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.newcomerGift.NewcomerGiftPanel;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.NewcomerGiftMediator;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;

	public class NewcomerGiftView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _mediator:NewcomerGiftMediator;
		private var _currentGiftItemTemplateId:int;
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		private var _canGetGift:Boolean;
		private var _iconEffect:BaseLoadEffect;
		
		private var _txtPop:MAssetLabel;
		
		public function NewcomerGiftView()
		{
			super();
//			_index = 1;
			init();
			initEvent();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new NewcomerGiftView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(currentGiftItemTemplateId:int=0, mediator:Object=null,isDispatcher:Boolean=false):void
		{
			_currentGiftItemTemplateId = currentGiftItemTemplateId;
			if(!_mediator)
			{
				_mediator = mediator as NewcomerGiftMediator;
			}
			//判断能不能领取，如果能够领取则提示玩家。
			judgeCanGetGift();
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,playerUpgradeHandler);
			
			super.show(currentGiftItemTemplateId,mediator,isDispatcher);
		}
		
		
		private function playerUpgradeHandler(e:CommonModuleEvent):void
		{
			judgeCanGetGift();
		}
		
		private function judgeCanGetGift():void
		{
			var item:ItemTemplateInfo = ItemTemplateList.getTemplate(_currentGiftItemTemplateId);
			var playerLevel:int = GlobalData.selfPlayer.level;
			_canGetGift = playerLevel >= item.needLevel;
			_iconEffect.visible = _canGetGift;
			_txtPop.visible = !_canGetGift;
			_txtPop.setValue(LanguageManager.getWord("ssztl.common.levelValue",item.needLevel)+LanguageManager.getWord("ssztl.common.getLabel"));
			if(_canGetGift && playerLevel >= 10)
			{
				if(_mediator.sceneModule.newcomerGiftPanel == null)
				{
					_mediator.sceneModule.newcomerGiftPanel = new NewcomerGiftPanel(_mediator, _currentGiftItemTemplateId);
					GlobalAPI.layerManager.addPanel(_mediator.sceneModule.newcomerGiftPanel);
					_mediator.sceneModule.newcomerGiftPanel.addEventListener(Event.CLOSE,newcomerGiftPanelCloseHandler);
				}
				else
				{
					if(GlobalAPI.layerManager.getTopPanel() != _mediator.sceneModule.newcomerGiftPanel)
					{
						_mediator.sceneModule.newcomerGiftPanel.setToTop();
					}
				}
			}
		}
		
		private function newcomerGiftPanelCloseHandler(evt:Event):void
		{
			if(_mediator.sceneModule.newcomerGiftPanel)
			{
				_mediator.sceneModule.newcomerGiftPanel.removeEventListener(Event.CLOSE,newcomerGiftPanelCloseHandler);
				_mediator.sceneModule.newcomerGiftPanel = null;
			}
		}
		
		override protected function layout(e:SceneModuleEvent):void
		{
			if(e.data != instance)
			{
				setPosition();
			}
		}
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnGiftAsset") as MovieClip);
			addChild(_btn);
			
//			_iconEffect = AssetUtil.getAsset("ssztui.scene.QuickIconEffectAsset") as MovieClip;
//			_iconEffect.x = _iconEffect.y = 10;
//			_iconEffect.mouseEnabled = false;
//			_iconEffect.mouseChildren = false;
//			addChild(_iconEffect);
//			_iconEffect.visible = false;
			
			_iconEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_iconEffect.move(27,26);
			_iconEffect.play();
			addChild(_iconEffect);
			_iconEffect.visible = false;
			
			_txtPop = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_txtPop.textColor = 0xff0000;
			_txtPop.move(27,55);
			addChild(_txtPop);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,playerUpgradeHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			_mediator.sendNotification(SceneMediatorEvent.SHOW_NEWCOMER_GIFT_PANEL, {
				giftItemTemplateId : _currentGiftItemTemplateId
			});
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