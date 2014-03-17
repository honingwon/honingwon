package sszt.core.view.prompt
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.CloseBtn1Asset;
	
	import sszt.constData.CareerType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.richTextField.LinkTextField;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.ui.BtnAssetClose;

	/**
	 * 升级提示 
	 * @author lxb
	 * 
	 */	
	public class PromptPanel extends Sprite implements ITick
	{
		private static var _instance:PromptPanel;
		
		private var _bg:IMovieWrapper;
		
		private var _closeBtn:MAssetButton1;
		private var _checkBox:CheckBox;
		private var _detailObj:DisplayObject;
		
		private var _detailShow:MAssetLabel;
		private var _btnGo:MCacheAssetBtn1;
		private var _deploy:DeployItemInfo;
		private var _showState:int;//0不显示，1，变形中，2，正常显示，3隐藏中
		private var _showTime:int;//显示30后自动隐藏 1800 * 25
		
		public function PromptPanel()
		{
			super();
			
			mouseEnabled = false;
			_showState = 0;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,301,115)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(101,82,40,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.nopromptToday"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),
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
			
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(85,12,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.warmPrompt"),
//				[new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xffff99),new GlowFilter(0x000000,1,1.5,1.5,8)],TextFormatAlign.LEFT
//			)));
			_checkBox = new CheckBox();
			_checkBox.x = 80;
			_checkBox.y = 90;
			addChild(_checkBox);
			
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(216,81,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.nopromptToday"),
//				[new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC),new GlowFilter(0x000000,1,1.5,1.5,8)],TextFormatAlign.LEFT
//			)));
			_detailShow = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_detailShow.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,7)]);
			_detailShow.wordWrap = true;
			_detailShow.setSize(210,58);
			_detailShow.move(80,13);
			addChild(_detailShow);
			
			_btnGo = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.goRightNow"));
			_btnGo.move(218,77);
			addChild(_btnGo);
			
//			initEvents();				
			this.x = CommonConfig.GAME_WIDTH - 325;
			this.y = CommonConfig.GAME_HEIGHT;
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GET_FIRST_PET,getFirstPetHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.DUPLICATE_TASK_PROMPT,taskPromptHandler);
		}
		
		private function fieldClickHandler(evt:MouseEvent):void
		{
			var deployInfo:DeployItemInfo = new DeployItemInfo();
			deployInfo.type = DeployEventType.POPUP;
			deployInfo.param1 = ModuleType.ACTIVITY;
			DeployEventManager.handle(deployInfo);
		}
		private function taskPromptHandler(evt:CommonModuleEvent):void
		{
			if(_checkBox.selected)return;
			var str:String = "";
			var richField:RichTextField;
			var formatInfoList:Array;
			var formatInfo:RichTextFormatInfo;
			
			str = LanguageManager.getWord("ssztl.core.promptTaskTitle") +  LanguageManager.getWord("ssztl.core.promptTaskContent");
			richField = new RichTextField(210);
			formatInfoList = [];
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = LanguageManager.getWord("ssztl.core.promptTaskTitle").length;
			formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
			formatInfoList.push(formatInfo);
			
			richField.appendMessage(str,[],formatInfoList);
			_deploy = null;
			if(richField)
			{
				show(richField);
			}
		}
		
		private function getFirstPetHandler(evt:CommonModuleEvent):void
		{
			var str:String = "";
			var richField:RichTextField;
			var formatInfoList:Array;
			var formatInfo:RichTextFormatInfo;
			var formatInfo2:RichTextFormatInfo;
			var deploy:DeployItemInfo;
			str = LanguageManager.getWord("ssztl.core.promptTitle3") + LanguageManager.getWord("ssztl.core.promptContent22");
			richField = new RichTextField(210);
			formatInfoList = [];
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle3").length;
			formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
			formatInfoList.push(formatInfo);
						
			formatInfo2 = new RichTextFormatInfo();
			formatInfo2.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord22"));
			formatInfo2.length = LanguageManager.getWord("ssztl.core.promptContentWord22").length;
			formatInfo2.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
			formatInfoList.push(formatInfo2);
			
			deploy = new DeployItemInfo();
			deploy.type = DeployEventType.POPUP;
			deploy.descript = LanguageManager.getWord("ssztl.common.shopWordAsset");
			deploy.param1 = ModuleType.STORE;
			deploy.param2 = 1;
			deploy.param3 = 4;
			deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.common.shopWordAsset"));
			richField.appendMessage(str,[deploy],formatInfoList);
			_deploy = deploy;
			
			if(richField)
			{
				show(richField);
			}
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GET_FIRST_PET,getFirstPetHandler);
		}
		
		private function upgradeHandler(evt:CommonModuleEvent):void
		{	
			if(_checkBox.selected)return;
			var str:String = "";
			var richField:RichTextField;
			var deploy:DeployItemInfo;
			var formatInfoList:Array;
			var formatInfo:RichTextFormatInfo;
			var formatInfo2:RichTextFormatInfo;
			var formatInfo3:RichTextFormatInfo;
			var formatInfo4:RichTextFormatInfo;
			var formatInfo5:RichTextFormatInfo;
			
			switch(GlobalData.selfPlayer.level)
			{
				case 33:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",33) + LanguageManager.getWord("ssztl.core.promptContent33");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",33).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('33');
					formatInfo2.length = '33'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord1"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord1").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord2"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord2").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord1");
					deploy.param1 = 102118;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord1"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 34:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",34) + LanguageManager.getWord("ssztl.core.promptContent34");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",34).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('34');
					formatInfo2.length = '34'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord3"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord3").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord4"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord4").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord3");
					deploy.param1 = 102116;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord3"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 35:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",35) + LanguageManager.getWord("ssztl.core.promptContent35");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",35).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('35');
					formatInfo2.length = '35'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord5"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord5").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord6"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord6").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					formatInfo5 = new RichTextFormatInfo();
					formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord7"));
					formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord7").length;
					formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo5);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord5");
					switch(GlobalData.selfPlayer.career)
					{
						case CareerType.SANWU :
							deploy.param1 = 102301;
							break;
						case CareerType.XIAOYAO :
							deploy.param1 = 102201;
							break;
						case CareerType.LIUXING :
							deploy.param1 = 102402;
							break;
					}
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord5"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 36:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",36) + LanguageManager.getWord("ssztl.core.promptContent36");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",36).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('36');
					formatInfo2.length = '36'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord8"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord8").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord6"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord6").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					formatInfo5 = new RichTextFormatInfo();
					formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord9"));
					formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord9").length;
					formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo5);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord8");
					deploy.param1 = 102113;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord8"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 37:
				{
					if(GlobalData.selfPlayer.clubId != 0)
					{
						str = LanguageManager.getWord("ssztl.core.promptTitle2") + LanguageManager.getWord("ssztl.core.promptContent37");
						richField = new RichTextField(210);
						formatInfoList = [];
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = 0;
						formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle2").length;
						formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
						formatInfoList.push(formatInfo);
						
						formatInfo2 = new RichTextFormatInfo();
						formatInfo2.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord10"));
						formatInfo2.length = LanguageManager.getWord("ssztl.core.promptContentWord10").length;
						formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
						formatInfoList.push(formatInfo2);
						
						formatInfo3 = new RichTextFormatInfo();
						formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord11"));
						formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord11").length;
						formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
						formatInfoList.push(formatInfo3);
						
						formatInfo4 = new RichTextFormatInfo();
						formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord12"));
						formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord12").length;
						formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
						formatInfoList.push(formatInfo4);
						
						formatInfo5 = new RichTextFormatInfo();
						formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord13"));
						formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord13").length;
						formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
						formatInfoList.push(formatInfo5);
						
						deploy = new DeployItemInfo();
						deploy.type = DeployEventType.TASK_NPC;
						deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord11");
						deploy.param1 = 102106;
						deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord11"));
						richField.appendMessage(str,[deploy],formatInfoList);
						_deploy = deploy;
					}
					break;
				}
				case 38:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",38) + LanguageManager.getWord("ssztl.core.promptContent38");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",38).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('38');
					formatInfo2.length = '38'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord14"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord14").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord15"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord15").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					formatInfo5 = new RichTextFormatInfo();
					formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord16"));
					formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord16").length;
					formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo5);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord14");
					deploy.param1 = 102127;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord14"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 39:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",39) + LanguageManager.getWord("ssztl.core.promptContent39");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",39).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('39');
					formatInfo2.length = '39'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord17"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord17").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord18"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord18").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					formatInfo5 = new RichTextFormatInfo();
					formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord19"));
					formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord19").length;
					formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo5);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord17");
					deploy.param1 = 102115;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord17"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 40:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",40) + LanguageManager.getWord("ssztl.core.promptContent40");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",40).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('40');
					formatInfo2.length = '40'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord20"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord20").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord4"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord4").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					formatInfo5 = new RichTextFormatInfo();
					formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord2"));
					formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord2").length;
					formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo5);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord20");
					deploy.param1 = 102112;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord20"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
				case 50:
				{
					str = LanguageManager.getWord("ssztl.core.promptTitle1",50) + LanguageManager.getWord("ssztl.core.promptContent50");
					richField = new RichTextField(210);
					formatInfoList = [];
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = 0;
					formatInfo.length = LanguageManager.getWord("ssztl.core.promptTitle1",50).length;
					formatInfo.textFormat = new TextFormat("SimSun",12,0xff9900,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo);
					
					formatInfo2 = new RichTextFormatInfo();
					formatInfo2.index = str.indexOf('50');
					formatInfo2.length = '50'.length;
					formatInfo2.textFormat = new TextFormat("SimSun",12,0xff9900,true,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo2);
					
					formatInfo3 = new RichTextFormatInfo();
					formatInfo3.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord21"));
					formatInfo3.length = LanguageManager.getWord("ssztl.core.promptContentWord21").length;
					formatInfo3.textFormat = new TextFormat("SimSun",12,0xff5500,null,null,true,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo3);
					
					formatInfo4 = new RichTextFormatInfo();
					formatInfo4.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord18"));
					formatInfo4.length = LanguageManager.getWord("ssztl.core.promptContentWord18").length;
					formatInfo4.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo4);
					
					formatInfo5 = new RichTextFormatInfo();
					formatInfo5.index = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord19"));
					formatInfo5.length = LanguageManager.getWord("ssztl.core.promptContentWord19").length;
					formatInfo5.textFormat = new TextFormat("SimSun",12,0x66ff00,null,null,null,null,null,null,null,null,null,7);
					formatInfoList.push(formatInfo5);
					
					deploy = new DeployItemInfo();
					deploy.type = DeployEventType.TASK_NPC;
					deploy.descript = LanguageManager.getWord("ssztl.core.promptContentWord21");
					deploy.param1 = 102117;
					deploy.param4 = str.indexOf(LanguageManager.getWord("ssztl.core.promptContentWord21"));
					richField.appendMessage(str,[deploy],formatInfoList);
					_deploy = deploy;
					break;
				}
			}
			
			if(richField)
			{
				show(richField);
			}
		}
		
		private function getField(txt:String):TextField
		{
			var field:TextField = new TextField();
			field.width = 205;
			field.height = 40;
			field.multiline = true;
			field.wordWrap = true;
			field.mouseEnabled = field.selectable = false;
			field.htmlText = txt;
			return field;
		}
		
		public static function getInstance():PromptPanel
		{
			if(_instance == null)
			{
				_instance = new PromptPanel();
			}
			return _instance;
		}
		
		public function show(displayObj:DisplayObject):void
		{
			clearDetail();
			_showState = 1;
			_detailObj = displayObj;
			_detailObj.x = 80;
			_detailObj.y = 13;
			addChild(_detailObj);
			
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			
			this.x = CommonConfig.GAME_WIDTH - 325;
			this.y = CommonConfig.GAME_HEIGHT;
			
			GlobalAPI.tickManager.addTick(this);
			
			initEvents();
		}
		
		public function hide():void
		{
			_showState = 0;
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
			clearDetail();
		}
		
		private function clearDetail():void
		{
			if(_detailObj)
			{
				if(_detailObj.hasOwnProperty("dispose"))
				{
					_detailObj["dispose"]();
				}
				if(_detailObj.parent)
				{
					_detailObj.parent.removeChild(_detailObj);
				}
				_detailObj = null;
			}
		}
		
		private function initEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
			_btnGo.addEventListener(MouseEvent.CLICK,btnGoClickHandler);
			_checkBox.addEventListener(MouseEvent.CLICK,closeHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeHandler);
			_btnGo.removeEventListener(MouseEvent.CLICK,btnGoClickHandler);
			_checkBox.removeEventListener(MouseEvent.CLICK,closeHandler);
		}
		
		private function btnGoClickHandler(e:Event):void
		{
			if(_deploy)
			{
				DeployEventManager.handle(_deploy);
			}
			else
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.COPY_LEAVE_EVENT));
				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.DUPLICATE_TASK_PROMPT,taskPromptHandler);				
			}
			hide();			
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
//			GlobalAPI.tickManager.removeTick(this);
			if(_showState == 1)
			{
				_showTime = 30 * 25;
				_showState = 2;
				x = CommonConfig.GAME_WIDTH - 325;
				y = CommonConfig.GAME_HEIGHT - 210;
			}
			else if(_showState == 3)
			{
				y = CommonConfig.GAME_HEIGHT;
				GlobalAPI.tickManager.removeTick(this);
				hide();
			}
			else
			{
				x = CommonConfig.GAME_WIDTH - 325;
				y = CommonConfig.GAME_HEIGHT - 210;
			}
			
		}
		
		private function closeHandler(evt:MouseEvent):void
		{
			hide();	
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_showState == 1)
			{
				if(y <= CommonConfig.GAME_HEIGHT - 210)
				{
					_showTime = 30 * 25;
					_showState = 2;
				}
				else
					y -= 5;
			}
			else if(_showState == 2)
			{
				if(_showTime >= 1)
				{
					_showTime --;
				}
				else
				{
					_showTime = 0;
					_showState = 3;
				}
			}
			else if(_showState == 3)
			{
				if(y >= CommonConfig.GAME_HEIGHT)
				{
					GlobalAPI.tickManager.removeTick(this);
					hide();
				}
				else
					y += 5;
			}
			else
			{
				GlobalAPI.tickManager.removeTick(this);
			}
			
		}
	}
}