package sszt.scene.components.pvpFirst
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.pvpFirst.item.GoodsCell;
	import sszt.scene.components.resourceWar.ResourceWarRewardCell;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.scene.DotaTitleResultAsset;
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class PvpFirstResultPanel extends MPanel
	{
		private static var _instance:PvpFirstResultPanel;
		private var _bg:IMovieWrapper;
		private const CONTENT_WIDTH:int = 235;
		private const CONTENT_HEIGHT:int = 279;
		private var _btnConfirm:MCacheAssetBtn1;
//		private var _awardCell3:ResourceWarRewardCell;
		private var _awardCell1:GoodsCell;
		private var _awardCell2:GoodsCell;
		private var _txtInfo1:MAssetLabel;
		
		public function PvpFirstResultPanel()
		{
			super(new Bitmap(new DotaTitleResultAsset()),true,-1,true,true);
		}
		
		public static function getInstance():PvpFirstResultPanel
		{
			if (_instance == null){
				_instance = new PvpFirstResultPanel();
			};
			return (_instance);
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10,4,215,210)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,213,215,25),new Bitmap(new SplitCompartLine2())),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(64,82,50,50),new Bitmap(new CellBigBgAsset())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(118,82,50,50),new Bitmap(new CellBigBgAsset())),
			]);
			addContent(_bg as DisplayObject);
			
			_txtInfo1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtInfo1.textColor = 0x71e149;
			_txtInfo1.move(117,35);
			addContent(_txtInfo1);
			_txtInfo1.setHtmlValue(LanguageManager.getWord("ssztl.pvp.firstResult"));
			
			_btnConfirm = new MCacheAssetBtn1(0, 3,LanguageManager.getWord('ssztl.common.sure'));
			_btnConfirm.move(80,224);
			addContent(_btnConfirm);
			
			_btnConfirm.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		protected function btnClickHandler(event:MouseEvent):void
		{
			dispose();
		}
		public function show(id1:int, id2:int):void
		{
			var itemTemplateInfo:ItemTemplateInfo;
			
			if(id1 > 0)
			{
				_awardCell1 = new GoodsCell();
				_awardCell1.info = ItemTemplateList.getTemplate(id1);
				_awardCell1.move(64,125);
				addContent(_awardCell1);
			}
			if(id2 > 0)
			{
				_awardCell2 = new GoodsCell();
				_awardCell2.info = ItemTemplateList.getTemplate(id2);
				_awardCell2.move(118,125);
				addContent(_awardCell2);
			}
			if(!_awardCell1)
			{
				_awardCell2.move(89,125);
			}
			if(!_awardCell2)
			{
				_awardCell1.move(89,125);
			}
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}else
			{
				dispose();
			}
		}
		override public function dispose():void
		{
			_btnConfirm.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			if(_btnConfirm)
			{
				_btnConfirm.dispose();
				_btnConfirm = null;
			}
			parent.removeChild(this);
			_instance = null;
			super.dispose();
		}
	}
}