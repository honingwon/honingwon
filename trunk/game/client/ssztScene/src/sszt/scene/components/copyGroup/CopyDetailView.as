package sszt.scene.components.copyGroup
{
	import flash.display.DisplayObject;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.CopyGroupMediator;
	
	public class CopyDetailView extends MPanel
	{
		private var _mediator:CopyGroupMediator;
		private var _copyName:MAssetLabel;
		private var _copyDescrip:MTextArea;
		
		public function CopyDetailView(mediator:CopyGroupMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.scene.copyExplain")),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(449,300);
			
			_copyName = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_copyName.move(210,0);
			addContent(_copyName);
			
			_copyDescrip = new MTextArea();
			_copyDescrip.setSize(440,250);
			_copyDescrip.textField.textColor = 0xffffff;
			_copyDescrip.move(5,40);
			_copyDescrip.editable = false;
			_copyDescrip.enabled = true;	
			addContent(_copyDescrip);
		}
		
		public function show():void
		{
			_copyName.setValue(LanguageManager.getWord("ssztl.scene.kuHai"));
			var str:String = LanguageManager.getWord("ssztl.scene.copyDescript");
			_copyDescrip.appendText(str);
			
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
	}
}