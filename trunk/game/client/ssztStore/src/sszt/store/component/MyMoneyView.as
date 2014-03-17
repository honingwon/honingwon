package sszt.store.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;

	public class MyMoneyView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _element:IMovieWrapper;
		private var _yuanBao:MAssetLabel;
		private var _bindYuanBao:MAssetLabel;
		
		public function MyMoneyView()
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(35,0,99,22)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(201,0,99,22)),
			]);
			addChild(_bg as DisplayObject);
			_bg.alpha = 0.6;
			
			_element = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(112,2,18,18),new Bitmap(StorePanel.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(278,2,18,18),new Bitmap(StorePanel.bindYuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,3,50,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(142,3,50,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.bindYuanBao"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addChild(_element as DisplayObject);
			
			_yuanBao = new MAssetLabel(String(GlobalData.selfPlayer.userMoney.yuanBao),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_yuanBao.move(42,3);
			addChild(_yuanBao);
			
			_bindYuanBao = new MAssetLabel(String(GlobalData.selfPlayer.userMoney.bindYuanBao),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_bindYuanBao.move(208,3);
			addChild(_bindYuanBao);
			
			initEvent();
		}
		private function initEvent():void
		{
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
		}
		private function moneyUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBao.setValue(String(GlobalData.selfPlayer.userMoney.yuanBao));
			_bindYuanBao.setValue(String(GlobalData.selfPlayer.userMoney.bindYuanBao));
		}
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_element)
			{
				_element.dispose();
				_element = null;
			}
			_yuanBao = null;
			_bindYuanBao = null;
		}
	}
}