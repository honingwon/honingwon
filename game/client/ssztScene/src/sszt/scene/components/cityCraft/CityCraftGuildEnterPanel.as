package sszt.scene.components.cityCraft
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.socketHandlers.cityCraft.CityCraftEnterSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;

	public class CityCraftGuildEnterPanel extends MPanel implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _picPath:String;
		private var _enterBtn:MCacheAssetBtn1;
		private var _cancelBtn:MCacheAssetBtn1;
		
		private var _itemList:Array;
		private var _cellList:Array;
		private var _guildLabel1:MAssetLabel;
		private var _guildLabel2:MAssetLabel;
		
		public function CityCraftGuildEnterPanel()
		{			
			super(new MCacheTitle1("",new Bitmap()),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
//			_bgLayout = new Bitmap();
//			addChild(_bgLayout);
//			_picPath = GlobalAPI.pathManager.getBannerPath("cityFightMask.png");
//			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,20,120,20),new MAssetLabel(LanguageManager.getWord("ssztl.cityCraft.guildEnter"),MAssetLabel.LABEL_TYPE_YAHEI)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,195,580,20),new MAssetLabel("选择助援方",MAssetLabel.LABEL_TYPE_YAHEI)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(68,70,65,20),new MAssetLabel(GlobalData.cityCraftInfo.attackGuild,MAssetLabel.LABEL_TYPE_YAHEI)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(195,70,65,20),new MAssetLabel(GlobalData.cityCraftInfo.defenseGuild,MAssetLabel.LABEL_TYPE_YAHEI)),
			]);
			addContent(_bg as DisplayObject);
			
			_enterBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.sure'));
			_enterBtn.move(20,60);
			_cancelBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.cannel'));
			_cancelBtn.move(80,60);
			addContent(_enterBtn);
			addContent(_cancelBtn);			
			
			initEvent();
			
		}
		private function initEvent():void
		{
			_enterBtn.addEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,btnCancelClickHandler);
		}
		
		private function removeEvent():void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnEnterClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,btnCancelClickHandler);
		}
		
		private function btnEnterClickHandler(event:MouseEvent):void
		{			
			CityCraftEnterSocketHandler.send(4);
			dispose();
		}
		
		private function btnCancelClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
		}
		override public function dispose():void
		{
			removeEvent();
			_bgLayout = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_enterBtn)
			{
				_enterBtn.dispose();
				_enterBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}