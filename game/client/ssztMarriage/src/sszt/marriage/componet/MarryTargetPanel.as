package sszt.marriage.componet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.MarryRelationType;
	import sszt.constData.WeddingType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.marriage.FunBtnAsset;
	
	/**
	 * 求婚对象界面
	 * */
	public class MarryTargetPanel extends MSprite implements IPanel
	{
		private var _itemId:int;
		private static var _instance:MarryTargetPanel;
		private var _bg:Bitmap;
		private var _dragArea:MSprite;
		private var _ringShow:MovieClip;
		private var _ringShowTip:Sprite;
		
		private var _acceptProposalHandler:Function;
		private var _refuseProposalHandler:Function;
		
		private var _description:MAssetLabel;
		
		private var _btnYes:MAssetButton1;
		private var _btnNo:MAssetButton1;
		
		private var _labelYes:MAssetLabel;
		private var _labelNo:MAssetLabel;
		
		public static const DEFAULT_WIDTH:int = 327;
		public static const DEFAULT_HEIGHT:int = 280;
		
		private var _transferLabel:MAssetLabel;
		private var _spriteBtn:Sprite;
		private var _transferBtn:MBitmapButton;
		
		public function MarryTargetPanel()
		{
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setPanelPosition(null);
			_bg = new Bitmap();
			addChild(_bg);
			
			_dragArea = new MSprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_ringShowTip = new Sprite();
			_ringShowTip.graphics.beginFill(0,0);
			_ringShowTip.graphics.drawRect(132,9,60,60);
			_ringShowTip.graphics.endFill();
			addChild(_ringShowTip);
			
			_description = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_description.move(DEFAULT_WIDTH/2,94);
			addChild(_description);
			_description.setHtmlValue(LanguageManager.getWord("ssztl.marriage.promise","",LanguageManager.getWord("ssztl.marriage.promiseType1")));
			
			_btnYes = new MAssetButton1(new FunBtnAsset() as MovieClip);
			_btnYes.move(163-77, 160);
			addChild(_btnYes);
			_labelYes = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_labelYes.move(163-40,165);
			addChild(_labelYes);
			_labelYes.setHtmlValue("Yes");
			
			_btnNo = new MAssetButton1(new FunBtnAsset() as MovieClip);
			_btnNo.move(164, 160);
			addChild(_btnNo);
			
			_labelNo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_labelNo.move(201,165);
			addChild(_labelNo);
			_labelNo.setHtmlValue("No");
			
			_transferLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.RIGHT);
			_transferLabel.move(DEFAULT_WIDTH/2,204);
			addChild(_transferLabel);
			_transferLabel.htmlText = "<u>前往</u>";
			
			_spriteBtn = new Sprite();
			_spriteBtn.graphics.beginFill(0,0);
			_spriteBtn.graphics.drawRect(DEFAULT_WIDTH/2-_transferLabel.textWidth,204,_transferLabel.textWidth,_transferLabel.textHeight);
			_spriteBtn.graphics.endFill();
			addChild(_spriteBtn);
			_spriteBtn.buttonMode = true;
			
			_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
			_transferBtn.move(DEFAULT_WIDTH/2+5,202);
			addChild(_transferBtn);
			
		}
		
		private function initEvent():void
		{
			_btnYes.addEventListener(MouseEvent.CLICK,btnYesClickedHandler);
			_btnNo.addEventListener(MouseEvent.CLICK,btnNoClickedHandler);
			
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_ringShowTip.addEventListener(MouseEvent.MOUSE_OVER,ringOverHandler);
			_ringShowTip.addEventListener(MouseEvent.MOUSE_OUT,ringOutHandler);
			_transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.addEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			
			_transferBtn.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_transferBtn.addEventListener(MouseEvent.MOUSE_OUT,ringOutHandler);
			_spriteBtn.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_spriteBtn.addEventListener(MouseEvent.MOUSE_OUT,ringOutHandler);
		}
		
		protected function btnNoClickedHandler(event:MouseEvent):void
		{
			_refuseProposalHandler();
		}
		
		protected function btnYesClickedHandler(event:MouseEvent):void
		{
			_acceptProposalHandler();
		}
		
		private function removeEvent():void
		{
			_btnYes.removeEventListener(MouseEvent.CLICK,btnYesClickedHandler);
			_btnNo.removeEventListener(MouseEvent.CLICK,btnNoClickedHandler);
			
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_ringShowTip.removeEventListener(MouseEvent.MOUSE_OVER,ringOverHandler);
			_ringShowTip.removeEventListener(MouseEvent.MOUSE_OUT,ringOutHandler);
			_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
			_spriteBtn.removeEventListener(MouseEvent.CLICK,spriteBtnClickHandler);
			
			_transferBtn.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_transferBtn.removeEventListener(MouseEvent.MOUSE_OUT,ringOutHandler);
			_spriteBtn.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_spriteBtn.removeEventListener(MouseEvent.MOUSE_OUT,ringOutHandler);
		}
		private function spriteBtnClickHandler(evt:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC,102108));
		}
		private function transferClickHandler(evt:MouseEvent):void
		{
			if(!GlobalData.selfPlayer.canfly())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var npc:NpcTemplateInfo = NpcTemplateList.getNpc(102108);
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:npc.sceneId,target:npc.getAPoint()}));
			}
		}
		
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(103));
			}
		}
		private function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.marriage.wayfindDemand"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function ringOverHandler(evt:MouseEvent):void
		{
			var itemTemplate:ItemTemplateInfo = ItemTemplateList.getTemplate(_itemId);
			TipsUtil.getInstance().show(itemTemplate,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function ringOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public static function getInstance():MarryTargetPanel
		{
			if(!_instance)
			{
				_instance = new MarryTargetPanel();
			}
			return _instance;
		}
		public function assetsCompleteHandler():void
		{
			_bg.bitmapData = AssetUtil.getAsset('ssztui.marriage.MarryTargetBgAsset',BitmapData) as BitmapData;
			
			if(!_ringShow)
			{
				_ringShow = AssetUtil.getAsset('ssztui.marriage.MarryTargetRingAsset',MovieClip) as MovieClip;
				_ringShow.gotoAndStop(2);
				_ringShow.x = 162;
				_ringShow.y = 39;
				_ringShow.mouseChildren = _ringShow.mouseEnabled = false;
				addChild(_ringShow);
			}
			
			if(_itemId == MarriageInfo.GOOD_RING_ID)
			{
				_ringShow.gotoAndStop(1);
			}else
			{
				_ringShow.gotoAndStop(2);
			}
		}
		
		public function show(acceptProposalHandler:Function, refuseProposalHandler:Function,data:ToMarriageData):void
		{
			_acceptProposalHandler = acceptProposalHandler;
			_refuseProposalHandler = refuseProposalHandler;
			var word:String;
			if(data.marryRequestInfo.relation == 1)
			{
				word = "ssztl.marriage.promiseType1";
			}
			else
			{
				word = "ssztl.marriage.promiseType2";
			}
			if(data.marryRequestInfo.weddingType == WeddingType.GOOD)
			{
				_itemId = MarriageInfo.GOOD_RING_ID;
				if(_ringShow) _ringShow.gotoAndStop(1);				
			}
			else
			{
				_itemId = MarriageInfo.BETTER_RING_ID;
				if(_ringShow) _ringShow.gotoAndStop(2);	
			}
			_description.setHtmlValue(LanguageManager.getWord("ssztl.marriage.promise",data.marryRequestInfo.nick,LanguageManager.getWord(word)));
			
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - DEFAULT_WIDTH,parent.stage.stageHeight - DEFAULT_HEIGHT));
		}
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		public function doEscHandler():void
		{
//			dispose();
		}
		override public function dispose():void
		{
			removeEvent();
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_dragArea)
			{
				_dragArea.graphics.clear();
				_dragArea = null;
			}
			if(_ringShowTip)
			{
				_ringShowTip.graphics.clear();
				_ringShowTip = null;
			}
			if(_ringShow && _ringShow.parent)
			{
				_ringShow.parent.removeChild(_ringShow);
				_ringShow = null;
			}
			_btnYes = null;
			_labelNo = null;
			_labelYes = null;
			_labelNo = null;
			_transferLabel = null;
			if(_spriteBtn)
			{
				_spriteBtn.graphics.clear();
				_spriteBtn = null;
			}
			_transferBtn = null;
			super.dispose();
			_instance = null;
		}
	}
}