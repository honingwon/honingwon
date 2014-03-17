package sszt.rank.components
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.rank.components.treeView.TreePanel;
	import sszt.rank.components.treeView.data.TreeGroupData;
	import sszt.rank.components.treeView.data.TreeItemData;
	import sszt.rank.components.treeView.event.TreeItemEvent;
	import sszt.rank.components.views.IRankView;
	import sszt.rank.components.views.activity.PVPRankView;
	import sszt.rank.components.views.club.ClubRank1View;
	import sszt.rank.components.views.copy.MultiClimbingTowerRankView;
	import sszt.rank.components.views.copy.MultiDefenceRankView;
	import sszt.rank.components.views.copy.SingleClimbingTowerRankView;
	import sszt.rank.components.views.copy.SingleDefenceRankView;
	import sszt.rank.components.views.equip.EquipRankView;
	import sszt.rank.components.views.individual.AchieveRankView;
	import sszt.rank.components.views.individual.GenguRankView;
	import sszt.rank.components.views.individual.LevelRankView;
	import sszt.rank.components.views.individual.MoneyRankView;
	import sszt.rank.components.views.individual.RankRoleView;
	import sszt.rank.components.views.individual.StrikeRankView;
	import sszt.rank.components.views.individual.VeinsRankView;
	import sszt.rank.components.views.mount.MountFightRankView;
	import sszt.rank.components.views.mount.MountGrowRankView;
	import sszt.rank.components.views.mount.MountQualityRankView;
	import sszt.rank.components.views.mount.MountStairRankView;
	import sszt.rank.components.views.mount.RankMountView;
	import sszt.rank.components.views.pet.PetFightRankView;
	import sszt.rank.components.views.pet.PetGrowRankView;
	import sszt.rank.components.views.pet.PetQualityRankView;
	import sszt.rank.components.views.pet.PetStairRankView;
	import sszt.rank.components.views.pet.RankPetView;
	import sszt.rank.data.RankInfo;
	import sszt.rank.data.RankType;
	import sszt.rank.data.item.IndividualRankItem;
	import sszt.rank.data.item.OtherRankItem;
	import sszt.rank.events.RankEvent;
	import sszt.rank.mediator.RankMediator;
	import sszt.rank.socketHandlers.DuplicateRankSocketHanders;
	import sszt.rank.socketHandlers.RankSocketHanders;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.rank.RankTitleAsset;
	
	public class RankPanel extends MPanel
	{
		private var _rankMediator:RankMediator;
		private var _bg:IMovieWrapper;
		private var _rankViewClasses:Dictionary;
		private var _rankViews:Dictionary = new Dictionary();
		
//		private var _curView:IRankView;
		
		private var _myRankBtn:MCacheAssetBtn1;
		private var _jumpPageField:TextField;
		private var _jumpBtn:MCacheAssetBtn1;
		private var _pageView:PageView;
		private var _groupData:Array;
		private var _maccordion:TreePanel;
		private var _rankInfos:RankInfo;
		private var _curRankType:int;
		private var _careerFields:Array;
		private var _curCareerField:RankField;
		private var _sexFields:Array;
		private var _curSexField:RankField;
		private var _rankRoleView:RankRoleView;
		private var _petView:RankPetView;
		private var _mountView:RankMountView;
		private var _termsVessel:Sprite;
		
		private var _currentPage:int;
		
		private var _comboxCareer:ComboBox;
		
		public function RankPanel(rankMediator:RankMediator, rankInfos:RankInfo)
		{
			_rankMediator = rankMediator;
			_rankInfos = rankInfos;
			super(new MCacheTitle1("",new Bitmap(new RankTitleAsset)), true, -1, true, false);
			move(CommonConfig.GAME_WIDTH/2-400,CommonConfig.GAME_HEIGHT/2-216);
			initEvents();
			
			if(_maccordion.groupViews && _maccordion.groupViews.length>0)
			{
				_maccordion.currentGroup = _maccordion.groupViews[0];
			}
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(627,391);
			
			var evenRowBg:Shape = new Shape();	
			evenRowBg.graphics.beginFill(0x172527,1);
			evenRowBg.graphics.drawRect(0,0,473,26);
			evenRowBg.graphics.drawRect(0,56,473,26);
			evenRowBg.graphics.drawRect(0,112,473,26);
			evenRowBg.graphics.drawRect(0,168,473,26);
			evenRowBg.graphics.drawRect(0,224,473,26);
			evenRowBg.graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 4, 611, 379)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 9, 120, 369)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(135, 9, 479, 337)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(135,345,479,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(370, 319, 41, 22)),
				new BackgroundInfo(BackgroundType.BAR_1, new Rectangle(137, 11, 475, 22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(138, 63, 473, 250),evenRowBg),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,61,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,89,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,117,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,145,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,173,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,201,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,229,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,257,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,285,473,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(138,313,473,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(435,355,100,18),new MAssetLabel(LanguageManager.getWord("ssztl.rank.RanRefreshTimeTip"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_myRankBtn = new MCacheAssetBtn1(0, 4, LanguageManager.getWord("ssztl.rank.myRank"));
			_myRankBtn.move(139, 350);
//			addContent(_myRankBtn);
			
			_jumpPageField = new TextField();
			_jumpPageField.type = TextFieldType.INPUT;
			_jumpPageField.maxChars = 2;
			_jumpPageField.text = "";
			_jumpPageField.restrict = "0123456789";
			_jumpPageField.x = 370;
			_jumpPageField.y = 323;
			_jumpPageField.width = 41;
			_jumpPageField.height = 19;
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.CENTER);
			_jumpPageField.defaultTextFormat = t;
			addContent(_jumpPageField);
			
			_jumpBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.jumpBtn"));
			_jumpBtn.move(436, 317);
			addContent(_jumpBtn);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(415,322,16,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.page"),MAssetLabel.LABEL_TYPE20)));
			
			_pageView = new PageView(RankInfo.PAGE_SIZE,false, 100);
			_pageView.move(262, 319);
			addContent(_pageView);
			
			_comboxCareer = new ComboBox();
			_comboxCareer.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_comboxCareer.x = 180;
			_comboxCareer.y = 320;
			_comboxCareer.width = 78;
			_comboxCareer.height = 22;
			addContent(_comboxCareer);
			_comboxCareer.dataProvider = new DataProvider([
				{label:LanguageManager.getWord("ssztl.common.allCarrer"),value:0},
				{label:LanguageManager.getWord("ssztl.common.shangWu"),value:1},
				{label:LanguageManager.getWord("ssztl.common.liuXing"),value:2},
				{label:LanguageManager.getWord("ssztl.common.xiaoYao"),value:3}]);
			_comboxCareer.selectedIndex = 0;
			
			var individualRank:Array = [];
			individualRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.levelRank"),RankType.TOP_TYPE_LEVEL));
			individualRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.venisRank"),RankType.TOP_TYPE_VEINS));
			individualRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.genguRank"),RankType.TOP_TYPE_GENGU));
			individualRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.strikeRank"),RankType.TOP_TYPE_FIGHT));
			individualRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.copperRank"),RankType.TOP_TYPE_COPPER));
			individualRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.achieveRank"),RankType.TOP_TYPE_ACHIEVE));
			
			
//			var clubRank:Array = [];
//			clubRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.levelRank"),RankType.CLUB_LEVEL));
			
			var copyRank:Array = [];
			copyRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.copyName1"),RankType.COPY_TYPE1));
			copyRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.copyName2"),RankType.COPY_TYPE2));
			copyRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.copyName3"),RankType.COPY_TYPE3));
			copyRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.copyName4"),RankType.COPY_TYPE4));
			
			var equipRank:Array = [];
			equipRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.equip1"),RankType.EQUIP1));
			equipRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.equip2"),RankType.EQUIP2));
			equipRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.equip3"),RankType.EQUIP3));
//			equipRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.equip4"),RankType.EQUIP4));
//			equipRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.equip5"),RankType.EQUIP5));
			
			var mountRank:Array = [];
			mountRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.mount1"),RankType.MOUNT1));
			mountRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.mount2"),RankType.MOUNT2));
			mountRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.mount3"),RankType.MOUNT3));
			mountRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.mount4"),RankType.MOUNT4));
			
			var petRank:Array = [];
			petRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.pet1"),RankType.PET1));
			petRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.pet2"),RankType.PET2));
			petRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.pet3"),RankType.PET3));
			petRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.pet4"),RankType.PET4));
			
			var clubRank:Array = [];
			clubRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.club1"),RankType.CLUB1));
			
//			var activityRank:Array = [];
//			activityRank.push(new TreeItemData(LanguageManager.getWord("ssztl.rank.pvp"),RankType.PVP));
			
			
			_groupData = [
				new TreeGroupData(LanguageManager.getWord("ssztl.rank.individualRank"),individualRank,RankType.INDIVIDUAL_RANK),
				new TreeGroupData(LanguageManager.getWord("ssztl.rank.copyRank"),copyRank,RankType.COPY_RANK),
				new TreeGroupData(LanguageManager.getWord("ssztl.rank.equipRank"),equipRank,RankType.EQUIP),
				new TreeGroupData(LanguageManager.getWord("ssztl.rank.mount"),mountRank,RankType.MOUNT),
				new TreeGroupData(LanguageManager.getWord("ssztl.rank.petRank"),petRank,RankType.PET),
				new TreeGroupData(LanguageManager.getWord("ssztl.rank.clubRank"),clubRank,RankType.CLUB),
//				new TreeGroupData(LanguageManager.getWord("ssztl.rank.activity"),activityRank,RankType.ACTIVITY),
			];
			
			_maccordion = new TreePanel(_groupData ,_rankMediator, 114, 6, false);
//			_maccordion.currentGroup
			_maccordion.setSize(114, 363);
			_maccordion.move(16, 12);
			addContent(_maccordion);
			
			_termsVessel = new Sprite();
			_termsVessel.x = 152;
			_termsVessel.y = 322;
//			addContent(_termsVessel);
			_termsVessel.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,0,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer")+"：",MAssetLabel.LABEL_TYPE20,"left")));
//			_termsVessel.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(186,0,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.sex")+"：",MAssetLabel.LABEL_TYPE20,"left")));
					
			_careerFields = [];
			var allCareerField:RankField = new RankField(RankType.ALL_CAREER_TYPE, LanguageManager.getWord("ssztl.rank.all"));
			allCareerField.move(36, 0);
			allCareerField.setSize(28,16);
//			_termsVessel.addChild(allCareerField);
			_careerFields.push(allCareerField);
			
			var yuewangzongField:RankField = new RankField(RankType.YUE_WANG_ZONG, LanguageManager.getWord("ssztl.common.yuewangzong"));
			yuewangzongField.move(72, 0);
			yuewangzongField.setSize(28,16);
//			_termsVessel.addChild(yuewangzongField);
			_careerFields.push(yuewangzongField);
			
			var tangmenField:RankField = new RankField(RankType.TANG_MEN, LanguageManager.getWord("ssztl.common.tangmen"));
			tangmenField.move(108, 0);
			tangmenField.setSize(28,16);
//			_termsVessel.addChild(tangmenField);
			_careerFields.push(tangmenField);
			
			var baihuaguField:RankField = new RankField(RankType.BAI_HUA_GU, LanguageManager.getWord("ssztl.common.baihuagu"));
			baihuaguField.move(144, 0);
			baihuaguField.setSize(28,16);
//			_termsVessel.addChild(baihuaguField);
			_careerFields.push(baihuaguField);
			
			_sexFields = [];
			var allSexField:RankField = new RankField(RankType.ALL_SEX_TYPE, LanguageManager.getWord("ssztl.rank.all"));
			allSexField.move(222, 0);
			allSexField.setSize(28,16);
//			_termsVessel.addChild(allSexField);
			_sexFields.push(allSexField);
			
			var maleSexField:RankField = new RankField(RankType.MALE_SEX_TYPE, LanguageManager.getWord("ssztl.common.male"));
			maleSexField.move(258, 0);
			maleSexField.setSize(28,16);
//			_termsVessel.addChild(maleSexField);
			_sexFields.push(maleSexField);
			
			var femaleSexField:RankField = new RankField(RankType.FEMALE_SEX_TYPE, LanguageManager.getWord("ssztl.common.female"));
			femaleSexField.move(282, 0);
			femaleSexField.setSize(28,16);
//			_termsVessel.addChild(femaleSexField);
			_sexFields.push(femaleSexField);
			
			_curCareerField = _careerFields[0];
			_curCareerField.select = true;
			
			_curSexField = _sexFields[0];
			_curSexField.select = true;
			
			_rankRoleView = new RankRoleView();
			_rankRoleView.move(623,-4);
			addContent(_rankRoleView);
			
			_petView = new RankPetView();
			_petView.move(623,-4);
			addContent(_petView);
			
			_mountView= new RankMountView();
			_mountView.move(623,-4);
			addContent(_mountView);
			
			setRankViews();
		}
		
		private function setRankViews():void
		{
			_rankViewClasses = new Dictionary();
			_rankViewClasses[RankType.TOP_TYPE_FIGHT] = StrikeRankView;
			_rankViewClasses[RankType.TOP_TYPE_LEVEL] = LevelRankView;
			_rankViewClasses[RankType.TOP_TYPE_VEINS] = VeinsRankView;
			_rankViewClasses[RankType.TOP_TYPE_GENGU] = GenguRankView;
			_rankViewClasses[RankType.TOP_TYPE_COPPER] = MoneyRankView;
			_rankViewClasses[RankType.TOP_TYPE_ACHIEVE] = AchieveRankView;
			
			_rankViewClasses[RankType.EQUIP1] = EquipRankView;
			_rankViewClasses[RankType.EQUIP2] = EquipRankView;
			_rankViewClasses[RankType.EQUIP3] = EquipRankView;
//			_rankViewClasses[RankType.EQUIP4] = EquipRankView;
			
			_rankViewClasses[RankType.MOUNT1] = MountFightRankView;
			_rankViewClasses[RankType.MOUNT2] = MountStairRankView;
			_rankViewClasses[RankType.MOUNT3] = MountGrowRankView;
			_rankViewClasses[RankType.MOUNT4] = MountQualityRankView;
			
			
			_rankViewClasses[RankType.PET1] = PetFightRankView;
			_rankViewClasses[RankType.PET2] = PetStairRankView;
			_rankViewClasses[RankType.PET3] = PetGrowRankView;
			_rankViewClasses[RankType.PET4] = PetQualityRankView;
			
			_rankViewClasses[RankType.CLUB1] = ClubRank1View;
			
//			_rankViewClasses[RankType.PVP] = PVPRankView;
			
//			_rankViewClasses[RankType.CLUB_LEVEL] = ClubRankView;
//			_rankViewClasses[RankType.EQUIP_WUQI] = EquipRankView;
//			_rankViewClasses[RankType.EQUIP_FANGJU] = EquipRankView;
//			_rankViewClasses[RankType.EQUIP_SHIPIN] = EquipRankView;
//			_rankViewClasses[RankType.COPY_CHIYUEKU] = MultiCopyRankView;
//			_rankViewClasses[RankType.COPY_XIULUOCHANG] = SingleCopyRankView;
//			_rankViewClasses[RankType.SHENMO_ISLAND] = ShenMoIslandRankView;
//			_rankViewClasses[RankType.PET_LEVEL] = PetLevelRankView;
//			_rankViewClasses[RankType.PET_APTITUDE] = PetAptitudeRankView;
//			_rankViewClasses[RankType.PET_GROW] = PetGrowRankView;
			
			_rankViewClasses[RankType.COPY_TYPE1] = SingleClimbingTowerRankView;
			_rankViewClasses[RankType.COPY_TYPE2] = SingleDefenceRankView;
			_rankViewClasses[RankType.COPY_TYPE3] = MultiClimbingTowerRankView;
			_rankViewClasses[RankType.COPY_TYPE4] = MultiDefenceRankView;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			var field:RankField = evt.currentTarget as RankField;
			field.select = true;
		}
		private function getTypeCode(crrentRankType:int):int
		{
			var additional:int;
			if(_curCareerField.type == RankType.ALL_CAREER_TYPE)
			{
				additional = 0;
			}
			else if((_curCareerField.type == RankType.YUE_WANG_ZONG))
			{
				additional = 1;
			}
			else if((_curCareerField.type == RankType.BAI_HUA_GU))
			{
				additional = 2;
			}
			else if((_curCareerField.type == RankType.TANG_MEN))
			{
				additional = 3;
			}
			return _curRankType + additional;
		}
		
		private function doSearch():void
		{
			var crrentTypeCode:int;
//			if(RankType.isIndividualRank(_curRankType))
			if(!RankType.isCopyRank(_curRankType))
			{
				if(_rankInfos.isRankInfoLoaded)
				{
					rankDataUpdateHandler(null);
				}
				else
				{
					RankSocketHanders.send();
				}
//				crrentTypeCode = getTypeCode(_curRankType);
//				RankSocketHanders.send(crrentTypeCode, _pageView.currentPage);
				
			}
			else if(RankType.isCopyRank(_curRankType))
			{
				crrentTypeCode = _curRankType;
				if(!_rankInfos.copyRankListDic[crrentTypeCode])
				{
					DuplicateRankSocketHanders.send(crrentTypeCode);
				}
				else
				{
					copyRankDataUpdateHandler(null);
				}
			}
		}
		
		private function getPath():String
		{
			var path:String = _curRankType.toString()+ "_" + _curCareerField.type.toString()+ "_" + _curSexField.type.toString();
			return path;
		}
		
		private function initEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.RANK_ITEM_CHANGE,rankItemChangeHandler);
			_rankInfos.addEventListener(RankEvent.RANK_INFO_LOADED, rankDataUpdateHandler);
			_rankInfos.addEventListener(RankEvent.COPY_RANK_LIST_UPDATE, copyRankDataUpdateHandler);
			
			_myRankBtn.addEventListener(MouseEvent.CLICK, myRankBtnHandler);
			_jumpBtn.addEventListener(MouseEvent.CLICK, jumpBtnHandler);
			
			_pageView.addEventListener(PageEvent.PAGE_CHANGE, pageViewChangeHandler);
			
			_maccordion.addEventListener(TreeItemEvent.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
			_maccordion.addEventListener(TreeItemEvent.GROUP_SELECT_CHANGE, groupSelectedChangeHandler);
			
			for each(var careerItem:RankField in _careerFields)
			{
				careerItem.addEventListener(MouseEvent.CLICK, careerTypeClickHandler);	
			}
			
			for each(var sexItem:RankField in _sexFields)
			{
				sexItem.addEventListener(MouseEvent.CLICK, sexTypeClickHandler);
			}
			
			_comboxCareer.addEventListener(Event.CHANGE,careerSelectHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.RANK_ITEM_CHANGE,rankItemChangeHandler);
			_rankInfos.addEventListener(RankEvent.RANK_INFO_LOADED, rankDataUpdateHandler);
			_rankInfos.addEventListener(RankEvent.COPY_RANK_LIST_UPDATE, copyRankDataUpdateHandler);
			
			_myRankBtn.removeEventListener(MouseEvent.CLICK, myRankBtnHandler);
			_jumpBtn.removeEventListener(MouseEvent.CLICK, jumpBtnHandler);
			
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE, pageViewChangeHandler);
			
			_maccordion.removeEventListener(TreeItemEvent.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
			_maccordion.removeEventListener(TreeItemEvent.GROUP_SELECT_CHANGE, groupSelectedChangeHandler);
			
			for each(var careerItem:RankField in _careerFields)
			{
				careerItem.removeEventListener(MouseEvent.CLICK, careerTypeClickHandler);	
			}
			
			for each(var sexItem:RankField in _sexFields)
			{
				sexItem.removeEventListener(MouseEvent.CLICK, sexTypeClickHandler);
			}
			
			_comboxCareer.removeEventListener(Event.CHANGE,careerSelectHandler);
		}
		
		private function copyRankDataUpdateHandler(event:RankEvent):void
		{
			var copyRankData:Array = _rankInfos.copyRankListDic[_curRankType];
			_pageView.totalRecord = copyRankData.length;
			setPageData();
		}
		
		private function rankDataUpdateHandler(event:RankEvent):void
		{
			var totalRecord:int;
			var currentRankInfo:Array;
			
			if(RankType.isIndividualRank(_curRankType))
			{
				var rankTypeCode:int = getTypeCode(_curRankType);
				_rankInfos.currentType = RankInfo.INDIVDUAL_RANK_TYPE_DIC[rankTypeCode.toString()];
				currentRankInfo = _rankInfos.individualRankListDic[_rankInfos.currentType];
			}
			else//除了副本、个人以外的排行
			{
				currentRankInfo = _rankInfos.otherRankListDic[_curRankType];
			}
			
			if(currentRankInfo)
			{
				totalRecord = currentRankInfo.length;
				_pageView.totalRecord = totalRecord;
				setPageData();
			}
			else
			{
				_pageView.totalRecord = 1
			}
		}
		
		private function groupSelectedChangeHandler(evt:TreeItemEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var groupType:int = evt.data as int;
			switch(groupType)
			{
				case RankType.INDIVIDUAL_RANK:
					setFieldVisible(true);
					_rankRoleView.show();
					_petView.hide();
					_mountView.hide();
					break;
				case RankType.PET:
					setFieldVisible(false);
					_petView.show();
					_rankRoleView.hide();
					_mountView.hide();
					break;
				case RankType.MOUNT:
					setFieldVisible(false);
					_mountView.show();
					_rankRoleView.hide();
					_petView.hide();
					break;
				default:
					setFieldVisible(false);
					_mountView.hide();
					_rankRoleView.hide();
					_petView.hide();
					break;
			}
		}
		
		private function rankItemChangeHandler(evt:CommonModuleEvent):void
		{
			var info:Object = evt.data;
			if(info is IndividualRankItem)
			{
				_rankRoleView.updateInfo(info as IndividualRankItem);
			}
			else if(info is OtherRankItem)
			{
				if(RankType.isPetRank(_curRankType))
				{
					_petView.updateInfo(info as OtherRankItem);
				}
				else if(RankType.isMountRank(_curRankType))
				{
					_mountView.updateInfo(info as OtherRankItem);
				}
			}
		}
		
		/**
		 * 处理树控件子项选中状态改变事件
		 */
		private function itemSelectedChangeHandler(evt:TreeItemEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			var rankType:int = evt.data as int;
			if(_curRankType == rankType)
			{
				return;
			}
			curRankType = rankType;
			
			doSearch();
		}
		
		private function careerSelectHandler(e:Event):void
		{
			var rankField:RankField = _careerFields[Number(_comboxCareer.selectedItem.value)];
			if(_curCareerField == rankField)
				return ;
			if(_curCareerField)
				_curCareerField.select = false;
			_curCareerField = rankField;
			_curCareerField.select = true;
			_pageView.setPage(1);
			doSearch();
		}
		private function careerTypeClickHandler(evt:MouseEvent):void
		{
			var rankField:RankField = evt.currentTarget as RankField;
			if(_curCareerField == rankField)
				return ;
			if(_curCareerField)
				_curCareerField.select = false;
			_curCareerField = rankField;
			_curCareerField.select = true;
			_pageView.setPage(1);
			doSearch();
		}
		
		private function sexTypeClickHandler(evt:MouseEvent):void
		{
			var rankField:RankField = evt.currentTarget as RankField;
			if(_curSexField == rankField)
				return;
			if(_curSexField)
				_curSexField.select = false;
			_curSexField = rankField;
			_curSexField.select = true;
			_pageView.setPage(1);
			doSearch();
		}
		
		private function setPageData():void
		{
			_rankViews[_curRankType].setData();
		}
		
		private function setFieldVisible(visible:Boolean):void
		{
			var field:RankField;
			
			_termsVessel.visible = visible;
			_comboxCareer.visible = visible;
		}
		
		public function set curRankType(rankType:int):void
		{
			if(_curRankType == rankType)
			{
				return;
			}
			else
			{
				_pageView.setPage(1);
				
				if(_rankViews[_curRankType])
				{
					_rankViews[_curRankType].hide();
				}
				
				_curRankType = rankType;
				_rankInfos.currentType = rankType;
				if(_curCareerField != _careerFields[0])
				{
					_curCareerField.select = false;
					_curCareerField = _careerFields[0];
					_curCareerField.select = true;
					_comboxCareer.selectedIndex = 0;
				}
				if(_curSexField != _sexFields[0])
				{
					_curSexField.select = false;
					_curSexField = _sexFields[0];
					_curSexField.select = true;
				}
				
				if(!_rankViews[_curRankType])
				{
					_rankViews[_curRankType] = new _rankViewClasses[_curRankType](_rankInfos);
				}
				_rankViews[_curRankType].setSize(473, 304);
				_rankViews[_curRankType].move(137, 11);
				addContent(_rankViews[_curRankType]);
				_rankViews[_curRankType].show();
			}
		}
		
		//点击“我的排行”按钮 触发
		private function myRankBtnHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
		}
		
		//点击跳转按钮触发
		private function jumpBtnHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			var pageNum:int = parseInt(_jumpPageField.text);
			if(pageNum<1 || pageNum>10)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.rank.inputNumber"));
				return;
			}
			_pageView.setPage(pageNum);
			doSearch();
		}
		
		private function pageViewChangeHandler(evt:PageEvent):void
		{
			_rankInfos.currentPage = _pageView.currentPage;
			doSearch();
		}
		
		override public function dispose():void
		{
			removeEvents();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_myRankBtn)
			{
				_myRankBtn.dispose();
				_myRankBtn = null;
			}
			
			if(_jumpBtn)
			{
				_jumpBtn.dispose();
				_jumpBtn = null;
			}
			
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			
			if(_maccordion)
			{
				_maccordion.dispose();
				_maccordion = null;
			}
			
			if(_jumpPageField && _jumpPageField.parent)
			{
				_jumpPageField.parent.removeChild(_jumpPageField);
			}
			if(_careerFields)
			{
				for(var i:int=0;i<_careerFields.length;i++)
				{
					_careerFields[i].dispose();
				}
				_careerFields = null;
			}
			if(_sexFields)
			{
				for(var j:int=0;j<_sexFields.length;j++)
				{
					_sexFields[j].dispose();
				}
				_sexFields = null;
			}
			
			for each(var view:IRankView in _rankViews)
			{
				view.dispose();
			}
			if(_rankRoleView)
			{
				_rankRoleView.dispose();
				_rankRoleView = null;
			}
			if(_comboxCareer)
			{
				_comboxCareer = null;
			}
			_rankViews = null;
			_rankViewClasses = null;
			
			_curCareerField = null;
			_curSexField = null;
			
			_rankMediator = null;
			_rankInfos = null;
			
			_groupData = null;
			super.dispose();
		}
	}
}