package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarCampChangeSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.scene.DotaCampBtnAsset1;
	import ssztui.scene.DotaCampBtnAsset2;
	import ssztui.scene.DotaCampBtnAsset3;
	import ssztui.scene.DotaCampBtnEffectAsset;
	import ssztui.scene.DotaTitleSelectAsset;
	
	public class AlterCampPanel extends MPanel
	{
		private static var _instance:AlterCampPanel;
		
		private var _bg:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _bgLayoutPath:String;
		private var _imageBtmp:Bitmap;
		private var _imageTalk:MAssetLabel;
		
		private const CONTENT_WIDTH:int = 466;
		private const CONTENT_HEIGHT:int = 270;
		
		private var _myCampType:int;
		private var _btnSelectCampSong:MAssetButton1;
		private var _btnSelectCampLiao:MAssetButton1;
		private var _btnSelectCampXia:MAssetButton1;
		private var _btnCurrentEft:MovieClip;
		
		public function AlterCampPanel()
		{
			super(new Bitmap(new DotaTitleSelectAsset()),true,-1,true,true);
			initEvent();
		}
		
		public static function getInstance():AlterCampPanel
		{
			if (_instance == null){
				_instance = new AlterCampPanel();
			};
			return (_instance);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,450,262)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,442,253)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgLayout = new Bitmap();
			_bgLayout.x = 14;
			_bgLayout.y = 8;
			addContent(_bgLayout);
			
			_bgLayoutPath = GlobalAPI.pathManager.getBannerPath("dotaAlterCampBg.jpg");
			GlobalAPI.loaderAPI.getPicFile(_bgLayoutPath, loadBgComplete,SourceClearType.NEVER);
			
			if(GlobalData.domain.hasDefinition("ssztui.common.PromptImageAsset"))
			{
				_imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.PromptImageAsset") as Class)());
				_imageBtmp.x = 18;
				_imageBtmp.y = -32;
			}
			if(_imageBtmp) addContent(_imageBtmp);
			
			_imageTalk = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_imageTalk.textColor = 0x000000;
			_imageTalk.move(133,39);
			addContent(_imageTalk);
			_imageTalk.setHtmlValue(LanguageManager.getWord("ssztl.resourceWar.AlterCampTip"));
			
//			_btnSelectCampSong = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.common.campNameSong"));
			_btnSelectCampSong = new MAssetButton1(new DotaCampBtnAsset1() as MovieClip);
			_btnSelectCampSong.move(45,135);
			addContent(_btnSelectCampSong);
			
//			_btnSelectCampLiao = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.common.campNameLiao"));
			_btnSelectCampLiao = new MAssetButton1(new DotaCampBtnAsset3() as MovieClip);
			_btnSelectCampLiao.move(181,135);
			addContent(_btnSelectCampLiao);
			
//			_btnSelectCampXia = new MCacheAssetBtn1(0, 3, LanguageManager.getWord("ssztl.common.campNameXia"));
			_btnSelectCampXia = new MAssetButton1(new DotaCampBtnAsset2() as MovieClip);
			_btnSelectCampXia.move(317,135);
			addContent(_btnSelectCampXia);
			
			_btnCurrentEft = new DotaCampBtnEffectAsset();
			_btnCurrentEft.y = 135;
			addContent(_btnCurrentEft);
		}
		
		private function initEvent():void
		{
			_btnSelectCampSong.addEventListener(MouseEvent.CLICK, btnSelectCampClickHandler);
			_btnSelectCampLiao.addEventListener(MouseEvent.CLICK, btnSelectCampClickHandler);
			_btnSelectCampXia.addEventListener(MouseEvent.CLICK, btnSelectCampClickHandler);
		}
		
		private function removeEvent():void
		{
			_btnSelectCampSong.removeEventListener(MouseEvent.CLICK, btnSelectCampClickHandler);
			_btnSelectCampLiao.removeEventListener(MouseEvent.CLICK, btnSelectCampClickHandler);
			_btnSelectCampXia.removeEventListener(MouseEvent.CLICK, btnSelectCampClickHandler);
			
		}
		private function btnSelectCampClickHandler(event:MouseEvent):void
		{
			var btn:MAssetButton1 = event.currentTarget as MAssetButton1;
			var selectedCampType:int;
			switch(btn)
			{
				case _btnSelectCampSong : 
					selectedCampType = 1;
					break;
				case _btnSelectCampLiao : 
					selectedCampType = 2;
					break;
				case _btnSelectCampXia : 
					selectedCampType = 3;
					break;
			}
//			if(_btnCurrentEft.x != btn.x) _btnCurrentEft.x = btn.x;
			if(GlobalData.selfPlayer.userMoney.yuanBao < 100)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));	
				return;
			}
			
			MAlert.show(LanguageManager.getWord("ssztl.resourceWar.alterCampAlert",100),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,alertCampConfirmHandler);
			
			function alertCampConfirmHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					ResourceWarCampChangeSocketHandler.send(selectedCampType);
					dispose();
				}
			}
		}
		
		public function show(myCampType:int):void
		{
			_myCampType = myCampType;
			switch(_myCampType)
			{
				case 1 : 
					_btnCurrentEft.x = _btnSelectCampSong.x;
					break;
				case 2 : 
					_btnCurrentEft.x = _btnSelectCampLiao.x;
					break;
				case 3 : 
					_btnCurrentEft.x = _btnSelectCampXia.x;
					break;
			}
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}else
			{
				dispose();
			}
		}
		private function loadBgComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
		}
		
		override public function dispose():void
		{
			removeEvent();
			GlobalAPI.loaderAPI.removeAQuote(_bgLayoutPath,loadBgComplete);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgLayout)
			{
				_bgLayout = null;
			}
			_bgLayoutPath = null;
			if(_btnSelectCampSong)
			{
				_btnSelectCampSong.dispose();
				_btnSelectCampSong = null;
			}
			if(_btnSelectCampLiao)
			{
				_btnSelectCampLiao.dispose();
				_btnSelectCampLiao = null;
			}
			if(_btnSelectCampXia)
			{
				_btnSelectCampXia.dispose();
				_btnSelectCampXia = null;
			}
			if(_btnCurrentEft && _btnCurrentEft.parent)
			{
				_btnCurrentEft.parent.removeChild(_btnCurrentEft);
				_btnCurrentEft = null;
			}
			if(_imageBtmp && _imageBtmp.bitmapData)
			{
				_imageBtmp.bitmapData.dispose();
				_imageBtmp = null;
			}
			_imageTalk = null;
			_instance = null;
			super.dispose();
		}
	}
}