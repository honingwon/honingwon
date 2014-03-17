package sszt.sevenActivity.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.sevenActivity.DetailTagAsset;
	import ssztui.sevenActivity.DetailTitleAsset;
	import ssztui.ui.SplitCompartLine2;

	public class DetailShowPanel extends MPanel
	{
		private static var _instance:DetailShowPanel;
		private var _bg:IMovieWrapper;
		
		private const CONTENT_WIDTH:int = 666;
		private const CONTENT_HEIGHT:int = 385;
		private var _txtDay:MAssetLabel;
		private var _txtName:MAssetLabel;
		private var _txtDetail:MAssetLabel;
		
		public function DetailShowPanel()
		{
			super(new Bitmap(new DetailTitleAsset()),true,-1,true,true);
		}
		
		public static function getInstance():DetailShowPanel
		{
			if (_instance == null){
				_instance = new DetailShowPanel();
			};
			return (_instance);
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			var _table:Sprite = new Sprite();
			_table.graphics.lineStyle(1,0x2b3f41);
			_table.graphics.lineTo(632,0);
			_table.graphics.lineTo(632,288);
			_table.graphics.lineTo(0,288);
			_table.graphics.lineTo(0,0);
			_table.graphics.moveTo(0,41);
			_table.graphics.lineTo(632,41);
			_table.graphics.moveTo(0,82);
			_table.graphics.lineTo(632,82);
			_table.graphics.moveTo(0,123);
			_table.graphics.lineTo(632,123);
			_table.graphics.moveTo(0,164);
			_table.graphics.lineTo(632,164);
			_table.graphics.moveTo(0,205);
			_table.graphics.lineTo(632,205);
			_table.graphics.moveTo(0,246);
			_table.graphics.lineTo(632,246);
			_table.graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,650,375)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,642,366)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,10,642,37),new SelectedBorder()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(40,20,397,17),new Bitmap(new DetailTagAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,48,632,288),_table),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,320,346,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,346,642,17),new MAssetLabel(LanguageManager.getWord("ssztl.activity.sevenDetail"),MAssetLabel.LABEL_TYPE7)),
			]);
			addContent(_bg as DisplayObject);
			
			_txtDay = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtDay.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,29)]);
			_txtDay.move(74,60);
			addContent(_txtDay);
			
			_txtName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtName.setLabelType([new TextFormat("SimSun",12,0xffcc00,true,null,null,null,null,null,null,null,null,29)]);
			_txtName.move(167,60);
			addContent(_txtName);
			
			_txtDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDetail.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,29)]);
			_txtDetail.move(237,60);
			addContent(_txtDetail);
			
			for(var i:int=0; i<7; i++)
			{
				_txtDay.text += LanguageManager.getWord("ssztl.activity.sevenDay"+(i+1)) + "\n";
				_txtName.text += LanguageManager.getWord("ssztl.activity.sevenName"+(i+1)) +"\n";
				if(GlobalData.functionYellowEnabled)
					_txtDetail.text += LanguageManager.getWord("ssztl.activity.sevenDetail"+(i+1)) +"\n";
				else
					_txtDetail.text += LanguageManager.getWord("ssztl.activity.sevenDetail2"+(i+1)) +"\n";
			}
		}
		public function show():void
		{
			if(!parent)
				GlobalAPI.layerManager.addPanel(this);
			else
				dispose();
		}
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_txtDay = null;
			_txtName = null;
			_txtDetail = null;
			_instance = null;
			super.dispose();
		}
	}
}