package sszt.scene.components.onlineReward
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.dailyAward.DailyAwardTemplateInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class OnlineRewardItemView extends MSprite
	{
		private var _bg:IMovieWrapper;
		
		private var _getRewardHandler:Function;
		
		private var _info:DailyAwardTemplateInfo;
		
		private var _neededMinutesLabel:MAssetLabel;
		private var _cell:Cell;
		private var _btnGet:MCacheAssetBtn1;
		
		public function OnlineRewardItemView(info:DailyAwardTemplateInfo,getRewardHandler:Function)
		{
			_getRewardHandler = getRewardHandler;
			_info = info;
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(0,0,84,110)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(0,5,84,26)),
			]);
			addChild(_bg as DisplayObject);
			
			var miniutes:int = _info.needSeconds / 60;
			_neededMinutesLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_neededMinutesLabel.move(42,11);
			addChild(_neededMinutesLabel);
			_neededMinutesLabel.setHtmlValue(miniutes.toString() + LanguageManager.getWord("ssztl.common.minitueLabel"));
			
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.isBind = true;
			itemInfo.templateId = _info.itemIdList[0];
			itemInfo.count = _info.itemCountList[0];
			
			_cell = new Cell();
			_cell.itemInfo = itemInfo;
			_cell.move(23,36);
			addChild(_cell);
			_cell.setEffect(false);
			
			_btnGet = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.loginReward.getExp'));
			_btnGet.enabled = false;
			_btnGet.move(8,76);
			addChild(_btnGet);
		}
		
		private function initEvent():void
		{
			_btnGet.addEventListener(MouseEvent.CLICK,btnGetClickHandler);
		}
		
		protected function btnGetClickHandler(event:MouseEvent):void
		{
			_getRewardHandler(_info.awardId);
		}
		
		private function removeEvent():void
		{
			_btnGet.removeEventListener(MouseEvent.CLICK,btnGetClickHandler);
		}
		
		public function updateView(isGot:Boolean):void
		{
			if(isGot)
			{
				_btnGet.enabled = false;
				_btnGet.label = LanguageManager.getWord('ssztl.activity.hasGotten');
				_cell.setEffect(false);
			}
			else
			{
				_btnGet.enabled = true;
				_btnGet.label = LanguageManager.getWord('ssztl.loginReward.getExp');
				_cell.setEffect(true);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_getRewardHandler = null;
			_neededMinutesLabel = null;
			_info = null;
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_btnGet)
			{
				_btnGet.dispose();
				_btnGet = null;
			}
		}
		
	}
}