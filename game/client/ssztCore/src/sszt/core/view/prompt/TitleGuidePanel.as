package sszt.core.view.prompt
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.role.RoleNameSaveSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.ui.BtnAssetClose;

	public class TitleGuidePanel extends Sprite  implements ITick
	{
		private static var _instance:TitleGuidePanel;
		private var _bg:IMovieWrapper;
		private var _content:MAssetLabel;
		private var _btnView:MCacheAssetBtn1;
		private var _btnUse:MCacheAssetBtn1;
		private var _closeBtn:MAssetButton1;
		private var _canShow:Boolean = true;
		private static var _titleId:int = 0;
		
		public static function getInstance():TitleGuidePanel
		{
			if (_instance == null){
				_instance = new TitleGuidePanel();
			}
			return (_instance);
		}
		
		public function TitleGuidePanel()
		{
			
		}
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,301,115)),
			]);
			addChild(_bg as DisplayObject);
			
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.PromptImageAsset"))
			{
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.PromptImageAsset") as Class)());
				imageBtmp.x = -20;
				imageBtmp.y = -36;
			}
			if(imageBtmp) addChild(imageBtmp);
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(275,4);
			addChild(_closeBtn);
			
			_content = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,'left');
			_content.setLabelType([new TextFormat("Microsoft YaHei",12,0xfffccc)]);
			_content.move(82,18);
			addChild(_content);
			_content.setHtmlValue(LanguageManager.getWord('ssztl.core.titleGuideText'));
			
			_btnUse = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.use"));
			_btnUse.move(103,75);
			addChild(_btnUse);
			
			_btnView = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.check"));
			_btnView.move(177,75);
			addChild(_btnView);
			
			this.x = CommonConfig.GAME_WIDTH - 325;
			this.y = CommonConfig.GAME_HEIGHT;
			
			
			initEvents();
		}
		
		public function show(titleId:int=0):void{
			_titleId = titleId;
			init()
			if (!parent && _canShow)
			{
				_canShow = false;
				GlobalAPI.layerManager.getPopLayer().addChild(this);
			}
			GlobalAPI.tickManager.addTick(this);
//			this.addEventListener(Event.ENTER_FRAME,addTickHandler);
		}
		private function addTickHandler(e:Event):void
		{
//			this.removeEventListener(Event.ENTER_FRAME,addTickHandler);
//			GlobalAPI.tickManager.addTick(this);
		}
		private function initEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			_btnUse.addEventListener(MouseEvent.CLICK, useClickHandler);
			_btnView.addEventListener(MouseEvent.CLICK, viewClickHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
			_btnUse.removeEventListener(MouseEvent.CLICK, useClickHandler);
			_btnView.removeEventListener(MouseEvent.CLICK, viewClickHandler);
		}
		private function useClickHandler(e:MouseEvent):void
		{
			hide();
			RoleNameSaveSocketHandler.sendSave(_titleId,false);
			
		}
		private function viewClickHandler(e:MouseEvent):void
		{
			hide();
			SetModuleUtils.addRole(GlobalData.selfPlayer.userId,2);
		}
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			GlobalAPI.tickManager.removeTick(this);
			x = CommonConfig.GAME_WIDTH - 325;
			y = CommonConfig.GAME_HEIGHT - 210;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(y <= CommonConfig.GAME_HEIGHT - 210)
			{
				GlobalAPI.tickManager.removeTick(this);
			}
			else
			{
				y -= 5;
			}
		}
		private function closeHandler(evt:MouseEvent):void
		{
			hide();	
		}
		public function hide():void
		{
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
	}
}