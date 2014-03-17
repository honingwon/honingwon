package sszt.scene.components.guildPVP
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.guildPVP.GuildPVPEnterSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.resourceWar.ResourceWarRewardCell;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.scene.TagRewardAsset;
	import ssztui.scene.TitleGuildPvpAsset;
	
	public class GuildPVPEnterPanel extends MPanel
	{
		private static const AWARD_LIST:Array = [292700,292701,292702,292703,292704,292705,292706,7];
//		private var _mediator:SceneMediator;
		private var _enterBtn:MCacheAssetBtn1;
		private var _bg:IMovieWrapper;
		private var _banner:Bitmap;
		private var _picPath:String;
		private var _awardCells:Array;		
		
		public function GuildPVPEnterPanel()
		{
			_awardCells =[];
//			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new TitleGuildPvpAsset())),true,-1);
			initEvent();
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(356,420);
			
			var info:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,"left");
			info.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,6)]);
			info.setHtmlValue(LanguageManager.getWord("ssztl.guildPVP.firstDirections"));
			
			var info2:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,"left");
			info2.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,5)]);
			info2.wordWrap = true;
			info2.setHtmlValue(LanguageManager.getWord("ssztl.guildPVP.firstDirections1"));
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,336,363)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(10,278,336,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(145,282,62,16),new Bitmap(new TagRewardAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(26,110,150,60),info),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(26,170,320,95),info2),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(60,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(100,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(140,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(180,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(220,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(260,312,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(300,312,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addContent(_bg as DisplayObject);
			
			var i:int=0,x:int=20,y:int=312;
			for(i;i<AWARD_LIST.length;i++)
			{
				var awardCell:ResourceWarRewardCell = new ResourceWarRewardCell();
				awardCell.info = ItemTemplateList.getTemplate(AWARD_LIST[i]);
				awardCell.move(x,y);
				x += 40;
				addContent(awardCell);
				_awardCells.push(awardCell);
			}
			
			_banner = new Bitmap();
			_banner.x = 20;
			_banner.y = 14;
			addContent(_banner);
			_picPath = GlobalAPI.pathManager.getBannerPath("bannerGuildPvp.jpg");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_enterBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.pvp.pvpFirstEnterBtn'));
			_enterBtn.move(127,376);
			addContent(_enterBtn);
			
		}
		private function initEvent():void
		{
			_enterBtn.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
		}
		private function removeEvent():void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnEnterClickHandler);
		}
		private function btnEnterClickHandler(event:MouseEvent):void
		{
			var available:Boolean = false;
			var activityInfo:ActiveStarTimeData = GlobalData.activeStartInfo.activeTimeInfo['1012']
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
			GuildPVPEnterSocketHandler.send();
			dispose();
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_banner.bitmapData = data;
		}
		override public function dispose():void
		{
			removeEvent();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			if(_enterBtn)
			{
				_enterBtn.dispose();
				_enterBtn = null;
			}
			for each(var cell:ResourceWarRewardCell in _awardCells)
			{
				cell.dispose();
				cell = null;
			}
			if(_awardCells)
			{
				_awardCells = null;
			}
			super.dispose();
		}
	}
}