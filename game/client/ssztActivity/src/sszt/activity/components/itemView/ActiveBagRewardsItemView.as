package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import sszt.activity.components.cell.AwardCell;
	import sszt.core.data.activity.ActiveBagTemplateInfo;
	import sszt.core.data.activity.ActiveRewardsTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ActiveBagRewardsItemView extends Sprite
	{
		private var _bagRewardsInfo:ActiveBagTemplateInfo;
		private var _cell:AwardCell;
		private var _activeNumLabel:MAssetLabel;
		public function ActiveBagRewardsItemView(argInfo:ActiveBagTemplateInfo)
		{
			super();
			_bagRewardsInfo = argInfo;
			initialView();
		}
		
		private function initialView():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(46,18,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.activity.needActivity"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			
			_cell = new AwardCell();
			_cell.info = ItemTemplateList.getTemplate(_bagRewardsInfo.tempalteId);
			_cell.move(3,5);
			addChild(_cell);
		
			_activeNumLabel = new MAssetLabel(_bagRewardsInfo.activeNum.toString(),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_activeNumLabel.move(115,18);
			addChild(_activeNumLabel);
		}
		
		public function dispose():void
		{
			 _bagRewardsInfo = null;
			 if(_cell)
			 {
				 _cell.dispose();
				 _cell = null;
			 }
			 _activeNumLabel = null;
		}
	}
}