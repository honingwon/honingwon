package sszt.scene.components.onlineReward
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.dailyAward.DailyAwardTemplateInfo;
	import sszt.core.data.dailyAward.DailyAwardTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class OnlineRewardPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _getRewardHandler:Function;
		private var _btnGetAllClickHandler:Function;
		private var _templateInfoList:Array;
		
		private var _onlineDurationLabel:MAssetLabel;
		private var _tile:MTile;
		private var _btnGetAll:MCacheAssetBtn1;
		
		public function OnlineRewardPanel(getRewardHandler:Function,btnGetAllClickHandler:Function)
		{
			_getRewardHandler = getRewardHandler;
			_btnGetAllClickHandler = btnGetAllClickHandler;
			
			_templateInfoList = [];
			
			var item:DailyAwardTemplateInfo;
			for each(item in DailyAwardTemplateList.list)
			{
				_templateInfoList.push(item);
			}
			_templateInfoList.sortOn(['awardId'],[Array.NUMERIC]);
			
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.OnlineGifTitleAsset"))
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.OnlineGifTitleAsset") as Class)());
			super(new MCacheTitle1("",imageBtmp),true,-1,true,true);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_btnGetAll.addEventListener(MouseEvent.CLICK,btnGetAllClickHandler);
		}
		
		protected function btnGetAllClickHandler(event:MouseEvent):void
		{
			_btnGetAllClickHandler();
		}
		
		private function removeEvent():void
		{
			_btnGetAll.removeEventListener(MouseEvent.CLICK,btnGetAllClickHandler);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(465,414);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,449,404)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,441,396)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,378,400,15),new MAssetLabel(LanguageManager.getWord('ssztl.common.onlineRewardTip2'),MAssetLabel.LABEL_TYPE_TAG,'left')),
			]);
			addContent(_bg as DisplayObject);
			
			_onlineDurationLabel = new MAssetLabel(LanguageManager.getWord('ssztl.common.onlineRewardTip1'),MAssetLabel.LABEL_TYPE_TAG,'left');
			_onlineDurationLabel.move(24,17);
			addContent(_onlineDurationLabel);
			
			
			_btnGetAll = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.club.allAcceptLabel'));
			_btnGetAll.move(374,11);
			addContent(_btnGetAll);
			
			_tile = new MTile(84,110,5);
			_tile.itemGapH = _tile.itemGapW = 2;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.setSize(428,334);
			_tile.move(17,38);
			addContent(_tile);
			
			var i:int;
			var infoItem:DailyAwardTemplateInfo;
			var viewItem:OnlineRewardItemView;
			for(i = 0; i < _templateInfoList.length; i++)
			{
				infoItem = _templateInfoList[i];
				viewItem = new OnlineRewardItemView(infoItem,_getRewardHandler);
				_tile.appendItem(viewItem);
			}
		}
		
		public function updateView(seconds:int,list:Array):void
		{
			var time:String = DateUtil.getLeftTime(seconds);
			_onlineDurationLabel.setHtmlValue(LanguageManager.getWord('ssztl.common.onlineRewardTip1') + '<font color="#00ff00">'+time+'</font>');
			var viewList:Array = _tile.getItems();
			var view:OnlineRewardItemView;
			for(var i:int=0;i<list.length;i++)
			{
				if(list[i] == 1)
				{
					view = viewList[i];
					view.updateView(true);
				}
				if(list[i] == 0)
				{
					view = viewList[i];
					view.updateView(false);
				}
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_getRewardHandler = null;
			_templateInfoList = null;
			_onlineDurationLabel = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_btnGetAll)
			{
				_btnGetAll.dispose();
				_btnGetAll = null;
			}
		}
	}
}