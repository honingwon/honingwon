package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.constData.ShopID;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pvp.ActiveResourceWarEnterSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.resourceWar.ResourceWarInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;

	public class ResourceWarPanel extends MPanel
	{
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _picPath:String;
		private var _enterBtn:MCacheAssetBtn1;
		private var _gxShop:MCacheAssetBtn1;
		
		private const CELL_POS:Array = [
			new Point(33,224),
			new Point(72,224),
			new Point(111,224),
			new Point(184,224),
			new Point(223,224),
			new Point(262,224),
			new Point(184,263),
			new Point(223,263),
			new Point(371,224)
		];
		
		private var _itemList:Array;
		private var _cellList:Array;
		
		public function ResourceWarPanel(mediator:SceneMediator)
		{
			_itemList = [];
			_cellList = [];
			
			_itemList = _itemList.concat(ResourceWarInfo.CAMP_REWARDS);
			_itemList.push(ResourceWarInfo.REWARDS_FIRST);
			_itemList.push(ResourceWarInfo.REWARDS_SECOND);
			_itemList.push(ResourceWarInfo.REWARDS_THIRD);
			_itemList.push(ResourceWarInfo.REWARDS_FORTH);
			_itemList.push(ResourceWarInfo.REWARDS_FIFTH);
			_itemList.push(8);
			
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.dotaTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.dotaTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(646,387);
			
			var scoreList:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,"left");
			scoreList.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,9)]);
			scoreList.setHtmlValue(LanguageManager.getWord("ssztl.pvp.dotaScoreList"));
			
			var scoreTag:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			scoreTag.setLabelType([new TextFormat("SimSun",12,0x82df69,null,null,null,null,null,null,null,null,null,9)]);
			scoreTag.setHtmlValue(LanguageManager.getWord("ssztl.pvp.dotaScoreTag"));
			
			var info:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,"left");
			info.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,6)]);
			info.setHtmlValue(LanguageManager.getWord("ssztl.pvp.dotaDirections"));
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,630,377)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,624,369)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgLayout = new Bitmap();
			_bgLayout.x = 14;
			_bgLayout.y = 8;
			addContent(_bgLayout);
			_picPath = GlobalAPI.pathManager.getBannerPath("dotaStart.jpg");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_bg2 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(31,25,150,15),info),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(467,38,161,200),scoreTag),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(475,59,161,310),scoreList),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(18,320,146,40),new MAssetLabel(LanguageManager.getWord("ssztl.pvp.dotaTextReward1"),MAssetLabel.LABEL_TYPE_YAHEI)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(168,320,146,40),new MAssetLabel(LanguageManager.getWord("ssztl.pvp.dotaTextReward2"),MAssetLabel.LABEL_TYPE_YAHEI)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(317,320,146,40),new MAssetLabel(LanguageManager.getWord("ssztl.pvp.dotaTextReward3"),MAssetLabel.LABEL_TYPE_YAHEI)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(33,224,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(72,224,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(111,224,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(33,263,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(72,263,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(111,263,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(184,224,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(223,224,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(262,224,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(184,263,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(223,263,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(262,263,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(371,224,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addContent(_bg2 as DisplayObject);
			
			_enterBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.pvp.dotaBtnLabel'));
			_enterBtn.move(195,120);
			if(!MapTemplateList.isResourceWarMap())
			{
				addContent(_enterBtn);
			}
			
			_gxShop = new MCacheAssetBtn1(0,2,LanguageManager.getWord('ssztl.pvp.dotaGXShop'));
			_gxShop.move(358,275);
			addContent(_gxShop);
			
			
			var itemId:int;
			var itemTemplateInfo:ItemTemplateInfo;
			var cell:ResourceWarRewardCell;
			var i:int = 0;
			var pos:Point;
			for each(itemId in _itemList)
			{
				itemTemplateInfo = ItemTemplateList.getTemplate(itemId);
				cell = new ResourceWarRewardCell();
				addContent(cell);
				pos = CELL_POS[i];
				cell.move(pos.x, pos.y)
				cell.info = itemTemplateInfo;
				_cellList.push(cell);
				i++;
			}
		}
		private function initEvent():void
		{
			_enterBtn.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			
			_gxShop.addEventListener(MouseEvent.CLICK,btnGxShopClickHandler);
		}
		
		private function removeEvent():void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			_gxShop.removeEventListener(MouseEvent.CLICK,btnGxShopClickHandler);
		}
		
		private function btnGxShopClickHandler(event:MouseEvent):void
		{
			SetModuleUtils.addExStore(new ToStoreData(ShopID.GX,2));
		}
		
		private function btnEnterClickHandler(event:MouseEvent):void
		{
			var available:Boolean = false;
			var activityInfo:ActiveStarTimeData = GlobalData.activeStartInfo.activeTimeInfo['1008']
			if(activityInfo && activityInfo.state == 1)
			{
				available = true;
			}
			if(!available)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.activity.activityUnavailable'));
				return;
			}
			if(GlobalData.selfPlayer.level < 35)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.scene.unEnterLevelNotMatch'));
				return;
			}
			var now:int = GlobalData.systemDate.getSystemDate().getTime()/1000;
			var quitTime:int =GlobalData.selfPlayer.resourceWarQuitTime;
			if(now - quitTime <= 2*60)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.resourceWar.enterTimeLimitAlert'));
				return;
			}
			ActiveResourceWarEnterSocketHandler.send();
			dispose();
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
		}
		
		override public function dispose():void
		{
			removeEvent();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			_bgLayout = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_enterBtn)
			{
				_enterBtn.dispose();
				_enterBtn = null;
			}
			if(_gxShop)
			{
				_gxShop.dispose();
				_gxShop = null;
			}
			super.dispose();
		}
	}
}