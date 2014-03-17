package sszt.scene.components.quickIcon
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	
	public class BaseIconBtn extends MSprite
	{
		protected var _quickIconMediator:QuickIconMediator;
		protected var _tipString:String;
		private var _iconEffect:MovieClip;
		private var _over:Bitmap;
		
		public function BaseIconBtn(argMediator:QuickIconMediator)
		{
			_quickIconMediator = argMediator;
			initView();
			initEvent();
			super();
		}
		protected function initView():void
		{
			_iconEffect = AssetUtil.getAsset("ssztui.scene.QuickIconEffectAsset") as MovieClip; 
			_iconEffect.mouseEnabled = _iconEffect.mouseChildren = false;
			addChild(_iconEffect);
			
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.QuickIconOverAsset") as BitmapData);
			_over.x = _over.y = 1;
			addChild(_over);
			_over.visible = false;
		}
		
		protected function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,btnClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		protected function removeEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		protected function btnClickHandler(e:MouseEvent):void
		{
			
		}
		private function overHandler(e:MouseEvent):void
		{
			if(_tipString != "")
				TipsUtil.getInstance().show(_tipString,null,new Rectangle(e.stageX,e.stageY,0,0));
			_over.visible = true;
		}
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
			_over.visible = false;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_quickIconMediator = null;
			if(_iconEffect && _iconEffect.parent)
			{
				_iconEffect.parent.removeChild(_iconEffect);
				_iconEffect = null;
			}
			if(_over && _over.bitmapData)
			{
				_over.bitmapData.dispose();
				_over = null;
			}
			super.dispose();
		}
	}
}