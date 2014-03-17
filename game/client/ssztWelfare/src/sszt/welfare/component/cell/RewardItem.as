package sszt.welfare.component.cell
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.loginReward.LoginRewardInfo;
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;

	public class RewardItem extends Sprite
	{
		private var _dayIndex:int;
		
		private var _rewardInfo:ItemInfo;
		private var _rewardInfoVip:ItemInfo;
		
		private var _cell:RewardItemCell;
		private var _cellVip:RewardItemCell;
		
		private var _bg:IMovieWrapper;
		
		private var _label:MAssetLabel;
		
		public function RewardItem(dayIndex:int) 
		{
			_dayIndex = dayIndex;
			
			var rewardTemplate:LoginRewardInfo = LoginRewardTemplateList.getTemplate(_dayIndex);
			_rewardInfo = new ItemInfo();
			_rewardInfo.templateId = rewardTemplate.ptItemId;
			_rewardInfo.count = rewardTemplate.ptItemNum;
			_rewardInfoVip = new ItemInfo();
			_rewardInfoVip.templateId = rewardTemplate.vipItemId;
			_rewardInfoVip.count = rewardTemplate.vipItemNum;
			
			initView();
			initEvent();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(112,3,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(174,3,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_label = new MAssetLabel(LanguageManager.getWord("ssztl.common.loginDays",_dayIndex),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_label.move(8,15);
			addChild(_label);
			
			_cell = new RewardItemCell();
			_cell.move(112,3);
			addChild(_cell);
			_cell.itemInfo = _rewardInfo;
			_cellVip = new RewardItemCell();
			_cellVip.move(174,3);
			addChild(_cellVip);
			_cellVip.itemInfo = _rewardInfoVip;
				
		}
		private function initEvent():void
		{
			
		}
		private function removeEvent():void
		{
			
		}
		public function dispose():void
		{
			removeEvent();
			_rewardInfo = null;
			_rewardInfoVip = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_label = null;
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_cellVip)
			{
				_cellVip.dispose();
				_cellVip = null;
			}
		}
	}
}