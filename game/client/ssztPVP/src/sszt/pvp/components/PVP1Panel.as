package sszt.pvp.components
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import mhsm.ui.TitleAsset1;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountUpView;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pvp.events.PVPEvent;
	import sszt.pvp.events.PVPMediatorEvent;
	import sszt.pvp.mediators.PVPMediator;
	import sszt.pvp.socketHandlers.PVPActiveJoinSocketHandler;
	import sszt.pvp.socketHandlers.PVPActiveQuitSocketHandler;
	import sszt.pvp.socketHandlers.PVPExploitInfoSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pvp.BtnMainAsset;
	import ssztui.pvp.BtnShopAsset;
	import ssztui.pvp.LabelCanelAsset;
	import ssztui.pvp.LabelFightlAsset;
	import ssztui.pvp.TagAsset1;
	import ssztui.pvp.TagAsset2;
	import ssztui.pvp.TagAsset3;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;

	/**
	 * pvp主面板
	 * @author chendong
	 * 
	 */	
	public class PVP1Panel extends MSprite implements IPanel,ITick
	{
		private var _bgWin:Bitmap;
		private var _bgImg:Bitmap;
		private var _title:Bitmap;
		private var _bg:IMovieWrapper;
		private var _bgUtil:IMovieWrapper;
		
		private var _btnClose:MAssetButton1;
		private var _dragArea:MSprite;
		private var _btnShop:MAssetButton1;
		private var _btnMain:MAssetButton1;
		
		private var _directions:MAssetLabel;
		private var _todayExploit:MAssetLabel;
		private var _fightAmount:MAssetLabel;
		private var _autoFight:CheckBox;
		private var _exploit:MAssetLabel;
		
		private var _sp:Sprite;
		private var _container:MSprite;
		//队列
		private var _queue:MSprite;
		private var _queueBg:IMovieWrapper;
		private var _queueText:MAssetLabel;
		private var _countUpView:CountUpView;
		private var _timeUp:int = 360000;
		private var _labelFight:Bitmap;
		private var _labelCanel:Bitmap;
		
		private var _mediator:PVPMediator;
		
		private var _assetsComplete:Boolean;
		
		public static const DEFAULT_WIDTH:int = 703;
		public static const DEFAULT_HEIGHT:int = 407;
		
		private var _npcInfo:NpcTemplateInfo;
		
		public function PVP1Panel(mediator:PVPMediator)
		{			
			_mediator = mediator;
			if(_mediator.pvpModule.pvpResultPanel)
			{
				_mediator.pvpModule.pvpResultPanel.dispose();
				_mediator.pvpModule.pvpResultPanel = null;
			}
				
			_npcInfo = NpcTemplateList.getNpc(102110);
			init();
			initEvent();
			PVPExploitInfoSocketHandler.send();
			if(GlobalData.pvpInfo.pvp1_flag)
			{
				_autoFight.selected = true;
				if(GlobalData.pvpInfo.user_pvp_state == 0)
				{					
					autoFight(null);
				}
				else if(GlobalData.pvpInfo.user_pvp_state == 1)
				{
					_queue.visible = true;
					_labelFight.visible = false;
					_labelCanel.visible = true;
				}
			}
		}
		
		protected function init():void
		{
			
			_sp = new Sprite();
			addChild(_sp);			
			_container = new MSprite();
			addChild(_container);
			setPanelPosition(null);
			
			_bgWin = new Bitmap();
			_container.addChild(_bgWin);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(10,19,683,380)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(15,24,673,370))
				
			]);
			_container.addChild(_bg as DisplayObject);
			
			_bgImg = new Bitmap();
			_bgImg.x = 16;
			_bgImg.y = 25;
			_container.addChild(_bgImg);
			
			_title = new Bitmap();
			_title.x = 265;
			_title.y = -21;
			_container.addChild(_title);
			
			_directions = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_directions.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,3)]);
			_directions.wordWrap = true;
			_directions.setSize(210,208);
			_directions.setHtmlValue(LanguageManager.getWord('ssztl.pvp.directions1') + "\n\n" +LanguageManager.getWord('ssztl.pvp.directions2'));
			
			_bgUtil = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,65,128,28),new Bitmap(new TagAsset1())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(569,65,128,28),new Bitmap(new TagAsset2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(539,281,74,17),new Bitmap(new TagAsset3())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(27,103,210,208),_directions),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(597,104,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(637,104,38,38),new Bitmap(CellCaches.getCellBg()))
			]);
			_container.addChild(_bgUtil as DisplayObject);
			
			_dragArea = new MSprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			_container.addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-26,9);
			_container.addChild(_btnClose);
			
			_todayExploit = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_todayExploit.move(DEFAULT_WIDTH/2,233);
			_container.addChild(_todayExploit);
			_todayExploit.setHtmlValue(
				"<font color='#ffcc33'>" + LanguageManager.getWord('ssztl.pvp.todayExploit') + "</font>" +
				"<font color='#00ff33'><b>2/20</b></font>");
			
//			_fightAmount = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
//			_fightAmount.move(DEFAULT_WIDTH/2,255);
//			addChild(_fightAmount);
//			_fightAmount.setHtmlValue(
//				"<font color='#ffcc33'>" + LanguageManager.getWord('ssztl.pvp.fightAmount') + "</font>" +
//				"<font color='#00ff33'><b>" + 5 + "</b></font>");
			
			_autoFight = new CheckBox();
			_autoFight.label = LanguageManager.getWord("ssztl.pvp.autoFight");
			_autoFight.setSize(75,20);
			_autoFight.move(318,280);
			_container.addChild(_autoFight);
			
			_btnMain = new MAssetButton1(new BtnMainAsset() as MovieClip);
			_btnMain.move(315,311);
			_container.addChild(_btnMain);
			
			_labelFight = new Bitmap(new LabelFightlAsset());
			_labelFight.x = 326;
			_labelFight.y = 326;
			_container.addChild(_labelFight);
			
			_labelCanel = new Bitmap(new LabelCanelAsset());
			_labelCanel.x = 321;
			_labelCanel.y = 333;
			_container.addChild(_labelCanel);
			_labelCanel.visible = false;
			
			_exploit = new MAssetLabel("",MAssetLabel.LABEL_TYPE_EN,TextFormatAlign.LEFT);
			_exploit.textColor = 0xffcc00;
			_exploit.move(615,264);
			_container.addChild(_exploit);
			_exploit.setHtmlValue("<font size='30'>68</font>");
			
			_btnShop = new MAssetButton1(new BtnShopAsset() as MovieClip);
			_btnShop.move(544,318);
			_container.addChild(_btnShop);
			
			//队列中...
			_queue = new MSprite();
			_queue.move(DEFAULT_WIDTH-204 >> 1,150);
			_container.addChild(_queue);
			
			_queueBg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10,new Rectangle(0,0,204,70)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(66,15,60,14),new MAssetLabel(LanguageManager.getWord('ssztl.pvp.queueTitle'),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),
			]);
			_queue.addChild(_queueBg as DisplayObject);
			
			_queueText = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_queueText.move(75,37);
			_queue.addChild(_queueText);
			_queueText.setHtmlValue(
				"<font color='#ffcc33'>" + LanguageManager.getWord('ssztl.pvp.queueTag'));
//				+ "</font>" + "<font color='#00ccff'><b>00:56</b></font>");
			
			_countUpView = new CountUpView();
			_countUpView.setColor(0x00ccff);
			_countUpView.move(102,37);
			_queue.addChild(_countUpView);

			_queue.visible = false;			
		}
		
		public function assetsCompleteHandler():void
		{	
			_assetsComplete = true;
			_bgWin.bitmapData = AssetUtil.getAsset("ssztui.pvp.BgWinBorderAsset",BitmapData) as BitmapData;
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.pvp.bgImageAsset",BitmapData) as BitmapData;
			_title.bitmapData = AssetUtil.getAsset("ssztui.pvp.TitleAsset",BitmapData) as BitmapData;
			
		}
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_autoFight.addEventListener(MouseEvent.CLICK, autoFight);
			_btnMain.addEventListener(MouseEvent.CLICK,mainClickHandler);
			addEventListener(PVPEvent.PVP_JOIN, jionPVP);
			addEventListener(PVPEvent.PVP_QUIT, quitPVP);
			GlobalData.pvpInfo.addEventListener(PVPEvent.PVP_EXPLOIT_INFO_UPDATE,setExploitInfo);
			
			_btnShop.addEventListener(MouseEvent.CLICK,openClick);
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMovePVP1);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeScenePVP1);
		}
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_autoFight.removeEventListener(MouseEvent.CLICK, autoFight);
			_btnMain.removeEventListener(MouseEvent.CLICK,mainClickHandler);
			removeEventListener(PVPEvent.PVP_JOIN, jionPVP);
			removeEventListener(PVPEvent.PVP_QUIT, quitPVP);
			GlobalData.pvpInfo.removeEventListener(PVPEvent.PVP_EXPLOIT_INFO_UPDATE,setExploitInfo);
			
			_btnShop.removeEventListener(MouseEvent.CLICK,openClick);
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMovePVP1);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeScenePVP1);
		}
		private function autoFight(e:MouseEvent):void
		{
			if(GlobalData.selfScenePlayerInfo.state.getDead()) return;	
			
			if(_autoFight.selected)
			{
				if(GlobalData.leaderId > 0)
				{
					MAlert.show(LanguageManager.getWord("sszlt.common.isSureEnterPvp1"),
						LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null, leaveCloseHandler);
					return;
				}
				
				GlobalData.pvpInfo.pvp1_flag = true;
				if(!_queue.visible)
				{
					PVPActiveJoinSocketHandler.send(1001);
					_btnMain.enabled = false;
				}
			}
			else
				GlobalData.pvpInfo.pvp1_flag = false;
			
			function leaveCloseHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.TEAM_LEAVE));
					var ti:Timer = new Timer(1000,1);
					ti.addEventListener(TimerEvent.TIMER,timerHandle);
					ti.start();
					function timerHandle(evt:TimerEvent):void
					{
						GlobalData.pvpInfo.pvp1_flag = true;
						if(!_queue.visible)
						{
							PVPActiveJoinSocketHandler.send(1001);
							_btnMain.enabled = false;
						}
					}					
				}
				else
				{
					_autoFight.selected = false;
				}
			}
		}
		private function mainClickHandler(e:MouseEvent):void
		{
			if(GlobalData.leaderId > 0)
			{
				MAlert.show(LanguageManager.getWord("sszlt.common.isSureEnterPvp1"),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
				return;
			}
			
			if(_queue.visible)	//取消列队
			{
				PVPActiveQuitSocketHandler.send(1001);
				_btnMain.enabled = false;
			}else				//开始战斗
			{
				if(GlobalData.selfScenePlayerInfo.state.getDead()) return;
				PVPActiveJoinSocketHandler.send(1001);
				_btnMain.enabled = false;
			}
			function leaveCloseHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					//					TeamLeaveSocketHandler.sendLeave();
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.TEAM_LEAVE));
					var ti:Timer = new Timer(1000,1);
					ti.addEventListener(TimerEvent.TIMER,timerHandle);
					ti.start();						
					function timerHandle(evt:TimerEvent):void
					{
						if(_queue.visible)	//取消列队
						{
							PVPActiveQuitSocketHandler.send(1001);
							_btnMain.enabled = false;
						}else				//开始战斗
						{
							PVPActiveJoinSocketHandler.send(1001);
							_btnMain.enabled = false;
						}
					}					
				}
			}
			
		}
		
		private function jionPVP(e:PVPEvent):void
		{
			_btnMain.enabled = true;
			_queue.visible = true;
			_countUpView.start(_timeUp);
			_labelFight.visible = false;
			_labelCanel.visible = true;
		}
		private function quitPVP(e:PVPEvent):void
		{
			if(GlobalData.pvpInfo.pvp1_flag)
			{
				GlobalData.pvpInfo.pvp1_flag = false;
				_autoFight.selected = false;	
			}
			_btnMain.enabled = true;
			_labelFight.visible = true;
			_labelCanel.visible = false;
			_queue.visible = false;
			GlobalData.pvpInfo.user_pvp_state = 0;
		}
		
		private function setPanelPosition(e:Event):void
		{
			var x:int = Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1);
			var y:int = Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1);
			_sp.graphics.clear();
			_sp.graphics.beginFill(0,0.5);
			_sp.graphics.drawRect(0,0,CommonConfig.GAME_WIDTH,CommonConfig.GAME_HEIGHT);
			_sp.graphics.endFill();
			_container.move(x,y);
			//move( x , y );
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - width,parent.stage.stageHeight - height));
		}
		
		public function setExploitInfo(e:PVPEvent):void
		{
			_exploit.setHtmlValue("<font size='30'>"+GlobalData.pvpInfo.exploit+"</font>");
			_todayExploit.setHtmlValue(
				"<font color='#ffcc33'>" + LanguageManager.getWord('ssztl.pvp.todayExploit') + "</font>" +
				"<font color='#00ff33'><b>"+GlobalData.pvpInfo.pvp1_day_award+"/60</b></font>");
		}
		
		private function openClick(evt:MouseEvent):void
		{
			SetModuleUtils.addExStore(new ToStoreData(ShopID.GX,2));
		}
		
		private function selfMovePVP1(e:BaseSceneObjInfoUpdateEvent):void
		{
			if(_npcInfo == null)return;
			var selfInfo:BaseSceneObjInfo = e.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		private function changeScenePVP1(e:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			if(GlobalData.pvpInfo.user_pvp_state == 1)	//取消列队
			{
				MAlert.show(LanguageManager.getWord('ssztl.pvp.closeDirections'),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,quitAndClose);
			}
			else
				dispose();
			function quitAndClose(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					PVPActiveQuitSocketHandler.send(1001);
					GlobalData.pvpInfo.user_pvp_state = 0;
					if(_mediator)
						dispose();
				}
			}			
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		public function setToTop():void
		{
			if(parent)
			{
				parent.setChildIndex(this,parent.numChildren - 1);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgWin && _bgWin.bitmapData)
			{
				_bgWin.bitmapData.dispose();
				_bgWin = null;
			}
			if(_bgImg && _bgImg.bitmapData)
			{
				_bgImg.bitmapData.dispose();
				_bgImg = null;
			}
			if(_title && _title.bitmapData)
			{
				_title.bitmapData.dispose();
				_title = null;
			}
			if(_dragArea && _dragArea.graphics)
			{
				_dragArea.graphics.clear();
				_dragArea = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			_directions = null;
			_todayExploit = null;
			_fightAmount = null;
			_autoFight = null;
			_exploit = null;
			_btnShop = null;
			_btnMain = null;
			if(_labelFight && _labelFight.bitmapData)
			{
				_labelFight.bitmapData.dispose();
				_labelFight = null;
			}
			if(_labelCanel && _labelCanel.bitmapData)
			{
				_labelCanel.bitmapData.dispose();
				_labelCanel = null;
			}
			if(_queueBg)
			{
				_queueBg.dispose();
				_queueBg = null;
			}
			if(_queue && _queue.parent)
			{
				_queue.parent.removeChild(_queue);
				_queue = null;
			}
			_container = null;
			_sp = null;
			dispatchEvent(new Event(Event.CLOSE));			
			super.dispose();
			
		}
	}
}