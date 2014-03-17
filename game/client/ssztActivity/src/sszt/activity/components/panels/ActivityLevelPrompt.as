package sszt.activity.components.panels
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class ActivityLevelPrompt extends MPanel
	{
		/**
		 * 21:单挑王 22:一战到底 23:帮会突袭　24:京城巡逻
		 */	
		private var _type:int;
		private var _bg:IMovieWrapper;
		private var _bannerImg:Bitmap;
		private var _picPath:String;
		private var _confirmBtn:MCacheAssetBtn1;
		
		public function ActivityLevelPrompt(type:int)
		{
			_type = type;
			
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.PromptImageAsset"))
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.PromptImageAsset") as Class)());
			
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,true,true);
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(255,295);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,242,235,25),new MCacheCompartLine2()),
			]);
			addContent(_bg as DisplayObject);
			
			_bannerImg = new Bitmap();
			_bannerImg.x = 10;
			_bannerImg.y = 2;
			addContent(_bannerImg);
			
			_confirmBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.close'));
			_confirmBtn.move(93,254);
			addContent(_confirmBtn);
			_confirmBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
//			if(_bannerImg.bitmapData) _bannerImg.bitmapData.dispose();
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(_type);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
		}

		private function loadAvatarComplete(data:BitmapData):void
		{
			_bannerImg.bitmapData = data;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bannerImg && _bannerImg.bitmapData)
			{
//				_bannerImg.bitmapData.dispose();
				_bannerImg = null;
			}
			if(_confirmBtn)
			{
				_confirmBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
				if(_confirmBtn.parent)_confirmBtn.parent.removeChild(_confirmBtn);
				_confirmBtn.dispose();
				_confirmBtn = null;
			}
			super.dispose();
		}
	}
}