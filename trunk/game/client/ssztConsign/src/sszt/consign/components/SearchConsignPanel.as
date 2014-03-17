package sszt.consign.components
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.profiler.showRedrawRegions;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	import sszt.consign.components.itemView.SearchItemView;
	import sszt.consign.components.searchItemTypeView.CAccordion;
	import sszt.consign.components.searchItemTypeView.data.CAccordionGroupData;
	import sszt.consign.components.searchItemTypeView.data.CAccordionItemData;
	import sszt.consign.data.ConsignInfo;
	import sszt.consign.data.Item.SearchItemInfo;
	import sszt.consign.data.PriceType;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.consign.socketHandlers.ConsignBuyHandler;
	import sszt.consign.socketHandlers.ConsignQueryHandler;
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToConsignData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.consign.ConsignTitleAsset;
	
	public class SearchConsignPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _evenRowBg:Shape;
		private var _consignMediator:ConsignMediator;
		private var _comboxQuality:ComboBox;
		private var _comboxCareer:ComboBox;
		private var _resetBtn:MCacheAssetBtn1;
		private var _searchBtn:MCacheAssetBtn1;
		private var _jumpPageBtn:MCacheAssetBtn1;
		private var _consignBtn:MCacheAssetBtn1;
		private var _myCongsignBtn:MCacheAssetBtn1;
		
		private var _searchTextField:TextField;
		private var _levelTextField1:TextField;
		private var _levelTextField2:TextField;
		
		private var _jumpPageTextField:TextField;
		
		private var _yuanBaoLabel:MAssetLabel;
		private var _tongBiLabel:MAssetLabel;
		
		private var _resultMTile:MTile;
//		private var _resultItemViewList:Vector.<SearchItemView> = new Vector.<SearchItemView>();
		private var _resultItemViewList:Array = [];
		private var _currentItemSelectView:SearchItemView = null;
		
//		private var _sortSprites:Vector.<Sprite> = new Vector.<Sprite>();
//		private var _sortSelectTabs:Vector.<Boolean>;
		private var _sortSprites:Array = [];
		private var _sortSelectTabs:Array;
		
		private var _groupData:Array;
		private var _maccordion:CAccordion;
		
		private var _pageView:PageView;
//		private var _categoryIdVector:Vector.<int> = CategoryType.ALL_TYPES;
		private var _categoryIdVector:Array = CategoryType.ALL_TYPES;
		
		private var _tf:TextFormat = new TextFormat("Simsun",12,0xffffff);
		private var _tf2:TextFormat = new TextFormat("Simsun",12,0xffffff,null,null,null,null,null,"center");
		
		public function SearchConsignPanel(consignMediator:ConsignMediator)
		{
			_consignMediator = consignMediator;
			super(new MCacheTitle1("",new Bitmap(new ConsignTitleAsset())),true,-1,true,true);
			move(18,24);
			initialEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(628,377);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,612,367)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,121,328)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(135,6,481,328)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(138,9,475,33)),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(142,15,105,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(281,15,30,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(320,15,30,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(370,304,41,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(52,339,100,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(199,339,100,22)),
				
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(138,44,475,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(299,45,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(363,45,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(432,45,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,66,475,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,112,475,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,158,475,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,204,475,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,250,475,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,296,475,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(56,341,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(203,341,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
				
				// 标签文字:
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(249,20,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(310,20,64,17),new MAssetLabel("-",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(211,47,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.item"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,47,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(385,47,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(453,47,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.price"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(18,343,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao2") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(165,343,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.copper2") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(412,307,16,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.page"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			_evenRowBg = new Shape();	
			_evenRowBg.graphics.beginFill(0x172527,1);
			_evenRowBg.graphics.drawRect(138,114,470,44);
			_evenRowBg.graphics.drawRect(138,206,470,44);
			addContent(_evenRowBg);
			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(436,296,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.jumpBtn"),MAssetLabel.LABELTYPE1)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(517,296,16,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.page"),MAssetLabel.LABELTYPE1)));
			
			_pageView = new PageView(ConsignInfo.PAGE_SIZE,false,100);
			_pageView.move(261,303);
			addContent(_pageView);
			
			_resultMTile = new MTile(475,46,1);
			_resultMTile.itemGapH = 0;
			_resultMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_resultMTile.verticalScrollPolicy = ScrollPolicy.OFF;
//			_resultMTile.verticalScrollBar.lineScrollSize = 44;
			_resultMTile.setSize(475,230);
			_resultMTile.move(141,67);
			addContent(_resultMTile);
			
			_searchTextField = new TextField();
			_searchTextField.defaultTextFormat = _tf;
			_searchTextField.type = "input";
			_searchTextField.text = LanguageManager.getWord("ssztl.consign.inputKeyWord");
			_searchTextField.maxChars = 20;
			_searchTextField.textColor = 0x5b8c8b;
			_searchTextField.x = 146;
			_searchTextField.y = 18;
			_searchTextField.width = 98;
			_searchTextField.height = 20;
			addContent(_searchTextField);
			
			_levelTextField1 = new TextField();
			_levelTextField1.defaultTextFormat = _tf2;
			_levelTextField1.restrict = "0123456789";
			_levelTextField1.maxChars = 2;
			_levelTextField1.type = "input";
			_levelTextField1.text = "0";
			_levelTextField1.x = 284;
			_levelTextField1.y = 18;
			_levelTextField1.width = 24;
			_levelTextField1.height = 17;
			addContent(_levelTextField1);
			
			_levelTextField2 = new TextField();
			_levelTextField2.defaultTextFormat = _tf2;
			_levelTextField2.maxChars = 2;
			_levelTextField2.text = "99";
			_levelTextField2.restrict = "0123456789";
			_levelTextField2.type = "input";
			_levelTextField2.x = 323;
			_levelTextField2.y = 18;
			_levelTextField2.width = 24;
			_levelTextField2.height = 17;
			addContent(_levelTextField2);
			
			_jumpPageTextField = new TextField();
			_jumpPageTextField.defaultTextFormat = _tf2;
			_jumpPageTextField.maxChars = 3;
			_jumpPageTextField.text = "";
			_jumpPageTextField.restrict = "0123456789";
			_jumpPageTextField.type = "input";
			_jumpPageTextField.x = 375;
			_jumpPageTextField.y = 307;
			_jumpPageTextField.width = 35;
			_jumpPageTextField.height = 17;
//			_jumpPageTextField.autoSize = TextFieldAutoSize.CENTER;
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_jumpPageTextField.defaultTextFormat = t;
			addContent(_jumpPageTextField);
			
			_yuanBaoLabel = new MAssetLabel(GlobalData.selfPlayer.userMoney.yuanBao.toString(),MAssetLabel.LABEL_TYPE20);
			_yuanBaoLabel.move(75,342);
			addContent(_yuanBaoLabel);
			
			_tongBiLabel = new MAssetLabel(GlobalData.selfPlayer.userMoney.copper.toString(),MAssetLabel.LABEL_TYPE20);
			_tongBiLabel.move(220,342);
			addContent(_tongBiLabel);
			
			_comboxQuality = new ComboBox();
//			_comboxQuality.setStyle("buttonWidth",20);
			_comboxQuality.open();
			_comboxQuality.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_comboxQuality.x = 355;
			_comboxQuality.y = 15;
			_comboxQuality.width = 78;
			_comboxQuality.height = 22;
			_comboxQuality.rowCount = 6;
			addContent(_comboxQuality);
			_comboxQuality.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.common.allQulity"),value:99},
				{label:LanguageManager.getWord("ssztl.common.whiteQulity2"),value:0},
				{label:LanguageManager.getWord("ssztl.common.greenQulity2"),value:1},
				{label:LanguageManager.getWord("ssztl.common.blueQulity2"),value:2},
				{label:LanguageManager.getWord("ssztl.common.purpleQulity2"),value:3},
				{label:LanguageManager.getWord("ssztl.common.orangeQulity2"),value:4}]);
			_comboxQuality.selectedIndex = 0;
			
			_comboxCareer = new ComboBox();
			_comboxCareer.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_comboxCareer.x = 438;
			_comboxCareer.y = 15;
			_comboxCareer.width = 78;
			_comboxCareer.height = 22;
			addContent(_comboxCareer);
			_comboxCareer.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.common.allCarrer"),value:0},
				{label:LanguageManager.getWord("ssztl.common.shangWu"),value:1},
				{label:LanguageManager.getWord("ssztl.common.xiaoYao"),value:2},
				{label:LanguageManager.getWord("ssztl.common.liuXing"),value:3}]);
			_comboxCareer.selectedIndex = 0;
			
			_searchBtn = new MCacheAssetBtn1(0,0,LanguageManager.getWord("ssztl.common.searchBtn"));
			_searchBtn.move(519,13);
			addContent(_searchBtn);
			
			_resetBtn = new MCacheAssetBtn1(0,0,LanguageManager.getWord("ssztl.common.resetBtn"));
			_resetBtn.move(565,13);
			addContent(_resetBtn);
			
			_jumpPageBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.jumpBtn"));
			_jumpPageBtn.move(429,303);
			addContent(_jumpPageBtn);
			
			_consignBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.itemConsign"));
			_consignBtn.move(468,337);
			addContent(_consignBtn);
			
			_myCongsignBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.myConsign"));
			_myCongsignBtn.move(543,337);
			addContent(_myCongsignBtn);
			
//			var _points:Vector.<Point> = Vector.<Point>([new Point(198,10),new Point(354,10),new Point(391,10),new Point(429,10)]);
//			var _rectangles:Vector.<Rectangle> = Vector.<Rectangle>([new Rectangle(198,10,147,17),new Rectangle(354,10,36,17),new Rectangle(391,10,30,17),new Rectangle(429,10,146,17)]);
//			_sortSelectTabs = new Vector.<Boolean>(_points.length);
			
//			var _points:Array = [new Point(198,10),new Point(354,10),new Point(391,10),new Point(429,10)];
			var _rectangles:Array = [new Rectangle(211,48,28,17),new Rectangle(320,48,28,17),new Rectangle(385,48,28,17),new Rectangle(453,48,28,17)];
			_sortSelectTabs = new Array(_rectangles.length);
			
			for(var i:int = 0;i < _rectangles.length;i++)
			{
				var tmpSortSprite:Sprite = new Sprite();
				tmpSortSprite.buttonMode = true;
				tmpSortSprite.x = _rectangles[i].x;
				tmpSortSprite.y = _rectangles[i].y;
				tmpSortSprite.graphics.beginFill(0,0);
				tmpSortSprite.graphics.drawRect(0,0,_rectangles[i].width,_rectangles[i].height);
				tmpSortSprite.graphics.endFill();
				tmpSortSprite.addEventListener(MouseEvent.CLICK,sortHandler);
				_sortSprites.push(tmpSortSprite);
				addContent(tmpSortSprite);
			}
			
//			var weaponList:Array = [];
//			weaponList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.knife"),[CategoryType.KNIFE]));
//			weaponList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.swod"),[CategoryType.SWORD]));
//			weaponList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.rod"),[CategoryType.ROD]));
//			weaponList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.fan"),[CategoryType.FAN]));
//			weaponList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.bow"),[CategoryType.BOW]));
//			weaponList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.crossBow"),[CategoryType.CROSSBOW]));
//			
//			var equipList:Array = [];
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.neckLace"),[CategoryType.NECKLACE_SHANGWU,CategoryType.NECKLACE_XIAOYAO,CategoryType.NECKLACE_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.armet"),[CategoryType.ARMET_SHANGWU,CategoryType.ARMET_XIAOYAO,CategoryType.ARMET_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.wine"),[CategoryType.WING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.cloth"),[CategoryType.CLOTH_SHANGWU,CategoryType.CLOTH_XIAOYAO,CategoryType.CLOTH_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.caestus"),[CategoryType.CAESTUS_SHANGWU,CategoryType.CAESTUS_XIAOYAO,CategoryType.CAESTUS_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.cuff"),[CategoryType.CUFF_SHANGWU,CategoryType.CUFF_XIAOYAO,CategoryType.CUFF_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.ring"),[CategoryType.RING_SHANGWU,CategoryType.RING_XIAOYAO,CategoryType.RING_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.shoe"),[CategoryType.SHOE_SHANGWU,CategoryType.SHOE_XIAOYAO,CategoryType.SHOE_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.munts"),[CategoryType.MUNTS]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.bangle"),[CategoryType.BANGLE_SHANGWU,CategoryType.BANGLE_XIAOYAO,CategoryType.BANGLE_LIUXING]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.peiShi"),[CategoryType.FUSHOU]));
//			equipList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.trump"),[CategoryType.TRUMP_SHANGWU,CategoryType.TRUMP_XIAOYAO,CategoryType.TRUMP_LIUXING]));
//
//			var drugList:Array = [];
//			drugList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.redinstant"),[CategoryType.REDINSTANT]));
			
			
			/**
			 * 需要修改对应的值
			 */

			var moneyList:Array =  [];
			moneyList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.yuanBao2"),[CategoryType.YUANBAO]));
			moneyList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.copper2"),[CategoryType.TONGBI]));
			
			// 坐骑
			var mountsList:Array = [];
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mountsGrow"),CategoryType.MOUNTS_GROW));
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mountsQualification"),CategoryType.MOUNTS_QUALIFICATION));
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mountsAdvanced"),[CategoryType.MOUNTS_ADVANCED_DRUG]));
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mountsSkillBook"),CategoryType.MOUNTS_SKILL_BOOK));
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mountsEgg"),[CategoryType.MUNTS]));
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mountsExpDrug"),[CategoryType.MOUNTS_EXP_DRUG]));
			mountsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.piece"),[CategoryType.STRENGTHNEWPROTECTSYMBOL,CategoryType.MOUNTS_SKILL_BOOK_INCOMPLETE_PAGES]));
			
			var petList:Array = [];
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.petGrow"),[CategoryType.PET_LUCK_SYMBOL]));
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.petQualification"),[CategoryType.PET_PROTECTED_SYMBOL]));
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.petAdvanced"),[CategoryType.PET_ADVANCED_DRUG]));
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.petSkillBook"),CategoryType.PET_SKILL));
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.petEgg"),[CategoryType.PET_EGG]));
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.petFood"),[CategoryType.PET_FOOD_CATEGORY]));
			petList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.piece"),CategoryType.PET_OTHER));
			
			var gemList:Array = [];
			gemList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.rebuild2"),[CategoryType.REBUILD]));
			gemList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.strength"),[CategoryType.STRENGTH]));
			gemList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.mosaic2"),CategoryType.MOSAIC));
			gemList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.piece2"),[CategoryType.STILETTO]));
			
			var bagList:Array = [];
			bagList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.upgradeSymbol"),CategoryType.UPGRADE_SYMBOLS));
			bagList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.stonePickSymbol"),[CategoryType.STONEPICKSYMBOL]));
			
			var materialsList:Array = [];
			materialsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.upgradEquip"),CategoryType.UPGRADE_UPEQUIP));
			materialsList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.upgradePiece"),[CategoryType.STUFF]));
			
			var lingPaiList:Array = [];
			lingPaiList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.yaBiaoLing"),[CategoryType.TRANSPORT_BRAND_TYPE]));
			lingPaiList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.jianHuLing"),[CategoryType.SHENMOLINE]));
			lingPaiList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.linglongStone"),[CategoryType.LINGLONGSTONE]));
			lingPaiList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.clubLing"),[CategoryType.WARSYMBOLE,CategoryType.WARAVOIDSYMBOLE,CategoryType.JIANBANGLING ]));
			lingPaiList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.otherLing"),[CategoryType.REDUCE_PK_VALUE]));
			
			var otherList:Array = [];
			otherList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.drug"),CategoryType.DRUG_TYPES2));
			otherList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.attrAddItem"),[CategoryType.BUFF]));
			otherList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.sundries"),CategoryType.SUNDRIES));
			otherList.push(new CAccordionItemData(LanguageManager.getWord("ssztl.common.convenientItem"),CategoryType.CONVENIENT));
			
			_groupData = [
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.money"),moneyList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.munts"),mountsList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.pet"),petList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.stone"),gemList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.symbol"),bagList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.material"),materialsList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.ling"),lingPaiList),
				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.other"),otherList)];
				
				
//				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.weaponList"),weaponList),
//				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.equip2"),equipList),
//				new CAccordionGroupData(LanguageManager.getWord("ssztl.common.drug"),drugList),
				
			_maccordion = new CAccordion(_groupData,_consignMediator,116,5,false);
			_maccordion.horizontalScrollPolicy = "off";
			_maccordion.verticalScrollPolicy = "auto";
			_maccordion.setSize(110,318);
			_maccordion.move(18,12);
			addContent(_maccordion);
			
			_categoryIdVector = CategoryType.ALL_TYPES;
			selectItemChange(_categoryIdVector);
		}
		
		public function assetsCompleteHandler():void
		{
			//_bg1.bitmapData = AssetUtil.getAsset("ssztui.consign.BgAsset1",BitmapData) as BitmapData;
		}
		
		private function searchFocusInHandler(e:FocusEvent):void
		{
			if(_searchTextField.text == LanguageManager.getWord("ssztl.consign.inputKeyWord"))
			{
				_searchTextField.textColor = 0xFFFFFF;
				_searchTextField.text = "";
			}
		}
		
		private function searchFocusOutHandler(e:FocusEvent):void
		{
			if(_searchTextField.text == "")
			{
				_searchTextField.textColor = 0x5b8c8b;
				_searchTextField.text = LanguageManager.getWord("ssztl.consign.inputKeyWord");
			}
		}
		
		private function level1FocusHandler(e:FocusEvent):void
		{
			if(_levelTextField1.text == "")_levelTextField1.text = "0";
			else if(Number(_levelTextField1.text) > Number(_levelTextField2.text))
			{
				_levelTextField1.text = "0";
			}
		}
		
		private function level2FocusOutHandler(e:FocusEvent):void
		{
			if(_levelTextField2.text == "")_levelTextField2.text = "99";
		}
		
		//重置
		private function resetBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_searchTextField.text = LanguageManager.getWord("ssztl.consign.inputKeyWord");
			_levelTextField1.text = "0";
			_levelTextField2.text = "99";
			_comboxQuality.selectedIndex = 0;
			_comboxCareer.selectedIndex = 0;
		}
		
		//物品类型更改时调用
//		public function selectItemChange(categoryIdVector:Vector.<int>):void
		public function selectItemChange(categoryIdVector:Array):void
		{
			_categoryIdVector = categoryIdVector;
			_pageView.currentPage = 1;
			search(_categoryIdVector);
		}
		
		//执行查询
//		private function search(categoryIdVector : Vector.<int>):void
		private function search(categoryIdVector : Array):void
		{
			var _tmpKeyWord:String = "";
			if(_searchTextField.text != LanguageManager.getWord("ssztl.consign.inputKeyWord"))
			{
				_tmpKeyWord = _searchTextField.text;   
			}
			
			var type:int = 1;
			if(categoryIdVector && categoryIdVector.length>0)
			{
				if(categoryIdVector[0] == CategoryType.TONGBI)
				{
					type = 2;
				}
				else if(categoryIdVector[0] == CategoryType.YUANBAO)
				{
					type = 3;
				}
				else if(categoryIdVector == CategoryType.ALL_TYPES)
				{
					type = 0;
				}
			}
			
			
			_consignMediator.sendSearchQuery(type,
				Number(_comboxCareer.selectedItem.value),
				Number(_comboxQuality.selectedItem.value),
				Number(_levelTextField1.text),
				Number(_levelTextField2.text),
				categoryIdVector,
				_tmpKeyWord,
				_pageView.currentPage);
		}
		
		//点击搜索按钮时调用
		private function searchBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_pageView.currentPage = 1;
			var _tmpKeyWord:String = "";
			if(_searchTextField.text != LanguageManager.getWord("ssztl.consign.inputKeyWord"))
			{
				_tmpKeyWord = _searchTextField.text;   
			}
			
			if(_maccordion.currentGroup && _maccordion.currentGroup.currentItem && _maccordion.currentGroup.currentItem.selected)
			{
				_categoryIdVector =  _maccordion.currentGroup.currentItem.info.itemCategoryIdVector;
			}
			else
			{
//				_categoryIdVector = new Vector.<int>();
				_categoryIdVector = [];
			}
			search(_categoryIdVector);
			
		}
		
		
		private function sortHandler(e:MouseEvent):void
		{
			var index:int = _sortSprites.indexOf(e.currentTarget as Sprite);
			setIndex(index);
		}
		
		private function setIndex(argIndex:int):void
		{
			switch(argIndex)
			{
				case 0:
						if(_sortSelectTabs[0])
						{
							_resultMTile.sortOn(["itemName"],[Array.CASEINSENSITIVE]);
							_sortSelectTabs[0] = false;
						}
						else
						{
							_resultMTile.sortOn(["itemName"],[Array.CASEINSENSITIVE | Array.DESCENDING]);
							_sortSelectTabs[0] = true;
						}
					break;
				case 1:
					if(_sortSelectTabs[1])
					{
						_resultMTile.sortOn(["itemLevel"],[Array.NUMERIC]);
						_sortSelectTabs[1] = false;
					}
					else
					{
						_resultMTile.sortOn(["itemLevel"],[Array.NUMERIC | Array.DESCENDING]);
						_sortSelectTabs[1] = true;
					}
					break;
				case 2:
					if(_sortSelectTabs[2])
					{
						_resultMTile.sortOn(["needCareer"],[Array.NUMERIC]);
						_sortSelectTabs[2] = false;
					}
					else
					{
						_resultMTile.sortOn(["needCareer"],[Array.NUMERIC | Array.DESCENDING]);
						_sortSelectTabs[2] = true;
					}
					break;
				case 3:
					if(_sortSelectTabs[3])
					{
						_resultMTile.sortOn(["itemAllPrice"],[Array.NUMERIC]);
						_sortSelectTabs[3] = false;
					}
					else
					{
						_resultMTile.sortOn(["itemAllPrice"],[Array.NUMERIC | Array.DESCENDING]);
						_sortSelectTabs[3] = true;
					}
					break;
				default :
					break;
			}
		}
		
		//选中物品
		private function itemViewSelectHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentItemSelectView == null)
			{
				_currentItemSelectView = e.currentTarget as SearchItemView;
				_currentItemSelectView.select = true;
			}
			else
			{
				_currentItemSelectView.select = false;
				_currentItemSelectView = e.currentTarget as SearchItemView;
				_currentItemSelectView.select = true;
			}
			if(e.target is MCacheAssetBtn1)
			{
				buyItem();
			}
		}
		
		
		//购买物品
		private function buyItem():void
		{
			var priceType:String;
			switch(_currentItemSelectView.seachInfo.priceType)
			{
				case PriceType.COPPER: 
					priceType = LanguageManager.getWord("ssztl.common.copper2");
					if(GlobalData.selfPlayer.userMoney.copper < _currentItemSelectView.seachInfo.consignPrice)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.copperBuyFail"));
						return;
					}
					break;

				case PriceType.YUANBAO:
					priceType = LanguageManager.getWord("ssztl.common.yuanBao2");
					if(GlobalData.selfPlayer.userMoney.yuanBao < _currentItemSelectView.seachInfo.consignPrice)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoBuyFail"));
						return;
					}
					break;
			}
			
			MAlert.show(LanguageManager.getWord("ssztl.common.sureBuyItem",_currentItemSelectView.nameTextField.text,_currentItemSelectView.seachInfo.consignPrice,priceType),
				LanguageManager.getAlertTitle(),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			
		}
		
		private function closeHandler(evt:CloseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentItemSelectView)
			{
				if(evt.detail == MAlert.OK)
				{
					_consignMediator.sendBuyConsign(_currentItemSelectView.seachInfo.listId);
				}
			}
		}
		
		//更新搜索
		private function searchListUpdate(e:ConsignEvent):void
		{
			var listId:Number = e.data as Number;
			var tmpSearchItemInfo:SearchItemInfo = consignInfo.getSearchItemInfoFromSearchList(listId);
			/**删除**/
			if(!tmpSearchItemInfo)
			{
//				_yuanBaoLabel.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
//				_tongBiLabel.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
				for each(var i:SearchItemView in _resultItemViewList)
				{
					if(i.seachInfo.listId == listId)
					{
						_currentItemSelectView = null;
						_resultItemViewList.splice(_resultItemViewList.indexOf(i),1);
						i.removeEventListener(MouseEvent.CLICK, itemViewSelectHandler);
						_resultMTile.removeItem(i);
						i.dispose();
						i = null;
						break;
					}
				}
			}/**插入**/
			else
			{
				var tmpItemView:SearchItemView = new SearchItemView();
				tmpItemView.addEventListener(MouseEvent.CLICK,itemViewSelectHandler);
				tmpItemView.seachInfo = tmpSearchItemInfo;
				_resultItemViewList.push(tmpItemView);
				_resultMTile.appendItem(tmpItemView);
			}
		}
		
		//事件初始化
		public function initialEvents():void
		{
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			consignInfo.addEventListener(ConsignEvent.SEARCHLIST_UPDATE,searchListUpdate);
			_searchTextField.addEventListener(FocusEvent.FOCUS_IN,searchFocusInHandler);
			_searchTextField.addEventListener(FocusEvent.FOCUS_OUT,searchFocusOutHandler);
			_levelTextField1.addEventListener(FocusEvent.FOCUS_OUT,level1FocusHandler);
			_levelTextField2.addEventListener(FocusEvent.FOCUS_OUT,level2FocusOutHandler);
			consignInfo.addEventListener(ConsignEvent.PAGE_UPDATE,pageUpdateHandler);
			
			_resetBtn.addEventListener(MouseEvent.CLICK,resetBtnHandler);
			_searchBtn.addEventListener(MouseEvent.CLICK,searchBtnHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
			_consignBtn.addEventListener(MouseEvent.CLICK,consignBtnHandler);
			_myCongsignBtn.addEventListener(MouseEvent.CLICK,myConsignBtnHandler);
			
			_jumpPageBtn.addEventListener(MouseEvent.CLICK, pageJumpHandler);
			
		}
		
		//移除事件监听
		public function removeEvents():void
		{
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			consignInfo.removeEventListener(ConsignEvent.SEARCHLIST_UPDATE,searchListUpdate);
			_searchTextField.removeEventListener(FocusEvent.FOCUS_IN,searchFocusInHandler);
			_searchTextField.removeEventListener(FocusEvent.FOCUS_OUT,searchFocusOutHandler);
			_levelTextField1.removeEventListener(FocusEvent.FOCUS_OUT,level1FocusHandler);
			_levelTextField2.removeEventListener(FocusEvent.FOCUS_OUT,level2FocusOutHandler);
			consignInfo.removeEventListener(ConsignEvent.PAGE_UPDATE,pageUpdateHandler);
			
			_resetBtn.removeEventListener(MouseEvent.CLICK,resetBtnHandler);
			_searchBtn.removeEventListener(MouseEvent.CLICK,searchBtnHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
			_consignBtn.removeEventListener(MouseEvent.CLICK,consignBtnHandler);
			_myCongsignBtn.removeEventListener(MouseEvent.CLICK,myConsignBtnHandler);
			
			_jumpPageBtn.removeEventListener(MouseEvent.CLICK, pageJumpHandler);
			
		}
		
		//更新个人金钱
		private function moneyUpdataHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBaoLabel.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			_tongBiLabel.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
			
//			_yuanBaoLabel.move(50,416);
//			_tongBiLabel.move(238,416);
			
			
		}
		
		//页面跳转
		private function pageJumpHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var pageNum:int = parseInt(_jumpPageTextField.text);
			if(pageNum < 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.inputPageNum"));
				return;
			}
//			if(pageNum > _pageView.)
			_pageView.setPage(parseInt(_jumpPageTextField.text));
//			pageChangeHandler(null);
		}
		
		private function pageUpdateHandler(e:ConsignEvent):void
		{
			_pageView.totalRecord = consignInfo.totalRecords;
			_pageView.setPage(consignInfo.currentPage,false);
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
//			selectItemChange(_categoryIdVector);
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			search(_categoryIdVector);
		}
		
		//快速寄售
		private function consignBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_consignMediator.module.quickPanel && _consignMediator.module.quickPanel.currentIndex == 0)
			{
				_consignMediator.module.quickPanel.dispose();
			}
			else
			{
				_consignMediator.showQuickPanel(0);
				setTimeout(addBag,50);
				function addBag():void
				{
					SetModuleUtils.addBag(GlobalAPI.layerManager.getTopPanelRec());
				}
			}
			
		}
		
		//我的寄售
		private function myConsignBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_consignMediator.module.quickPanel && _consignMediator.module.quickPanel.currentIndex == 2)
			{
				_consignMediator.module.quickPanel.dispose();
			}
			else
			{
				_consignMediator.showQuickPanel(2);
			}
			
		}
		
		
		private function get consignInfo():ConsignInfo
		{
			return _consignMediator.module.consignInfo;
		}
		
		override public function dispose():void
		{
			removeEvents();	
//			if(_consignMediator.module.quickPanel)
//			{
//				_consignMediator.module.quickPanel.dispose();
//			}
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_evenRowBg)
			{
				_evenRowBg = null;
			}
			_comboxCareer = null;
			_comboxQuality = null;
			if(_resetBtn)
			{
				_resetBtn.dispose();
				_resetBtn = null;
			}
			if(_searchBtn)
			{
				_searchBtn.dispose();
				_searchBtn = null;
			}
			_searchTextField = null;
			_levelTextField1 = null;
			_levelTextField2 = null;
			if(_resultMTile)
			{
				_resultMTile.dispose();
				_resultMTile = null;
			}
			
			for each(var i:SearchItemView in _resultItemViewList)
			{
				i.removeEventListener(MouseEvent.CLICK,itemViewSelectHandler);
				i.dispose();
				i = null;
			}
			_resultItemViewList = null;
			
			for each(var j:Sprite in _sortSprites)
			{
				j.removeEventListener(MouseEvent.CLICK,sortHandler);
				j = null;
			}
			_sortSprites = null;
			_sortSelectTabs= null;
			
			if(_maccordion)
			{
				_maccordion.dispose();
				_maccordion = null;
			}
			
			if(_jumpPageBtn)
			{
				_jumpPageBtn.dispose();
				_jumpPageBtn = null;
			}
			if(_consignBtn)
			{
				_consignBtn.dispose();
				_consignBtn = null;
			}
			if(_myCongsignBtn)
			{
				_myCongsignBtn.dispose();
				_myCongsignBtn = null;
			}
			
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_groupData)
			{
				for each(var value:CAccordionGroupData in _groupData)
				{
					value = null;
				}
				_groupData = null;
			}
			_jumpPageTextField = null;
			_yuanBaoLabel = null;
			_tongBiLabel = null;
			_currentItemSelectView = null;
			_categoryIdVector = null;
//			_consignMediator.consignInfo.clearSearchItemList();
			_consignMediator = null;
		}
	}
}