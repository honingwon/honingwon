package sszt.scene.components.guildPVP
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.guildPVP.GuildPVPRankingItemInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;
	
	public class GuildPVPResultPanel extends MPanel
	{
		private const DEFAULT_WIDTH:int = 235;
		private const DEFAULT_HEIGHT:int = 329;
		
		private var _bg:IMovieWrapper;
		
		private var _isLive:Boolean;
		private var _time:int;
		private var _nick:String;		
		private var _index:int;
		private var _itemTemplateId:int;
		private var _rankList:Array;
		
		private var _isLiveLabel:MAssetLabel;
		private var _cell:BaseItemInfoCell;
		private var _tagReward:MAssetLabel;
		private var _txtReward:MAssetLabel;
		private var _rankViewList:Array;
		
		private var _btnSure:MCacheAssetBtn1;
		
		public function GuildPVPResultPanel(time:int,nick:String,index:int,rewardItemId:int,rankList:Array)
		{
			_time = time;
			_nick = nick;
			_index = index;
			_itemTemplateId = rewardItemId;
			_rankList = rankList;
			
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.FightEndTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.FightEndTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			
			init();
			initEvent();
		}
		
		protected function init():void
		{
			setContentSize(DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,215,270)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,60,215,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,84,215,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,108,215,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,109,215,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,173,215,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,272,215,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(99,216,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,18,215,18),new MAssetLabel(LanguageManager.getWord("ssztl.guildPVP.rankTitle"),MAssetLabel.LABEL_TYPE22)),
			]); 
			addContent(_bg as DisplayObject);
			
			var rankLabel:MAssetLabel;
			var timeLabel:MAssetLabel;
			var rank:GuildPVPRankingItemInfo;
			for(var i:int =0;i< _rankList.length;i++)
			{
				rank = _rankList[i];
				rankLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				rankLabel.move(40,43+24*i);
				rankLabel.textColor = getRankColor(i);
				addContent(rankLabel);
				rankLabel.setHtmlValue((i+1)+"："+rank.nick);//rank.kill));
				
				timeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.RIGHT);
				timeLabel.move(190,43+24*i);
				timeLabel.textColor = getRankColor(i);
				addContent(timeLabel);
				timeLabel.setHtmlValue(LanguageManager.getWord("ssztl.guildPVP.guildTime",int(rank.time/60),rank.time%60));
			}
			
			_tagReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_tagReward.move(DEFAULT_WIDTH/2,124);
			addContent(_tagReward);
			if(_time >= 14*60)
			{
				_tagReward.setHtmlValue(LanguageManager.getWord("ssztl.guildPVP.champion"));
			}
			else
			{
				_tagReward.setHtmlValue(LanguageManager.getWord("ssztl.guildPVP.normalAward"));				
			}
			
			_txtReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG);
			_txtReward.move(DEFAULT_WIDTH/2,190);
			addContent(_txtReward);
			_txtReward.setHtmlValue(LanguageManager.getWord("ssztl.bitBoss.rewardTip2"));
			
			_cell = new BaseItemInfoCell();
			_cell.info = ItemTemplateList.getTemplate(_itemTemplateId);
			_cell.move(99,216);
			addContent(_cell);
			
			_btnSure = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.sure"));
			_btnSure.move(79,284);
			addContent(_btnSure);
		}
		private function initEvent():void
		{
			_btnSure.addEventListener(MouseEvent.CLICK,btnSureClickHandler);
		}
		private function removeEvent():void
		{
			_btnSure.removeEventListener(MouseEvent.CLICK,btnSureClickHandler);
		}
		
		private function getRankColor(index:int):int
		{
			var color:int = 0xffcc00;
			switch(index)
			{	
				case 0:
				color = 0xcc00ff;
				break;
				case 1:
				color = 0x0ca1ff;
				break;
				case 2:
				color = 0x5dff1d;
				break;
			}
			return color;
		}
		
		private function getRankNick(index:int):String
		{
			var nick:String = "未能上榜";
			switch(index)
			{	
				case 1:
					nick = "排名第一";
					break;
				case 2:
					nick = "排名第二";
					break;
				case 3:
					nick = "排名第三";
					break;
			}
			return nick;
		}
		
		protected function btnSureClickHandler(event:MouseEvent):void
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
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
		}
		
		
	}
}