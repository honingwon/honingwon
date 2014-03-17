package sszt.core.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.events.MailModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	
	public class MailIcon extends Sprite
	{
		private var _mailOpen:Boolean;
		private var _asset:IMovieWrapper;
		private var _countLabel:TextField;
		
		public function MailIcon()
		{
			_mailOpen = false;
			super();
			init();
			initEvent();
		}
		
		public function get mailOpen():Boolean
		{
			return _mailOpen;
		}
		
		public function set mailOpen(flag:Boolean):void
		{
			_mailOpen = flag;
		}
		
		private function init():void
		{
//			graphics.beginFill(0xFAC951,1);
//			graphics.drawRect(0,0,30,15);
//			graphics.endFill();
			buttonMode = true;
			
			_asset = GlobalAPI.movieManagerApi.getMovieWrapper(AssetUtil.getAsset("ssztui.common.MailAsset",MovieClip) as MovieClip,29,29,7);
			addChild(_asset as DisplayObject);
			
			_countLabel = new TextField();
			var t:TextFormat = new TextFormat("Tahoma",10,0xfffccc,true,null,null,null,null,TextFormatAlign.CENTER);
			_countLabel.defaultTextFormat = t;
			_countLabel.mouseWheelEnabled = _countLabel.mouseEnabled = false;
			_countLabel.width = 29;
			_countLabel.height = 16;
			_countLabel.x = 0;
			_countLabel.y = 6;
//			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			_countLabel.setTextFormat(t);
			addChild(_countLabel);
			_countLabel.text = "";
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,clickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(_mailOpen)
			{
				ModuleEventDispatcher.dispatchMailEvent(new MailModuleEvent(MailModuleEvent.NEW_MAIL));	
			}else
			{
				SetModuleUtils.addMail(new ToMailData(true));
			}
//			hide();
			ModuleEventDispatcher.dispatchMailEvent(new MailModuleEvent(MailModuleEvent.SHOW_MAIL_PANEL));
		}
		
		public function hide():void
		{
			_asset.stop();
			if(parent) parent.removeChild(this);
		}
		
		public function show(count:int):void
		{
			sizeChangeHandler(null);
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			_asset.play();
			_countLabel.text = count.toString();
		}
		
		public function updateCount(count:int):void
		{
			_countLabel.text = count.toString();
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(CommonConfig.GAME_WIDTH - 47,108);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(parent) parent.removeChild(this);
			if(_asset)
			{
				_asset.dispose();
				_asset = null;
			}
			_countLabel = null;
		}
	}
}