package sszt.scene.components.cityCraft
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.club.camp.ClubBossTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	public class CityCraftBossIntroView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _costLabel:MAssetLabel;
		private var _currentLabel:MAssetLabel;
		private var _remainingTimesLabel:MAssetLabel;
//		private var _needClubLevel:MAssetLabel;
		
		public function CityCraftBossIntroView()
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
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(200,0,80,15),new MAssetLabel(LanguageManager.getWord("ssztl.clubCopy.needClubLevel")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.RIGHT)),
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
			
//			_needClubLevel = new MAssetLabel('0',MAssetLabel.LABEL_TYPE20,'left');
//			_needClubLevel.move(276,0);
//			addChild(_needClubLevel);
		}
		
		public function set clubRich(rich:int):void
		{
			_currentLabel.setValue(rich.toString());
		}
		
		public function set remainingCallingTimes(text:String):void
		{
			_remainingTimesLabel.setValue(text);
		}
		
		public function set bossInfo(bossInfo:ClubBossTemplateInfo):void
		{
			_costLabel.setValue(bossInfo.cost.toString());
		}
		
//		public function set needLevel(value:int):void
//		{
//			_needClubLevel.setValue(value.toString());
//		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}