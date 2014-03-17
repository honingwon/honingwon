package sszt.scene.components.bank.bankTabPanel
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	/**
	 * ‘投资计划’选项卡下奖励列表项
	 * */
	public class BankAwardItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _requireLabel:MAssetLabel;
		private var _moneyLabel:MAssetLabel;
		private var _stateLabel:MAssetLabel;
		private var _bindYuanBaoAsset:Bitmap;
		private var _awardState:int;//0未达成 1已领取 2可领取
		
		public function BankAwardItemView(index:int)
		{
			super();
			initialView();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(0,29,565,2)),
				
			]);
			addChild(_bg as DisplayObject);
			
			var colX:Array = [10,357,500];
			
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,384,30);
			graphics.endFill();
			
			_requireLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_requireLabel.move(colX[0],7);
			addChild(_requireLabel);			
			
			_bindYuanBaoAsset = new Bitmap(MoneyIconCaches.bingYuanBaoAsset);
			_bindYuanBaoAsset.x = 330;
			_bindYuanBaoAsset.y = 7;
			addChild(_bindYuanBaoAsset);
			
			_moneyLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.CENTER);
			_moneyLabel.move(colX[1],7);
			addChild(_moneyLabel);
			
			_stateLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_stateLabel.move(colX[2],7);
			addChild(_stateLabel);
		}
		
		
		public function set require(value:String):void
		{
			_requireLabel.setValue(value);
		}
		
		public function set money(value:int):void
		{
			_moneyLabel.setValue(value.toString());
		}
		
		public function set state(value:int):void
		{
			_awardState = value;
			updateState();
		}		
		private function updateState():void
		{
			if(_awardState == 0)
			{
				_stateLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.awardState"));
			}
			else if(_awardState == 1)
			{
				_stateLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.awardState1"));
			}
			else if(_awardState == 2)
			{
				_stateLabel.setHtmlValue(LanguageManager.getWord("ssztl.bank.awardState2"));
			}
		}		
		
		public function dispose():void
		{

			_requireLabel = null;
			_moneyLabel = null;
			_stateLabel = null;
		}

	}
}