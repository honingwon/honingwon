package sszt.petpvp.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.petpvp.socketHandlers.PetPVPStartChallengingWithClearCDSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.petPVP.TitleResultAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class PetPVPFailurePanel extends MPanel
	{
		public static var instance:PetPVPFailurePanel;
		private var _bg:IMovieWrapper;
		
		private var _titleLabel:MAssetLabel;
		private var _copperLabel:MAssetLabel;
		private var _expLabel:MAssetLabel;
		private var _btnOK:MCacheAssetBtn1;
		private var _btnNO:MCacheAssetBtn1;
		private var _tip:MAssetLabel;
		
		private var _petId:Number;
		private var _opponentPetId:Number
		
		public function PetPVPFailurePanel()
		{
			super(new MCacheTitle1('',new Bitmap(new TitleResultAsset())), true, -1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(235,269);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,215,210)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,212,215,25),new Bitmap(new SplitCompartLine2())),
			]); 
			addContent(_bg as DisplayObject);
			
			_titleLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B);
			_titleLabel.textColor = 0xff0000;
			_titleLabel.move(117,38);
			addContent(_titleLabel);
			_titleLabel.setHtmlValue(LanguageManager.getWord("ssztl.petpvp.resultFailure"));
			
			_copperLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7);
			_copperLabel.move(117,72);
			addContent(_copperLabel);
			
			_expLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7);
			_expLabel.move(117,92);
			addContent(_expLabel);
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_tip.wordWrap = true;
			_tip.setSize(165,40);
			_tip.move(35,140);
			addContent(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.petpvp.clearCDTip" , 10));
			
			_btnOK = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.scene.yes'));
			_btnOK.move(42,224);
			addContent(_btnOK);
			
			_btnNO = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.scene.no'));
			_btnNO.move(119,224);
			addContent(_btnNO);
		}
		private function initEvent():void
		{
			_btnOK.addEventListener(MouseEvent.CLICK,btnOKClickHandler);
			_btnNO.addEventListener(MouseEvent.CLICK,btnNOClickHandler);
		}
		
		protected function btnNOClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		
		protected function btnOKClickHandler(event:MouseEvent):void
		{			
			PetPVPStartChallengingWithClearCDSocketHandler.send(_petId,_opponentPetId);
			dispose();
		}
		
		private function removeEvent():void
		{
			_btnOK.removeEventListener(MouseEvent.CLICK,btnOKClickHandler);
			_btnNO.removeEventListener(MouseEvent.CLICK,btnNOClickHandler);
		}
		
		public static function getInstance():PetPVPFailurePanel
		{
			if(!instance)
			{
				instance = new PetPVPFailurePanel();
			}
			return instance;
		}
		
		public function show(copper:int,exp:int,petId:Number,opponentPetId:Number):void
		{
			_petId = petId;
			_opponentPetId = opponentPetId;
			_copperLabel.setValue(LanguageManager.getWord("ssztl.common.copper")+" "+copper.toString());
			_expLabel.setValue(LanguageManager.getWord("ssztl.swordsMan.expValue")+" "+exp.toString());
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			instance = null;
			
			_copperLabel = null;
			_expLabel = null;
			if(_btnOK)
			{
				_btnOK.dispose();
				_btnOK =null;
			}
		}
	}
}