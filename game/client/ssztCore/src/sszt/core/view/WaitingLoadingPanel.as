package sszt.core.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleList;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.loader.IWaitLoading;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.ui.SmallBtnCloseAsset;
		
	public class WaitingLoadingPanel extends Sprite implements IWaitLoading
	{
		private var _cancelHandler:Function;
		private var _bg:Bitmap;
		private var _progressTxt:MAssetLabel;
//		private var _bar:Bitmap;
//		private var _mask:Shape;
		private var _closeBtn:MBitmapButton;
		private var _descriptLabel:MAssetLabel;
		private var _descript:String = "";
		
		public function setup():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,3000,3000);
			graphics.endFill();
			if(GlobalData.domain.hasDefinition("ssztui.common.LoadingBgAsset"))
			{
				_bg = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.LoadingBgAsset") as Class)());
			}
			else _bg = new Bitmap();
			if(_bg)
			{
				addChild(_bg);
			}
			_descriptLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			addChild(_descriptLabel);
			
			_closeBtn = new MBitmapButton(new SmallBtnCloseAsset());
			addChild(_closeBtn);
			
			gameSizeChangeHandler(null);
			
			initEvent();
		}
		
		protected function initEvent():void
		{
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			if(_cancelHandler != null)_cancelHandler();
			hide();
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			_bg.x = (CommonConfig.GAME_WIDTH - _bg.width) / 2;
			_bg.y = (CommonConfig.GAME_HEIGHT - _bg.height) / 2;
			_closeBtn.x = _bg.x + 134;
			_closeBtn.y = _bg.y + 13;
			_descriptLabel.x = _bg.x + 85;
			_descriptLabel.y = _bg.y + 79;
		}
		
		private function initView():void
		{
//			_mask.scaleX = 0;
			GlobalAPI.layerManager.getTipLayer().addChild(this);
		}
		
		public function showLoading(descript:String="", cancelHandler:Function=null):void
		{
			initView();
			_cancelHandler = cancelHandler;
			_closeBtn.visible = cancelHandler != null;
			_descriptLabel.text = descript;
			_descript = descript;
		}
		
		public function showLogin(descript:String = "",cancelHandler:Function = null):void
		{
			initView();
			_descript = descript;
			_descriptLabel.text = descript;
			_closeBtn.visible = cancelHandler != null;
		}
		
		private function closeHandler(evt:MouseEvent):void
		{
			if(_cancelHandler != null)
			{
				_cancelHandler();
			}
			hide();
		}
		
		public function showModuleLoading(moduleId:int,cancelHandler:Function = null):void
		{
//			var descript:String = ModuleList.getInfo(moduleId).name + "加载中...";
			_descript = ModuleList.getInfo(moduleId).name + "加载中...";
			showLoading(_descript,cancelHandler);
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
			_cancelHandler = null;
		}
		
		public function setProgress(bytesLoaded:int,bytesTotal:int):void
		{
//			_progressTxt.setValue(String(int((bytesLoaded / bytesTotal) * 100)) + "%");
//			_mask.scaleX = bytesLoaded / bytesTotal;
			_descriptLabel.text = _descript + String(int((bytesLoaded / bytesTotal) * 100)) + "%";
		}
	}
}