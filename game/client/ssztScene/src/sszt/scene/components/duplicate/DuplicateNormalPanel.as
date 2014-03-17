package sszt.scene.components.duplicate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.duplicate.DuplicateNormalInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyInfoSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBLeaveBtnAsset;
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.scene.FBTaskBtnAsset;
	
	public class DuplicateNormalPanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		private var _leaveBtn:MCacheAssetBtn1;
		private var _upStrength:MAssetLabel;
		
		private var _countDownView:CountDownView;
		
		private var _dorpItemCells:Array;  //_lockCell:BaseItemInfoCell;
		
		private var _taskBtn:MAssetButton1;
		
		public function DuplicateNormalPanel(argMediator:SceneMediator)
		{
			super();			
			_mediator = argMediator;
//			_mediator.duplicateNormalInfo.setDuplicateInfo(CopyTemplateList.getCopy(1202001));
			initialView();
			initialEvents();			
			_countDownView.start(duplicateNormalInfo.leftTime);
			CopyInfoSocketHandler.send();
		}
		
		private function initialView():void
		{
			x = CommonConfig.GAME_WIDTH - 230;
			y = 190;
			mouseEnabled = false;
			
			_container = new Sprite();
			addChild(_container);
			_container.mouseEnabled = false;
			
			_background = new Shape();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,208,10);
			_background.graphics.endFill();
//			var matr:Matrix = new Matrix();
//			matr.createGradientBox(230,230,Math.PI/2,0,10);
//			_background.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x000000],[0.70,0],[0,255],matr,SpreadMethod.PAD);
//			_background.graphics.drawRect(0,0,208,230);
			_container.addChild(_background);
			
			var pl:int = 22;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,250),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+13,175,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+54,175,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+95,175,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+136,175,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,4,182,17),new MAssetLabel(duplicateNormalInfo.duplicateName ,MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,31,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.leftTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,114,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.increaseStrikeMethod"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,156,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyDrop"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT))
				
			]);
			_container.addChild(_bg as DisplayObject);
			
			_taskBtn = new MAssetButton1(new FBTaskBtnAsset() as MovieClip);
			_taskBtn.x = 206;
			_container.addChild(_taskBtn);
			
			_countDownView = new CountDownView();
			_countDownView.setColor(0xffcc00);
			_countDownView.move(pl+73,31);
			_container.addChild(_countDownView);
			
			_dorpItemCells = [];
			for(var i:int; i < 4 ; i++)
			{
				var cell:BaseItemInfoCell = new BaseItemInfoCell();
				cell.move(pl+13 + i * 41, 175);
				cell.itemInfo = null;
				_container.addChild(cell);
				_dorpItemCells.push(cell);
			}
			//显示推荐战斗力信息
			var list:Array = duplicateNormalInfo.copyTemplicat.recommendValue;
			for(var m:int; m < list.length; m++)
			{
				var recommend:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
				recommend.setSize(200,15);
				recommend.move(pl+12,54 + 18 * m);
				_container.addChild(recommend);
				var curProperty:String = LanguageManager.getWord("ssztl.scene.currentProperty", GlobalData.selfPlayer.getPropertyByType(int(list[m][1])).toString());
				recommend.setHtmlValue(list[m][0] + "<font color=\'#00ff00\'>" + list[m][2] + "</font>" + curProperty);
				//提取当前战斗力显示
			}
			// 显示当前物品掉落信息
			var dorpItem:Array = duplicateNormalInfo.copyTemplicat.award;
			var cellIndex:int = 0;
			for(var n:int = 0; n < dorpItem.length; n++)
			{
				if(cellIndex < 4 && int(dorpItem[n]) > 1000)
				{
					var item:ItemInfo = new ItemInfo();
					item.templateId = int(dorpItem[n]);
					(_dorpItemCells[cellIndex] as BaseItemInfoCell).itemInfo = item;
					cellIndex++;
				}
				
			}
			_upStrength = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)
			_upStrength.setHtmlValue("<a href=\'event:0\'><u>强化</u></a>、<a href=\'event:1\'><u>鉴定</u></a>、<a href=\'event:2\'><u>淘宝</u></a>、<a href=\'event:3\'><u>提升技能</u></a>");
			_upStrength.textColor = 0x2fb7cf;
			_upStrength.move(pl+12,132);
			_upStrength.mouseEnabled = true;
			_container.addChild(_upStrength);
			
			_leaveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_leaveBtn.x = 90;
			_leaveBtn.y = 217;
			_container.addChild(_leaveBtn);
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
			_upStrength.addEventListener(TextEvent.LINK,linkClickHandler);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			_leaveBtn.removeEventListener(MouseEvent.CLICK,quitDuplicate);
			_upStrength.removeEventListener(TextEvent.LINK,linkClickHandler);
			
			_taskBtn.removeEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.removeEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.removeEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function taskClickHandler(evt:MouseEvent):void
		{
			
		}
		private function taskOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.task"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function taskOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function linkClickHandler(evt:TextEvent):void
		{
			var argument:String = evt.text;
			if(argument == "0")	//强化
			{
				SetModuleUtils.addFurnace();
			}else if(argument == "1")	//鉴定
			{
				SetModuleUtils.addFurnace(1);
			}else if(argument == "2")	//淘宝
			{
				SetModuleUtils.addBox(1);
			}else if(argument == "3")	//提升技能
			{
				SetModuleUtils.addSkill();
			}
		}
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 230;
			y = 190;
		}
		private function updateCopyInfo(e:CommonModuleEvent):void
		{
			var data:IPackageIn = e.data as IPackageIn;
			var type:int = data.readShort();
			var missionId:int = data.readShort();
			var startTime:Number = data.readNumber();
			var time:Number =	int(GlobalData.systemDate.getSystemDate().getTime() / 1000);
			duplicateNormalInfo.leftTime = duplicateNormalInfo.leftTime - (time - startTime);
			_countDownView.stop();
			_countDownView.start(duplicateNormalInfo.leftTime);
		}
		private function quitDuplicate(evt:Event):void
		{
			var message:String;
			if(GlobalData.copyEnterCountList.isPKCopy()&& GlobalData.selfPlayer.pkState == 0) message = LanguageManager.getWord("ssztl.scene.isSureBeLoser");
			else message = LanguageManager.getWord("ssztl.scene.isSureLeaveCopy");
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
			function leaveAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{	
					_mediator.sceneInfo.playerList.self.setKillOne();
					CopyLeaveSocketHandler.send();
				}
			}
		}
		public function show():void
		{
			
		}
		public function hide():void
		{
			
		}
		public function get duplicateNormalInfo():DuplicateNormalInfo
		{
			return _mediator.duplicateNormalInfo;
		}
		public function dispose():void
		{
			removeEvents();
			duplicateNormalInfo.clearData();
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			_background = null;
			_mediator = null;
			_container = null;	
			_upStrength = null;
			if(parent)parent.removeChild(this);
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
	}
}