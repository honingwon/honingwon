package sszt.petpvp.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.petPVP.TitleResultAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class PetPVPSuccessPanel extends MPanel
	{
		public static var instance:PetPVPSuccessPanel;
		
		private var _bg:IMovieWrapper;
		
		private var _titleLabel:MAssetLabel;
		private var _copperLabel:MAssetLabel;
		private var _expLabel:MAssetLabel;
		private var _cell:BaseItemInfoCell;
		private var _btnOK:MCacheAssetBtn1;
		
		public function PetPVPSuccessPanel()
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
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(99,140,38,38),new Bitmap(CellCaches.getCellBg())),
			]); 
			addContent(_bg as DisplayObject);
			
			_titleLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B);
			_titleLabel.move(117,38);
			addContent(_titleLabel);
			_titleLabel.setHtmlValue(LanguageManager.getWord("ssztl.petpvp.resultSuccess"));
			
			_copperLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7);
			_copperLabel.move(117,72);
			addContent(_copperLabel);
			
			_expLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7);
			_expLabel.move(117,92);
			addContent(_expLabel);
			
			_cell = new BaseItemInfoCell();
			_cell.move(99,140);
			addContent(_cell);
			
			_btnOK = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.club.getWelFare'));
			_btnOK.move(79,224);
			addContent(_btnOK);
		}
		private function initEvent():void
		{
			_btnOK.addEventListener(MouseEvent.CLICK,btnOKClickHandler);
		}
		
		protected function btnOKClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		
		private function removeEvent():void
		{
			_btnOK.removeEventListener(MouseEvent.CLICK,btnOKClickHandler);
		}
		
		public static function getInstance():PetPVPSuccessPanel
		{
			if(!instance)
			{
				instance = new PetPVPSuccessPanel();
			}
			return instance;
		}
		
		public function show(copper:int,exp:int,itemTemplateId:int):void
		{
			_copperLabel.setValue(LanguageManager.getWord("ssztl.common.copper")+" "+copper.toString());
			_expLabel.setValue(LanguageManager.getWord("ssztl.swordsMan.expValue")+" "+exp.toString());
			_cell.info = ItemTemplateList.getTemplate(itemTemplateId);
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			instance = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_titleLabel = null;
			_copperLabel = null;
			_expLabel = null;
			if(_cell)
			{
				_cell.dispose();
				_cell =null;
			}
			if(_btnOK)
			{
				_btnOK.dispose();
				_btnOK =null;
			}
		}
	}
}