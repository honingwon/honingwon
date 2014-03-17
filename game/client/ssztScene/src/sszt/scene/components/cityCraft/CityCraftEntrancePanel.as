package sszt.scene.components.cityCraft
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.constData.CampType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.cityCraft.CityCraftAuctionStateSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.resourceWar.ResourceWarRewardCell;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.cityCraft.CityCraftDaysInfoSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftEnterSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;

	public class CityCraftEntrancePanel extends MPanel
	{		
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _picPath:String;
		private var _enterBtn:MCacheAssetBtn1;
		private var _auctionBtn:MCacheAssetBtn1;
		
		private const CELL_POS:Array = [
			new Point(259,221),
			new Point(309,221)
		];
		
		private var _itemList:Array = [292800,292801];
		private var _cellList:Array;
		private var _guildLabel1:MAssetLabel;
		private var _guildLabel2:MAssetLabel;
		private var _guildLabel3:MAssetLabel;
		private var _daysLabel:MAssetLabel;
		private var _tip:Sprite;
		private var _joinPanel:CityCraftJoinPanel;
		
		public function CityCraftEntrancePanel(mediator:SceneMediator)
		{
			_cellList = [];
						
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.commonCityTitleAsset1"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.commonCityTitleAsset1") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(606,376);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,586,363)),
			]);
			addContent(_bg as DisplayObject);
			
			_tip = new Sprite();
			_tip.graphics.beginFill(0,0);
			_tip.graphics.drawRect(13,13,130,26);
			_tip.graphics.endFill();
			addContent(_tip);
			_tip.buttonMode = true;
			
			
			var scoreList:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,"left");
			scoreList.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,9)]);
			scoreList.setHtmlValue(LanguageManager.getWord("ssztl.cityCraft.scoreRules"));
			
			_bgLayout = new Bitmap();
			_bgLayout.x = 13;
			_bgLayout.y = 7;
			addContent(_bgLayout);
			_picPath = GlobalAPI.pathManager.getBannerPath("cityFightBg.jpg");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_bg2 = BackgroundUtils.setBackground([
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(259,221,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(309,221,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addContent(_bg2 as DisplayObject);
			
			_auctionBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.cityCraft.auctionTile1'));
			_auctionBtn.move(100,196);
			addContent(_auctionBtn);	
			
			_enterBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.cityCraft.joinActive'));
			_enterBtn.move(253,323);
			addContent(_enterBtn);						
			
			_guildLabel1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_guildLabel1.textColor = 0xffcc00;
			_guildLabel1.move(145,176);
			addContent(_guildLabel1);
			
			_guildLabel2 = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_guildLabel2.move(461,176);		
			addContent(_guildLabel2);	
			
			_guildLabel3 = new MAssetLabel(GlobalData.cityCraftInfo.defenseGuild,MAssetLabel.LABEL_TYPE_TAG,"left");
			_guildLabel3.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,9)]);
			_guildLabel3.move(100,50);
			
			_daysLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_daysLabel.textColor = 0x33ff00;
			_daysLabel.move(461,200);
			addContent(_daysLabel);
			
			updateNickAndDays();
			
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
			GlobalData.cityCraftInfo.addEventListener(CityCraftEvent.DAYS_UPDATE,daysUpdateHandler);
			CityCraftDaysInfoSocketHandler.send();
			_enterBtn.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			_auctionBtn.addEventListener(MouseEvent.CLICK,btnAuctionClickHandler);
			_tip.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_tip.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			CityCraftAuctionStateSocketHandler.send();
		}
		
		private function removeEvent():void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			_auctionBtn.removeEventListener(MouseEvent.CLICK,btnAuctionClickHandler);
			_tip.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_tip.removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			GlobalData.cityCraftInfo.removeEventListener(CityCraftEvent.DAYS_UPDATE,daysUpdateHandler);
		}
		
		private function daysUpdateHandler(event:CityCraftEvent):void
		{
			updateNickAndDays();
		}
		
		private function updateNickAndDays():void
		{
			var atkNick:String = GlobalData.cityCraftInfo.attackGuild;
			var defNick:String = GlobalData.cityCraftInfo.defenseGuild;
			if(atkNick.length < 1)
				atkNick = "暂无";
			if(defNick.length < 1)
				defNick = "NPC联盟";
			_guildLabel1.setValue(atkNick);
			_guildLabel2.setValue(defNick);
			_guildLabel3.setValue(defNick);
			_daysLabel.setValue(GlobalData.cityCraftInfo.defenseDays+'天');
		}
		
		private function btnEnterClickHandler(event:MouseEvent):void
		{
			var available:Boolean = false;
			var activityInfo:ActiveStarTimeData = GlobalData.activeStartInfo.activeTimeInfo['1013']
			if(activityInfo && activityInfo.state == 1)
			{
				available = true;
			}
			if(!available)
			{				
				var time:Number = GlobalData.systemDate.getSystemDate().hours;
				if(time < 17 || time > 18)//非活动时间
				{	
					CityCraftEnterSocketHandler.send(CampType.ATK_CITY);
					dispose();
					return;
				}
			}
			if(GlobalData.selfPlayer.level < 35)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.scene.unEnterLevelNotMatch'));
				return;
			}
			if(GlobalData.selfPlayer.clubName == GlobalData.cityCraftInfo.attackGuild)
			{
				CityCraftEnterSocketHandler.send(CampType.ATK_CITY);
				dispose();
			}
			else if(GlobalData.selfPlayer.clubName == GlobalData.cityCraftInfo.defenseGuild)
			{
				CityCraftEnterSocketHandler.send(CampType.DEF_CITY);
				dispose();
			}
			else
			{
//				_mediator.showCityCraftJoinPanel();
				if(!_joinPanel)
				{
					_joinPanel = new CityCraftJoinPanel(_mediator);
					_joinPanel.move(13,7);
					addContent(_joinPanel);
					_joinPanel.addEventListener(Event.CLOSE,joinPanelCloseHandler);
				}
			}
//			dispose();
		}
		private function btnAuctionClickHandler(e:Event):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CITY_CRAFT_AUCTION_PANEL));
		}
		private function joinPanelCloseHandler(evt:Event):void
		{
			dispose();
		}
		private function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.cityCraft.joinRules"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
		}
		
		override public function dispose():void
		{
			removeEvent();
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
			if(_auctionBtn)
			{
				_auctionBtn.dispose();
				_auctionBtn = null;
			}
			super.dispose();
		}
	}
}