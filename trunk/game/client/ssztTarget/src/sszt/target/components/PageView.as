package sszt.target.components
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
//	import mhsm.ui.LeftBtnAsset;
//	import mhsm.ui.RightBtnAsset;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.page.PageEvent;
	
	public class PageView extends MSprite
	{
		private var _preBtn:MCacheAssetBtn2,_nextBtn:MCacheAssetBtn2,_firstBtn:MCacheAssetBtn2,_lastBtn:MCacheAssetBtn2;
		private var _bg:DisplayObject;
		private var _pageField:TextField;
		private var _totalPage:int = 1;
		private var _totalRecord:int;
		private var _pageSize:int;
		
		public var currentPage:int;
		private var _isShowOtherBtn:Boolean;
		private var _pageWidth:int;
		
		public function PageView(pageSize:int = 1,argShowOtherBtn:Boolean = false,pageWidth:int = 134)
		{
			_isShowOtherBtn = argShowOtherBtn;
			_pageSize = pageSize;
			_pageWidth = pageWidth;
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			this.mouseEnabled = false;
			
			_bg = new BackgroundType.BORDER_7();
			_bg.width = _pageWidth;
			_bg.height = 24;
			addChild(_bg );
			
			_pageField = new TextField();
			_pageField.defaultTextFormat = new TextFormat("Tahoma",12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_pageField.width = _pageWidth - 44;
			_pageField.height = 18;
			_pageField.x = 22;
			_pageField.y = 3;
			_pageField.mouseEnabled = _pageField.mouseWheelEnabled = false;
			addChild(_pageField);
			_pageField.text = "1/1";
			
			
			_preBtn = new MCacheAssetBtn2(3);
			_preBtn.move(3,3);
			addChild(_preBtn);
			_nextBtn = new MCacheAssetBtn2(4);
			_nextBtn.move(_pageWidth - 21,3);
			addChild(_nextBtn);
			
			if(_isShowOtherBtn)
			{
//				_pageField.x = 42;
//				_firstBtn = new MBitmapButton(new LeftBtnAsset());
//				addChild(_firstBtn);
//				_preBtn.move(_firstBtn.width + 1,0);
//				_nextBtn.move(_preBtn.x + 70,0);
//				_lastBtn = new MBitmapButton(new RightBtnAsset());
//				_lastBtn.move(_nextBtn.x +_nextBtn.width + 1,0);
//				addChild(_lastBtn);
//				_bg.width = 127;
			}
			
			currentPage = 1;
			totalRecord = 1;
		}
		
		private function initEvent():void
		{
			if(_isShowOtherBtn)
			{
				_firstBtn.addEventListener(MouseEvent.CLICK,firstClickHandler);
				_lastBtn.addEventListener(MouseEvent.CLICK,lastClickHandler);
			}
			_preBtn.addEventListener(MouseEvent.CLICK,preClickHandler);
			_nextBtn.addEventListener(MouseEvent.CLICK,nextClickHandler);
		}
		
		private function removeEvent():void
		{
			if(_isShowOtherBtn)
			{
				_firstBtn.removeEventListener(MouseEvent.CLICK,firstClickHandler);
				_lastBtn.removeEventListener(MouseEvent.CLICK,lastClickHandler);
			}
			_preBtn.removeEventListener(MouseEvent.CLICK,preClickHandler);
			_nextBtn.removeEventListener(MouseEvent.CLICK,nextClickHandler);
		}
		
		private function firstClickHandler(e:MouseEvent):void
		{
			setPage(1);
		}
		
		private function lastClickHandler(e:MouseEvent):void
		{
			setPage(_totalPage);
		}
		
		private function preClickHandler(e:MouseEvent):void
		{
			if(currentPage <= 1)
				return;
			setPage(currentPage - 1);
		}
		
		private function nextClickHandler(e:MouseEvent):void
		{
			if(currentPage >= _totalPage)
				return;
			setPage(currentPage + 1);
		}
		
		public function setPage(page:int,isDispatch:Boolean = true):void
		{
			var old:int = currentPage;
			currentPage = page;
//			if(currentPage < 1)currentPage = _totalPage;
//			if(currentPage > _totalPage)currentPage = 1;
			if(currentPage != old && isDispatch)
			{
				dispatchEvent(new PageEvent(PageEvent.PAGE_CHANGE,currentPage,old));
			}
			_pageField.text = currentPage + "/" + _totalPage;
		}
		
		public function get totalRecord():int
		{
			return _totalRecord;
		}
		public function set totalRecord(value:int):void
		{
			if(_totalRecord == value)return;
			_totalRecord = value;
			_totalPage = Math.ceil(_totalRecord / _pageSize);
			if(_totalPage < 1) _totalPage = 1;
			_pageField.text = currentPage + "/" + _totalPage;
		}
		
		public function set pageSize(value:int):void
		{
			if(_pageSize == value)return;
			_pageSize = value;
			_totalPage = Math.ceil(_totalRecord / _pageSize);
			if(_totalPage < 1) _totalPage = 1;
			_pageField.text = currentPage + "/" + _totalPage;
		}
		public function get pageSize():int
		{
			return _pageSize;
		}
		
//		public function setPageFieldValue(currPage:int=1,totalPage:int=1):void
//		{
////			_pageField.text = "";
////			currentPage = 1;
//			_pageField.text = currPage + "/" + totalPage;
//		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_preBtn)
			{
				_preBtn.dispose();
				_preBtn = null;
			}
			if(_nextBtn)
			{
				_nextBtn.dispose();
				_nextBtn = null;
			}
			if(_firstBtn)
			{
				_firstBtn.dispose();
				_firstBtn = null;
			}
			if(_lastBtn)
			{
				_lastBtn.dispose();
				_lastBtn = null;
			}
			if(_bg)
			{
				_bg = null;
			}
			super.dispose();
		}
	}
}