package  sszt.scene.components.onlineReward
{
	import com.greensock.plugins.VolumePlugin;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.dailyAward.DailyAwardTemplateInfo;
	import sszt.core.data.dailyAward.DailyAwardTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerDairyAwardSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	
	public class OnlineRewardPanel2  extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _mediator:SceneMediator;
		/**
		 * 是否可领取
		 * true可领取,fale不可领取 
		 */
		private var _canGet:Boolean = false;
		private var seconds:int = 0;
		/**
		 * 倒计时 
		 * 00:00:00 
		 */
		private var _countDown:CountDownView;
		/**
		 * 提示信息
		 * 可领取:"您现在可领取"
		 * 不可领取:"您可以在倒计时结束后领取"
		 */		
		private var _canGetGiftlable:MAssetLabel;
		
		private var _cellBg:Array;
		private var _cellList:Array;
		/**
		 * 可领取:"立即领取"
		 * 不可领取:"稍后领取"
		 */
		private var _getGiftBtn:MCacheAssetBtn1;
		/**
		 * 奖励id 
		 */
		private var _rewardId:int;
		
		public static const PAGESIZE:int = 3;		
		public static const DEFAULT_WIDTH:int = 235;
		public static const DEFAULT_HEIGHT:int = 270;
		
		public function OnlineRewardPanel2(mediator:SceneMediator,data:Object)
		{
			_mediator = mediator
			_canGet = Boolean(data.canGet);
			seconds = int(data.seconds);
			_rewardId = int(data.rewardId);
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.OnlineGifTitleAsset"))
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.OnlineGifTitleAsset") as Class)());
			super(new MCacheTitle1("",imageBtmp),true,-1,true,true);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(DEFAULT_WIDTH,DEFAULT_HEIGHT);
			
//			setPanelPosition(null);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10,4,DEFAULT_WIDTH-20,210)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(10, 213, DEFAULT_WIDTH-20, 25), new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(10, 105, DEFAULT_WIDTH-20, 25), new MCacheCompartLine2()),
				
			]);
			addContent(_bg as DisplayObject);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("Verdana",24,0x33ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.setSize(DEFAULT_WIDTH,30);
			_countDown.move(0,30);
			addContent(_countDown);
			_countDown.start(seconds);
			
			//_cellList = new Vector.<NPCSellCell>();
			_cellList = new Array();
			for(var i:int = 0;i< PAGESIZE;i++)
			{
				var cell:Cell = new Cell();
				addContent(cell);
				_cellList.push(cell);
			}
			
			_canGetGiftlable = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_canGetGiftlable.move(117,72);
			addContent(_canGetGiftlable);
			
			_getGiftBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.common.getGift"));
			_getGiftBtn.move(68,225);
			addContent(_getGiftBtn);
			
			if(!_canGet)
			{
				_canGetGiftlable.setHtmlValue(LanguageManager.getWord('ssztl.common.getGiftLableLater'));
				_getGiftBtn.label = LanguageManager.getWord("ssztl.common.getGiftLater");
		    }
			else
			{
				_canGetGiftlable.setHtmlValue(LanguageManager.getWord('ssztl.common.getGiftLable'));
				_getGiftBtn.label = LanguageManager.getWord("ssztl.common.getGift");
			}
			
			initEvent();
			updateCell(_rewardId);
		}
		
		private function initEvent():void
		{
			_getGiftBtn.addEventListener(MouseEvent.CLICK,clickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SYNCH_TIME,synchTime);
			_countDown.addEventListener(Event.COMPLETE,completeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		
		private function removeEvent():void
		{
			_getGiftBtn.removeEventListener(MouseEvent.CLICK,clickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SYNCH_TIME,synchTime);
			_countDown.removeEventListener(Event.COMPLETE,completeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			 if(_canGet)
			 {
				 if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
				 {
					 QuickTips.show(LanguageManager.getWord("ssztl.scene.bagFull"));
					 return;
				 }
//				 PlayerDairyAwardSocketHandler.send();
				 _canGetGiftlable.setHtmlValue(LanguageManager.getWord('ssztl.common.getGiftLableLater'));
				 _getGiftBtn.label = LanguageManager.getWord("ssztl.common.getGiftLater");
			 }
			 else
			 {
				 ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ONLINE_REWARD_PANEL));
			 }
		}
		
		private function synchTime(event:CommonModuleEvent):void
		{
			_canGet = Boolean(event.data.canGet);
			_countDown.start(int(event.data.seconds));
			updateCell(int(event.data.rewardId));
			
		}
		
		private function completeHandler(evt:Event):void
		{
			if(_canGet) return;
			_canGet = true;
			_canGetGiftlable.setHtmlValue(LanguageManager.getWord('ssztl.common.getGiftLable'));
			_getGiftBtn.label = LanguageManager.getWord("ssztl.common.getGift");
		}
		
		private function updateCell(awardId:int):void
		{
			clearCellList();
			var dailyAwardTemplateInfo:DailyAwardTemplateInfo = DailyAwardTemplateList.getTemplate(awardId);
			if(!dailyAwardTemplateInfo) return;
			var a:int = 0;
			for(var j:int=0; j<dailyAwardTemplateInfo.itemIdList.length;j++)
			{
				var item:ItemInfo = new ItemInfo();
				item.isBind = true;
				item.templateId = int(dailyAwardTemplateInfo.itemIdList[j]);
				item.count = int(dailyAwardTemplateInfo.itemCountList[j]);
				if(_cellList[j].itemInfo == null)
				{
					_cellList[j].itemInfo = item;
					a++;
				}
				
			}
			for(var b:int=0; b<a; b++)
			{
				_cellList[b].move(117+b*42-a*20,138);
				_cellList[b].visible = true;
			}
		}
		
		private function clearCellList():void
		{
			for(var i:int = 0;i < _cellList.length;i++)
			{
				if(_cellList[i].itemInfo != null)
				{
					_cellList[i].itemInfo = null;
				}
				_cellList[i].visible = false;
			}
		}
		
		private function setPanelPosition(e:Event):void
		{
			move((CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
		}
		override public function dispose():void
		{
			removeEvent();
			dispatchEvent(new Event(Event.CLOSE));
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			super.dispose();
		}
		
	}
}