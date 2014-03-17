package sszt.scene.components.bigBossWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class BigBossWarResultPanel extends MSprite implements IPanel
	{
		private const DEFAULT_WIDTH:int = 483;
		private const DEFAULT_HEIGHT:int = 190;
		
		private var _bg:Bitmap;
		private var _bgTitle:Bitmap;
		
		private var _isLive:Boolean;
		private var _itemTemplateId:int;
		private var _myDamage:int;
		
		private var _isLiveLabel:MAssetLabel;
		private var _cell:BaseItemInfoCell;
		private var _tagReward:MAssetLabel;
		private var _txtCopper:MAssetLabel;
		private var _txtReward:MAssetLabel;
		
		private var _btnSure:MCacheAssetBtn1;
		private var _picPath:String;
		private var _titlePath:String;
		
		public function BigBossWarResultPanel(isLive:Boolean,itemTemplateId:int,myDamage:int)
		{
			_isLive = isLive;
			_itemTemplateId = itemTemplateId;
			_myDamage = myDamage;
			
			init();
			initEvent();
		}
		
		protected function init():void
		{
			setPanelPosition(null);
			
			_bg = new Bitmap();
			addChild(_bg);
			
			_bgTitle =new Bitmap();
			_bgTitle.x = 156;
			_bgTitle.y = 18;
			addChild(_bgTitle);
			
			_titlePath = _isLive ? 'challengeNo.png':'challengeYes.png'
			_isLiveLabel = new MAssetLabel(_titlePath,MAssetLabel.LABEL_TYPE1,'left');
//			addChild(_isLiveLabel);
			
			_tagReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE22);
			_tagReward.move(DEFAULT_WIDTH/2,76);
			addChild(_tagReward);
			_tagReward.setHtmlValue(LanguageManager.getWord("ssztl.common.award"));
			
			_txtCopper = new MAssetLabel("",MAssetLabel.LABEL_TYPE22);
			_txtCopper.move(DEFAULT_WIDTH/2,90);
			addChild(_txtCopper);			
			_txtCopper.setHtmlValue(LanguageManager.getWord("ssztl.common.copper")+"+"+getCopper());
			
			_txtReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtReward.move(DEFAULT_WIDTH/2,145);
			addChild(_txtReward);
			_txtReward.setHtmlValue(LanguageManager.getWord("ssztl.bitBoss.rewardTip2"));
			
			_cell = new BaseItemInfoCell();
			_cell.info = ItemTemplateList.getTemplate(_itemTemplateId);
			_cell.move(226,105);
			addChild(_cell);
			
			_btnSure = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.sure"));
			_btnSure.move(207,172);
			addChild(_btnSure);
		}
		private function initEvent():void
		{
			_picPath = GlobalAPI.pathManager.getBannerPath("bgResult.png");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadBgComplete,SourceClearType.NEVER);
			
			_titlePath  = GlobalAPI.pathManager.getBannerPath(_titlePath);
			GlobalAPI.loaderAPI.getPicFile(_titlePath, loadTitleComplete,SourceClearType.NEVER);
			
			_btnSure.addEventListener(MouseEvent.CLICK,btnSureClickHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		private function removeEvent():void
		{
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadBgComplete);
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadTitleComplete);
			
			_btnSure.removeEventListener(MouseEvent.CLICK,btnSureClickHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		protected function btnSureClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		private function loadBgComplete(data:BitmapData):void
		{
			_bg.bitmapData = data;
		}
		private function loadTitleComplete(data:BitmapData):void
		{
			_bgTitle.bitmapData = data;
		}
		private function getCopper():int
		{
			var copper:int;
			if(_myDamage < 100000)
				copper = 10000;
			else if(_myDamage > 6000000)
				copper = 600000;
			else 
				copper = _myDamage/10;
			return copper;
		}
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		private function closeClickHandler(evt:MouseEvent):void
		{			
			doEscHandler();
		}
		public function doEscHandler():void
		{
			dispose();
		}
		override public function dispose():void
		{
			super.dispose();
			_isLiveLabel= null;
			if(_bg)
			{
				_bg = null;
			}
			_bgTitle = null;
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
		}
		
		
	}
}