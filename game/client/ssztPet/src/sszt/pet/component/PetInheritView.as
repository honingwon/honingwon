package sszt.pet.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pet.PetInheritSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.PetModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pet.component.cells.PetCell;
	import sszt.pet.component.cells.PetCellBig;
	import sszt.pet.component.popup.PetInheritSecondaryPetsView;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	
	import ssztui.pet.InheritInfoTagAsset;
	import ssztui.pet.InheritRuleTitleAsset;
	import ssztui.pet.ItemOnAsset;
	import ssztui.ui.SmallBtnDownAsset;
	import ssztui.ui.SplitCompartLine;
	import ssztui.ui.SplitCompartLine2;
	
	public class PetInheritView extends Sprite implements IPetView
	{
		private var _mediator:PetMediator;
		private var _currentPetItemInfo:PetItemInfo;
		
		private var _bg:IMovieWrapper;
		private var _inheritBg:Bitmap;
		
		private var _primaryPetCell:PetCellBig;
		private var _secondaryPetCell:PetCellBig;
		private var _resultPetCell:PetCellBig;
		private var _primaryName:MAssetLabel;
		private var _secondaryName:MAssetLabel;
		private var _secondaryPetsView:PetInheritSecondaryPetsView;
		private var _btnSelect:MAssetButton1;
		private var _btnStartInherit:MCacheAssetBtn1;
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _growLabel:MAssetLabel;
		private var _stairsLabel:MAssetLabel;
		private var _qualityLabel:MAssetLabel;
		private var _inheritExplain:MAssetLabel;
		private var _labelInfo:MAssetLabel;
		
		public function PetInheritView(mediator:PetMediator)
		{
			_mediator = mediator;
			
			_currentPetItemInfo = _mediator.module.petsInfo.currentPetItemInfo;
			
			super();
			initView();
			initEvent();
			
			setData(null);
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(270,166,190,15),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(324,9,89,18),new Bitmap(new InheritInfoTagAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(332,175,68,16),new Bitmap(new InheritRuleTitleAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(109,216,50,50),new Bitmap(new ItemOnAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_inheritBg = new Bitmap();
			_inheritBg.x = _inheritBg.y = 2;
			
			_primaryName = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_primaryName.move(83,42);
			addChild(_primaryName);
			
			_secondaryName = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_secondaryName.move(183,42);
			addChild(_secondaryName);
			
			_primaryPetCell = new PetCellBig();
			_primaryPetCell.move(59,64);
			addChild(_primaryPetCell);
			
			_secondaryPetCell = new PetCellBig();
			_secondaryPetCell.move(159,64);
			addChild(_secondaryPetCell);
			
			_resultPetCell = new PetCellBig();
			_resultPetCell.move(109,216);
			addChild(_resultPetCell);
			
			_secondaryPetsView = new PetInheritSecondaryPetsView();
			_secondaryPetsView.move(160,115);
			addChild(_secondaryPetsView);
			
			_btnSelect = new MAssetButton1(SmallBtnDownAsset);
			_btnSelect.move(209,97);
			addChild(_btnSelect);
			
			_btnStartInherit = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.pet.startInherit'));
			_btnStartInherit.move(85,294);
			addChild(_btnStartInherit);
			
			/** 信息标签　*/
			_labelInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelInfo.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_labelInfo.move(282,38);
			addChild(_labelInfo);
			_labelInfo.setValue(
				LanguageManager.getWord("ssztl.common.name")+ "：\n" +
				LanguageManager.getWord("ssztl.common.level")+ "：\n" +
				LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.qualityLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.growLabel")+ "："
			);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameLabel.move(317,38);
			addChild(_nameLabel);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(317,58);
			addChild(_levelLabel);
			
			_stairsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_stairsLabel.move(317,78);
			addChild(_stairsLabel);
			
			_qualityLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_qualityLabel.move(317,98);
			addChild(_qualityLabel);
			
			_growLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_growLabel.move(317,118);
			addChild(_growLabel);
			
			_inheritExplain = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_inheritExplain.wordWrap = true;			
			_inheritExplain.move(282,205);
			_inheritExplain.setSize(170,140);		
			_inheritExplain.setHtmlValue(LanguageManager.getWord('ssztl.pet.inheritExplain'));
			addChild(_inheritExplain);
		}
		
		private function initEvent():void
		{
			_btnSelect.addEventListener(MouseEvent.CLICK, selectHandler);
			_btnStartInherit.addEventListener(MouseEvent.CLICK, startInheritHandler);
			ModuleEventDispatcher.addPetEventListener(PetModuleEvent.XISUI_SUCCESS, xisuiSuccessHandler);
			
			_currentPetItemInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnSelect.removeEventListener(MouseEvent.CLICK, selectHandler);
			_btnStartInherit.removeEventListener(MouseEvent.CLICK, startInheritHandler);
			ModuleEventDispatcher.removePetEventListener(PetModuleEvent.XISUI_SUCCESS, xisuiSuccessHandler);
			
			_currentPetItemInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
		}
		
		private function xisuiSuccessHandler(e:Event):void
		{
			clearAndHideSecondaryPetsView();
		}
		
		private function startInheritHandler(e:Event):void
		{
			if(!_secondaryPetCell.petItemInfo)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.pet.selectOneSecondaryPet'));
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.pet.checkPetInherit"),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
				function leaveCloseHandler(e:CloseEvent):void
				{
					if(e.detail == MAlert.OK)
					{
						PetInheritSocketHandler.send(_currentPetItemInfo.id, _secondaryPetCell.petItemInfo.id);
					}
				}				
			}
		}
		
		private function selectHandler(e:Event):void
		{
			if(GlobalData.petList.getList().length >= 2)
			{
				_secondaryPetsView.visible = !_secondaryPetsView.visible;
			}
			else
			{
				QuickTips.show(LanguageManager.getWord('ssztl.pet.hasNoSecondaryPet'));
			}
		}
		
		public function setData(e:Event):void //currentPetItemInfo:PetItemInfo
		{
//			_currentPetItemInfo = currentPetItemInfo;			
			_primaryPetCell.petItemInfo = _currentPetItemInfo;
			_resultPetCell.petItemInfo = _currentPetItemInfo;
			_resultPetCell.visible = false;
			_primaryName.setValue(_currentPetItemInfo.nick);
			_primaryName.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_currentPetItemInfo.templateId).quality);
			
			clearAndHideSecondaryPetsView();
			var petItemInfoList:Array = getSecondaryPetItemInfoList();
			if(petItemInfoList.length > 0)
			{
				_secondaryPetsView.petItemInfoList = petItemInfoList;
			}
			
			updateName();
			upgrade();
			updateAttr();
		}
		private function currentPetChangeHandler(e:PetEvent):void
		{
			_currentPetItemInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_currentPetItemInfo = _mediator.module.petsInfo.currentPetItemInfo;
			_currentPetItemInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			setData(null);
		}
		
		private function clearAndHideSecondaryPetsView():void
		{
			if(_secondaryPetsView.petItemInfoList)
			{
				_secondaryPetsView.clear();
			}
			_secondaryPetsView.visible = false;
			_secondaryPetCell.petItemInfo = null;
			_secondaryName.setValue("");
		}

		private function getSecondaryPetItemInfoList():Array
		{
			var globalPetItemInfoList:Array = GlobalData.petList.getList();
			var petItemInfoList:Array = globalPetItemInfoList.slice(0,globalPetItemInfoList.length);
			for(var i:int = 0; i < petItemInfoList.length; i++)
			{
				if(PetItemInfo(petItemInfoList[i]) == _currentPetItemInfo)
				{
					petItemInfoList.splice(i, 1);
					break;
				}
			}
			return petItemInfoList;
		}
		
		public function get secondaryPetCell():PetCell
		{
			return _secondaryPetCell;
		}
		public function get resultPetCell():PetCell
		{
			return _resultPetCell;
		}
		public function get secondaryName():MAssetLabel
		{
			return _secondaryName;
		}
		
		public function updateName():void
		{
			_nameLabel.setValue(_currentPetItemInfo.nick);
			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_currentPetItemInfo.templateId).quality);
		}
		
		public function upgrade():void
		{
			_levelLabel.setValue(_currentPetItemInfo.level.toString());
		}
		
		public function updateAttr():void
		{
			_stairsLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_currentPetItemInfo.stairs));
			_growLabel.setValue(_currentPetItemInfo.grow + "/" + _currentPetItemInfo.upGrow);
			_qualityLabel.setValue(_currentPetItemInfo.quality + "/" + _currentPetItemInfo.upQuality);
		}
		public function updateFuseAttr():void
		{
			if(_secondaryPetCell.petItemInfo)
			{
				var level:int=_secondaryPetCell.petItemInfo.level>_currentPetItemInfo.level?_secondaryPetCell.petItemInfo.level:_currentPetItemInfo.level;
				var stairs:int=_secondaryPetCell.petItemInfo.stairs>_currentPetItemInfo.stairs?_secondaryPetCell.petItemInfo.stairs:_currentPetItemInfo.stairs;
				var grow:int=_secondaryPetCell.petItemInfo.grow>_currentPetItemInfo.grow?_secondaryPetCell.petItemInfo.grow:_currentPetItemInfo.grow;
				var upGrow:int=_secondaryPetCell.petItemInfo.upGrow>_currentPetItemInfo.upGrow?_secondaryPetCell.petItemInfo.upGrow:_currentPetItemInfo.upGrow;
				var quality:int=_secondaryPetCell.petItemInfo.quality>_currentPetItemInfo.quality?_secondaryPetCell.petItemInfo.quality:_currentPetItemInfo.quality;
				var upQuality:int=_secondaryPetCell.petItemInfo.upQuality>_currentPetItemInfo.upQuality?_secondaryPetCell.petItemInfo.upQuality:_currentPetItemInfo.upQuality;
				_levelLabel.setValue(level.toString());
				_stairsLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",stairs));
				_growLabel.setValue(grow + "/" + upGrow);
				_qualityLabel.setValue(quality + "/" + upQuality);
			}
		}
		public function assetsCompleteHandler():void
		{
			_inheritBg.bitmapData = AssetUtil.getAsset('ssztui.pet.InheritBgAsset',BitmapData) as BitmapData;
			addChildAt(_inheritBg,0);
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_primaryPetCell)
			{
				_primaryPetCell.dispose();
				_primaryPetCell = null;
			}
			if(_secondaryPetCell)
			{
				_secondaryPetCell.dispose();
				_secondaryPetCell = null;
			}
			if(_resultPetCell)
			{
				_resultPetCell.dispose();
				_resultPetCell = null;
			}
			_primaryName = null;
			_secondaryName = null;
			_inheritExplain = null;
			_labelInfo = null;
		}
	}
}