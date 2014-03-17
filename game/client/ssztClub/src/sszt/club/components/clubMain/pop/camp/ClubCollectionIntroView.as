package sszt.club.components.clubMain.pop.camp
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.club.camp.ClubCollectionTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	public class ClubCollectionIntroView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _costLabel:MAssetLabel;
		private var _currentLabel:MAssetLabel;
		private var _remainingTimesLabel:MAssetLabel;
		private var _cdBox:MSprite;
		private var _countDown:CountDownView;
		private var _needClubLevel:MAssetLabel;
		
		public function ClubCollectionIntroView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.leftTimes"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,18,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.costRich")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,36,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.currentRich")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,72,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.award")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(190,0,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.clubCopy.needClubLevel")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(190,18,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.callCdLabel")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
			]);
			addChild(_bg as DisplayObject);
			
			_remainingTimesLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_remainingTimesLabel.move(79,0);
			addChild(_remainingTimesLabel);
			
			_costLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_costLabel.move(79,18);
			addChild(_costLabel);
			
			_currentLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_currentLabel.move(79,36);
			addChild(_currentLabel);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00));
			_countDown.textField.autoSize = "left";
			_countDown.setSize(150,30);
			_countDown.move(266,18);
			addChild(_countDown);
//			_countDown.start(99999);
			
			_needClubLevel = new MAssetLabel('0',MAssetLabel.LABEL_TYPE20,'left');
			_needClubLevel.move(266,0);
			addChild(_needClubLevel);
		}
		
		public function set remainingCallingTimes(text:String):void
		{
			_remainingTimesLabel.setValue(text);
		}
		
		public function set collectionInfo(collectionInfo:ClubCollectionTemplateInfo):void
		{
			_costLabel.setValue(collectionInfo.cost.toString());
			_needClubLevel.setValue(collectionInfo.guild_level.toString());
		}
		
		public function set clubRich(rich:int):void
		{
			_currentLabel.setValue(rich.toString());
		}
		
		public function set cd(time:int):void
		{
			_countDown.start(time);
			
//			if(time <= 0)
//			{
//				
//			}
//			else
//			{
//				
//			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}