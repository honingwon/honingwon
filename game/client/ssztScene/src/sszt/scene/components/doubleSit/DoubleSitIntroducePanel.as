package sszt.scene.components.doubleSit
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.DoubleSitMediator;
	
	public class DoubleSitIntroducePanel extends MPanel
	{
		private var _mediator:DoubleSitMediator;
		private var _bg:IMovieWrapper;
		
		public function DoubleSitIntroducePanel(mediator:DoubleSitMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.scene.doubleSitExplain")),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(317,213);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(10,4,297,201)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(15,9,287,99)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(15,111,287,89)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(17,11,283,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(17,114,283,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,15,283,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.doubleSitAward"),MAssetLabel.LABEL_TYPE_TITLE)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,118,283,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.attentsion"),MAssetLabel.LABEL_TYPE_TITLE)),
			]);
			addContent(_bg as DisplayObject);
			
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,null,null,null,null,3);
			var rewardContent:TextField = new TextField();
			rewardContent.text = LanguageManager.getWord("ssztl.scene.doubleSitReWard");
			rewardContent.width = 300;
			rewardContent.height = 65;
			rewardContent.x = 20;
			rewardContent.y = 38;
			rewardContent.setTextFormat(t);
			rewardContent.mouseEnabled = rewardContent.mouseWheelEnabled = false;
			addContent(rewardContent);
			
			var eventContent:TextField = new TextField();
			eventContent.text = LanguageManager.getWord("ssztl.scene.doubleSitEvent");
			eventContent.setTextFormat(t);
			eventContent.width = 300;
			eventContent.height = 65;
			eventContent.x = 20;
			eventContent.y = 140;
			eventContent.mouseEnabled = eventContent.mouseWheelEnabled = false;
			addContent(eventContent);
		}
	}
}