package sszt.common.vip.component.pop
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.common.vip.VipController;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.vip.BuyTitleAsset;
	import sszt.common.vip.component.cell.VipCardCell;

	public class BuyVipPanel extends MPanel
	{
		private var _controller:VipController;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		
		public function BuyVipPanel(controller:VipController)
		{
			super(new MCacheTitle1("",new Bitmap(new BuyTitleAsset())),true,-1,true,true);
			initEvent();
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(371,225);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,355,193)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,115,185)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(128,6,115,185)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(244,6,115,185)),
			]);
			addContent(_bg as DisplayObject);
			
			var tip:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			tip.move(20,199);
			tip.setHtmlValue(LanguageManager.getWord("ssztl.vip.buyVipTip"));
			addContent(tip);
			
			_tile = new MTile(115, 185, 3);
			_tile.setSize(348,185);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.move(12,6);
			addContent(_tile);
			_tile.appendItem(new VipCardCell(206038));
			_tile.appendItem(new VipCardCell(206039));
			_tile.appendItem(new VipCardCell(206040 ));
		}
		private function initEvent():void
		{
			
		}
		private function removeEvent():void
		{
			
		}
		override public function dispose():void
		{
			removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			super.dispose();
		}
	}
}