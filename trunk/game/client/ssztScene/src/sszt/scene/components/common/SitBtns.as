package sszt.scene.components.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	
	public class SitBtns extends Sprite
	{
		private var _bg:Bitmap;
		private var _doubleSitBtn:MAssetButton1;
		private var _jingjieBtn:MAssetButton1;
		private var _mediator:SceneMediator;
		
		public function SitBtns(mediator:SceneMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_bg = new Bitmap(AssetUtil.getAsset("ssztui.scene.SitBtnBgAsset") as BitmapData);
//			_bg.x = -66;
//			addChild(_bg);
			_doubleSitBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.SitBtnAsset1") as MovieClip);
			_doubleSitBtn.move(-38,3);
			addChild(_doubleSitBtn);
			_jingjieBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.SitBtnAsset2") as MovieClip);
			_jingjieBtn.move(2,3);
			addChild(_jingjieBtn);
			/*
//			_doubleSitBtn = new MBitmapButton(new DoubleSitBtnAsset());
			_doubleSitBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.DoubleSitBtnAsset") as BitmapData);
			_doubleSitBtn.move(-40,0);
			addChild(_doubleSitBtn);
			
//			_jingjieBtn = new MBitmapButton(new JingjieBtnAsset());
			_jingjieBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.JingjieBtnAsset") as BitmapData);
			_jingjieBtn.move(0,0);
			addChild(_jingjieBtn);
			_jingjieBtn.enabled = false;
			*/
		}
		
		private function initEvent():void
		{
			_doubleSitBtn.addEventListener(MouseEvent.CLICK,doubleSitClickHandler);
			_jingjieBtn.addEventListener(MouseEvent.CLICK,lifeExpSitClickHandler);
		}
		
		private function removeEvent():void
		{
			_doubleSitBtn.removeEventListener(MouseEvent.CLICK,doubleSitClickHandler);
			_jingjieBtn.removeEventListener(MouseEvent.CLICK,lifeExpSitClickHandler);
		}
		
		private function doubleSitClickHandler(evt:MouseEvent):void
		{
			_mediator.showDoubleSitPanel();
		}
		private function lifeExpSitClickHandler(evt:MouseEvent):void
		{
			_mediator.showLifeExpSitPanel();
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg && _bg.bitmapData){
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_doubleSitBtn)
			{
				_doubleSitBtn.dispose();
				_doubleSitBtn = null;
			}
			if(_jingjieBtn)
			{
				_jingjieBtn.dispose();
				_jingjieBtn = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}