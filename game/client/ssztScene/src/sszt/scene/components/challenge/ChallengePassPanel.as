package sszt.scene.components.challenge
{
	import com.greensock.plugins.VolumePlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.ChallengeNextBossSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class ChallengePassPanel extends MSprite implements IPanel
	{
		private var _mediator:SceneMediator;
		
		private var _bg:Bitmap;
		private var _title:Bitmap;
		/**
		 * 存放星的数组
		 */
		private var _starList:Array;
		/**
		 * 通关时间 00:00:00
		 */
		private var _passmarkTimeLable:MAssetLabel;
		
		/**
		 * 通关时间小于霸主即可成为此关霸主
		 */
		private var _descriptionLable:MAssetLabel;
		/**
		 * 是否继续挑战第6关
		 */
		private var _questionsLable:MAssetLabel;
		/**
		 * 继续挑战
		 */
		private var _continuebtnChall:MCacheAssetBtn1;
		/**
		 * 退出副本
		 */
		private var _quitDuplicateBtn:MCacheAssetBtn1;
		
		/**
		 * 存放星的容器
		 */
		private var _starVes:MSprite;
		
		/**
		 * 试炼模板序列号 
		 */
		private var _missionId:int;
		/**
		 * 评星等级 
		 */
		private var _starLevel:int;
		/**
		 * 结束时间 
		 */		
		private var _passTime:int;
		
		public static const DEFAULT_WIDTH:int = 480;
		public static const DEFAULT_HEIGHT:int = 230;
		
		
		public var _countdonwinfo:CountDownInfo;
		
		public function ChallengePassPanel(mediator:SceneMediator,data:Object)
		{
			super();
			_mediator = mediator;
			_missionId = int(data.missionId);
			_starLevel = int(data.star);
			_passTime = int(data.passTime);
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			setPanelPosition(null);
			// TODO Auto Generated method stub
			_bg = new Bitmap(AssetUtil.getAsset("ssztui.scene.ChallengePassBgAsset",BitmapData) as BitmapData);
			addChild(_bg);
			
			_title = new Bitmap();
			_title.x = 156;
			_title.y = 23;
			addChild(_title);
			/* 完美通关　　　通关*/
			if(_starLevel ==3)
				_title.bitmapData = AssetUtil.getAsset("ssztui.scene.ChallengePassTitleAsset1",BitmapData) as BitmapData;
			else
				_title.bitmapData = AssetUtil.getAsset("ssztui.scene.ChallengePassTitleAsset2",BitmapData) as BitmapData;
			
			_starList = [new Bitmap(),new Bitmap(),new Bitmap()];
			
			_passmarkTimeLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_passmarkTimeLable.move(240,124);
			addChild(_passmarkTimeLable);
			_passmarkTimeLable.setHtmlValue(LanguageManager.getWord("ssztl.rank.passTime") + "：" + "<font color='#fff000'><b>1分30秒</b></font>");
			
			_descriptionLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TITLE2);
			_descriptionLable.move(240,146);
			addChild(_descriptionLable);
			_descriptionLable.setHtmlValue(LanguageManager.getWord("ssztl.challenge.passDesc"));
			
			_questionsLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_questionsLable.move(240,185);
			addChild(_questionsLable);
			_questionsLable.setHtmlValue(LanguageManager.getWord("ssztl.challenge.nextDesc"));
			
			_continuebtnChall = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.challenge.continue"));
			_continuebtnChall.move(169,214);
			addChild(_continuebtnChall);
			
			_quitDuplicateBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_quitDuplicateBtn.move(241,214);
			addChild(_quitDuplicateBtn);
			
			_starVes = new MSprite();
			_starVes.move(0,0);
			addChild(_starVes);
			showThreeStar(_starLevel);
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			_continuebtnChall.addEventListener(MouseEvent.CLICK,continueChallClick);
			_quitDuplicateBtn.addEventListener(MouseEvent.CLICK,quitDuplicateClick);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			_countdonwinfo = DateUtil.getCountDownByHour(0,_passTime * 1000);
			var timeStr:String = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			_passmarkTimeLable.setHtmlValue(LanguageManager.getWord("ssztl.rank.passTime") + "：" + "<font color='#fff000'><b>"+ timeStr +"</b></font>");
			
			setLastMark();
			
			if(GlobalData.challInfo.num > 10)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.challenge.overTem"));
			}
		}
		
		/**
		 * 最后一个关卡设置,_continuebtnChall按钮隐藏，调整_quitDuplicateBtn按钮坐标
		 */		
		private function setLastMark():void
		{
			var challengeInfo:ChallengeTemplateListInfo = ChallengeTemplateList.getChallByIndex(ChallengeTemplateList.challArray.length-1);
			
			if(challengeInfo.challengeId == _missionId)
			{
				_questionsLable.visible = false;
				_continuebtnChall.visible = false;
				_quitDuplicateBtn.move(210,214);
			}
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		/**
		 * 显示评星 
		 * @param value 评星等级 1，2，3
		 * 
		 */		
		private function showThreeStar(value:int):void
		{
			while(_starVes && _starVes.numChildren>0){
				_starVes.removeChildAt(0);
			}
			for(var i:int=0; i<value; i++)
			{
				var star:Bitmap = new Bitmap(AssetUtil.getAsset("ssztui.scene.ChallengePassStarAsset",BitmapData) as BitmapData);
				star.x = (star.width+10)*i;
				_starVes.addChild(star);
			}
			_starVes.move(240-_starVes.width/2,85);
		}
		
		
		private function continueChallClick(evt:MouseEvent):void
		{
			ChallengeNextBossSocketHandler.send(int(_missionId+1));
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CHALLENGE_PANEL));
		}
		
		private function quitDuplicateClick(evt:MouseEvent):void
		{
			CopyLeaveSocketHandler.send();
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CHALLENGE_PANEL));
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			_continuebtnChall.removeEventListener(MouseEvent.CLICK,continueChallClick);
			_quitDuplicateBtn.removeEventListener(MouseEvent.CLICK,quitDuplicateClick);
				
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
		}
		
		public override function dispose():void
		{
			removeEvent();
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_title && _title.bitmapData)
			{
				_title.bitmapData.dispose();
				_title = null;
			}
			
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);	
			}
			
			_passmarkTimeLable = null;
			_descriptionLable = null;
			_questionsLable = null;
			_continuebtnChall = null;
			_quitDuplicateBtn = null;
			_starVes = null;
			_countdonwinfo = null;
		}
		
		public function doEscHandler():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}