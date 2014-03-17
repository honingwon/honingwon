package sszt.marriage.componet
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.marriage.componet.item.MarriageRelationItemView;
	import sszt.marriage.data.MarriageRelationItemInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.marriage.marriageTitleAsset;
	
	public class MarriageManagePanel extends MPanel
	{
		public var viewList:Dictionary;
		
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		private var _tile:MTile;
		private var _noneTip:MAssetLabel;
		
		public function MarriageManagePanel()
		{
			viewList = new Dictionary();
			super(new MCacheTitle1("",new Bitmap(new marriageTitleAsset())),true,-1,true,true);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(356,400);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,336,386)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgImg = new Bitmap();
			_bgImg.x = 12;
			_bgImg.y = 6;
			addContent(_bgImg);
			
			_noneTip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_noneTip.move(178,175);
			addContent(_noneTip);
			
			_tile = new MTile(332,116,1);
			_tile.setSize(332,350);
			_tile.move(12,13);
			_tile.itemGapW = _tile.itemGapH = 1;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			addContent(_tile);
		}
		
		public function updateView(data:Array):void
		{
			clearView();
			var len:int = data.length;
			var i:int;
			var info:MarriageRelationItemInfo;
			var view:MarriageRelationItemView;
			for(i = 0; i < len; i++)
			{
				info = data[i];
				view = new MarriageRelationItemView(info);
				_tile.appendItem(view);
				viewList[info.userId] = view;
			}
			if(len == 0)
				_noneTip.setHtmlValue(LanguageManager.getWord("ssztl.marry.unmarriedTip"));
			else
				_noneTip.setHtmlValue("");
		}
		
		private function clearView():void
		{
			_tile.disposeItems();
			viewList = new Dictionary();
		}
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset('ssztui.marriage.MyMarriageBgAsset',BitmapData) as BitmapData;
		}
		override public function dispose():void
		{
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			if(_bgImg && _bgImg)
			{
				_bgImg.bitmapData.dispose();
				_bgImg = null;
			}
			_noneTip = null;	
		}
	}
}