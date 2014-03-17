package sszt.scene.components.expCompensate
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.ExpCompensateMediator;
	
	public class ExpCompensatePanel extends MPanel
	{
		private var _mediator:ExpCompensateMediator;
		private var _bg:IMovieWrapper;
		private var _cashBtn:MCacheAsset1Btn;
		private var _unlockBtn:MCacheAsset1Btn;
		
		public function ExpCompensatePanel(mediator:ExpCompensateMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.scene.expRedeem")),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(283,196);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,283,164)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(4,3,275,157)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,11,88,20),new MAssetLabel(LanguageManager.getWord("ssztl.scene.lockedExp"),MAssetLabel.LABELTYPE3,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,38,88,20),new MAssetLabel(LanguageManager.getWord("ssztl.scene.unlockedExp"),MAssetLabel.LABELTYPE3,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,65,88,20),new MAssetLabel(LanguageManager.getWord("ssztl.scene.redeemExpUpLine"),MAssetLabel.LABELTYPE3,TextFormatAlign.RIGHT)),
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(100,8,165,22)),
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(100,35,165,22)),
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(100,62,165,22)),
			]);
			addContent(_bg as DisplayObject);
		}
	}
}