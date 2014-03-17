package sszt.scene.components.cityCraft
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
	import sszt.core.data.cityCraft.CityCraftRankItemInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
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
	
	public class CityCraftResultPanel extends MPanel
	{
		private const DEFAULT_WIDTH:int = 235;
		private const DEFAULT_HEIGHT:int = 329;
		
		private var _bg:IMovieWrapper;
		
		private var _score:int;
		private var _index:int;
		private var _itemTemplateId:int;
		private var _result:int;
		private var _nick:String;
		private var _rankList:Array;
		
		private var _cell:BaseItemInfoCell;
		private var _tagResult:MAssetLabel;
		private var _tagReward:MAssetLabel;
		private var _tagReward1:MAssetLabel;
		private var _txtReward:MAssetLabel;
		private var _rankViewList:Array;
		
		private var _btnSure:MCacheAssetBtn1;
		
		public function CityCraftResultPanel(score:int,index:int,rewardItemId:int,result:int,nick:String,rankList:Array)
		{
			_score = score;
			_index = index;
			_result = result;
			_itemTemplateId = rewardItemId;
			_nick = nick;
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
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,18,215,18),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.resultTitle"),MAssetLabel.LABEL_TYPE22)),
			]); 
			addContent(_bg as DisplayObject);
			
			_tagResult = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_tagResult.move(DEFAULT_WIDTH/2,124);
			addContent(_tagResult);
			if(_result == 1)
			{
				_tagResult.setHtmlValue(LanguageManager.getWord("ssztl.cityCraft.resultBeat",_nick));
			}
			else
			{
				_tagResult.setHtmlValue(LanguageManager.getWord("ssztl.cityCraft.resultDefend",_nick));
			}
			
			var rankLabel:MAssetLabel;
			var scoreLabel:MAssetLabel;
			var rank:CityCraftRankItemInfo;
			for(var i:int =0;i< _rankList.length;i++)
			{
				rank = _rankList[i];
				rankLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				rankLabel.move(40,43+24*i);
				rankLabel.textColor = getRankColor(i);
				addContent(rankLabel);
				rankLabel.setHtmlValue((i+1)+"："+rank.nick);//rank.kill));
				
				scoreLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.RIGHT);
				scoreLabel.move(190,43+24*i);
				scoreLabel.textColor = getRankColor(i);
				addContent(scoreLabel);
				scoreLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.minuteValue",rank.point));
			}
			
			_tagReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_tagReward.move(DEFAULT_WIDTH/2,124);
			addContent(_tagReward);
			_tagReward.setHtmlValue(LanguageManager.getWord("ssztl.cityCraft.resultScore",_score));
			
			if(_index == 1 || _index == 2 || _index == 3)
			{
				_tagReward1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
				_tagReward1.move(DEFAULT_WIDTH/2,144);
				addContent(_tagReward1);
				_tagReward1.setHtmlValue(LanguageManager.getWord("ssztl.cityCraft.resultHonour",getRankNick(_index)));
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
			var nick:String = "小将";
			switch(index)
			{	
				case 1:
					nick = "第一猛将";
					break;
				case 2:
					nick = "第二猛将";
					break;
				case 3:
					nick = "第三猛将";
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
			if(_bg)
			{
				_bg = null;
			}
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_btnSure)
			{
				_btnSure.dispose();
				_btnSure = null;
			}
		}
		
		
	}
}