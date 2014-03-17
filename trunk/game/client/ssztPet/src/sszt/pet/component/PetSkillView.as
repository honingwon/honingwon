package sszt.pet.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.pet.PetRemoveSkillSocketHandler;
	import sszt.core.socketHandlers.pet.PetSealSkillSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.petSkill.PetSkillPanel;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.pet.component.cells.PetSkillCell;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.page.PageView;
	
	import ssztui.pet.TagHasSkillAsset;
	import ssztui.pet.TagMySkillAsset;
	
	
	public class PetSkillView extends Sprite implements IPetView
	{
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		private var _mediator:PetMediator;
		private var _petItemInfo:PetItemInfo;
		
		private var _bagTile:MTile;
		private var _tile:MTile;
		private var _list:Array;
		private var _currentCell:PetSkillCell;
		private var _pageView:PageView;
		
		private var _delBookBtn:MCacheAssetBtn1;
		private var _delUnload:MCacheAssetBtn1;
		private var _skillBookBtn:MCacheAssetBtn1;
		private var _showSkillBtn:MCacheAssetBtn1;
		private var _btns:Array;
		
		public function PetSkillView(mediator:PetMediator)
		{
			_mediator = mediator;
			_petItemInfo = _mediator.module.petsInfo.currentPetItemInfo;
			
			super();
			initView();
			initEvent();
			setData(null);
		}
		
		private function initView():void
		{
			_bgImg = new Bitmap();
			_bgImg.x = _bgImg.y = 2;
			addChild(_bgImg);
			
			var tip:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			tip.setHtmlValue(LanguageManager.getWord("ssztl.pet.unloadTip"));
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(115,11,234,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(178,16,105,16),new Bitmap(new TagHasSkillAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(182,204,88,16),new Bitmap(new TagMySkillAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,44,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,83,233,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,122,233,38),new Bitmap(CellCaches.getCellBgPanel61())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,229,234,38),new Bitmap(CellCaches.getCellBgPanel61())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,268,233,38),new Bitmap(CellCaches.getCellBgPanel61())),
				
				new  BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(312,322,80,15),tip)
			]);
			addChild(_bg as DisplayObject);
			
			_showSkillBtn  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.skillShow"));
			_showSkillBtn.move(367,101);
			addChild(_showSkillBtn);
			
			_skillBookBtn  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.skillBookLabel"));
			_skillBookBtn.move(367,132);
			addChild(_skillBookBtn);
			
			_delBookBtn  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.delete"));
			_delBookBtn.move(157,317);
			addChild(_delBookBtn);
			
			_delUnload  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.skillDeleteLabel"));
			_delUnload.move(235,317);
			addChild(_delUnload);
			
			_btns = [_showSkillBtn,_skillBookBtn,_delBookBtn,_delUnload];
			
			_bagTile = new MTile(39,39,6);
			_bagTile.setSize(234,117);
			_bagTile.itemGapW = _bagTile.itemGapH = 0;
			_bagTile.move(115,44);
			_bagTile.horizontalScrollPolicy = _bagTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_bagTile);
			
			_pageView = new PageView(24,false,90);
			_pageView.move(187,165);
			addChild(_pageView);
			
			_tile = new MTile(39,39,6);
			_tile.setSize(234,78);
			_tile.itemGapW = _tile.itemGapH = 0;
			_tile.move(115,229);
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_list = [];
			for(var i:int = 0; i< PetsInfo.PET_SKILL_CELL_NUM_MAX; i++)
			{
				var cell:PetSkillCell = new PetSkillCell(i);
				_tile.appendItem(cell);
				_list.push(cell);
			}
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i< PetsInfo.PET_SKILL_CELL_NUM_MAX; i++)
			{
				var cell:PetSkillCell = _list[i] as PetSkillCell;
				cell.addEventListener(MouseEvent.CLICK, cellClickHandler);
				cell.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				cell.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			}
			for(i=0; i< _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			_petItemInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i< PetsInfo.PET_SKILL_CELL_NUM_MAX; i++)
			{
				var cell:PetSkillCell = _list[i] as PetSkillCell;
				cell.removeEventListener(MouseEvent.CLICK, cellClickHandler);
				cell.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				cell.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			}
			for(i=0; i< _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			_petItemInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
		}
		private function btnClickHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var index:int = _btns.indexOf(event.currentTarget);
			switch (index)
			{
				case 0:
					PetSkillPanel.getInstance().show(1);
					break;
				case 1:
					_mediator.initGetSkillBooksPanel();
					break;
				case 2:
					deleteSkill();
					break;
				case 3:
					sealSkill();
					break;
			}
		}
		
		private function updataSkillBook(argItemInfo:ItemInfo):void
		{
			var list:Array = GlobalData.bagInfo.getItemListByCategoryId(CategoryType.PET_SKILL_BOOK);
		}
		
		private function sealSkill():void
		{
			if(!currentCell || !currentCell.skillInfo || currentCell.skillInfo.templateId == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.pet.chooseSkill"));
				return;
			}
			
			var list:Array = GlobalData.bagInfo.getItemById(CategoryType.PET_SKILL_SEAL_SYMBOL);
			if(list.length == 0)
			{
				BuyPanel.getInstance().show([CategoryType.PET_SKILL_SEAL_SYMBOL],new ToStoreData(ShopID.STORE));
				return;
			}
			MAlert.show(LanguageManager.getWord("ssztl.pet.isSureForgetSkill",getSkillName(currentCell.skillInfo)),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,closeHandler);
			
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					PetSealSkillSocketHandler.send(_mediator.module.petsInfo.currentPetItemInfo.id, currentCell.skillInfo.templateId);
				}
			}
		}
		private function deleteSkill():void
		{
			if(!currentCell || !currentCell.skillInfo || currentCell.skillInfo.templateId == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.pet.chooseSkill"));
				return;
			}
			MAlert.show(LanguageManager.getWord("ssztl.pet.isSureDeleteSkill", getSkillName(currentCell.skillInfo) ),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,closeHandler);
			
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					PetRemoveSkillSocketHandler.send(_mediator.module.petsInfo.currentPetItemInfo.id, currentCell.skillInfo.templateId);
				}
			}
		}
		private function getSkillName(skillInfo:PetSkillInfo):String
		{
			var name:String = skillInfo.getTemplate().name;
			var namePrefix:String;
			switch(skillInfo.level)
			{
				case 1 :
					namePrefix = LanguageManager.getWord('ssztl.common.primary');
					break;
				case 2 :
					namePrefix = LanguageManager.getWord('ssztl.common.intermediate');
					break;
				case 3 :
					namePrefix = LanguageManager.getWord('ssztl.common.advanced');
					break;
				case 4 :
					namePrefix = LanguageManager.getWord('ssztl.common.superfine');
					break;
				case 5 :
					namePrefix = LanguageManager.getWord('ssztl.common.topLevel');
					break;
			}
			return namePrefix + name;
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			var _cur:PetSkillCell = evt.currentTarget as PetSkillCell;
			_cur.over = true;
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var _cur:PetSkillCell = evt.currentTarget as PetSkillCell;
			_cur.over = false;
		}
		
		public function setData(e:Event):void //value:PetItemInfo
		{
			_petItemInfo.addEventListener(PetItemInfoUpdateEvent.SKILL_UPDATE,skillUpdateHandler);
			var info:SkillItemInfo;
			for(var i:int = 0 ;i < _petItemInfo.skillCellNum  ; ++i)
			{
				info = _petItemInfo.skillList[i];
				if(info)
				{
					_list[i].skillInfo = info;
				}
				else
				{
					_list[i].skillInfo = null;
				}
				_list[i].isOpen = true;
			}
			for(var j:int = i ;j < 12 ; ++j)
			{
				_list[j].isOpen = false;
			}
		}
		private function currentPetChangeHandler(e:PetEvent):void
		{
			clear();
			_petItemInfo = _mediator.module.petsInfo.currentPetItemInfo;
			_petItemInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			setData(null);
		}
		
		public function clear():void
		{
			if(_petItemInfo){
				_petItemInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
				_petItemInfo.removeEventListener(PetItemInfoUpdateEvent.SKILL_UPDATE,skillUpdateHandler);
			}
			_petItemInfo = null;
			for(var i:int = 0;i<_list.length;i++)
			{
				PetSkillCell(_list[i]).selected = false;
				PetSkillCell(_list[i]).skillInfo = null;
			}
		}
		
		private function skillUpdateHandler(evt:PetItemInfoUpdateEvent):void
		{
			for(var i:int = 0;i<_list.length;i++)
			{
				PetSkillCell(_list[i]).skillInfo = null;
			}
			var info:SkillItemInfo;
			_currentCell = null;
			for(i = 0 ;i < _petItemInfo.skillCellNum ; ++i)
			{
				_list[i].selected = false;
				info = _petItemInfo.skillList[i];
				if(info)
				{
					_list[i].skillInfo = info;
				}
				else
				{
					_list[i].skillInfo = null;
				}
				_list[i].isOpen = true;
			}
			for(var j:int = i ;j < 12 ; ++j)
			{
				_list[j].isOpen = false;
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			var cell:PetSkillCell = evt.currentTarget as PetSkillCell;
			if(cell.skillInfo == null ) return;
			if(_currentCell) _currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
		}
		
		public function get currentCell():PetSkillCell
		{
			return _currentCell;
		}
		
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset('ssztui.pet.SkillBgAsset',BitmapData) as BitmapData;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		public function show():void
		{
			
		}
		public function move(x:Number,y:Number):void
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
			if(_petItemInfo)
			{
				_petItemInfo.removeEventListener(MountsItemInfoUpdateEvent.SKILL_UPDATE,skillUpdateHandler);
				_petItemInfo = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_list)
			{
				for(var i:int = 1;i<_list.length;i++)
				{
					_list[i].removeEventListener(MouseEvent.CLICK,cellClickHandler);
					_list[i].dispose();
				}
				_list = null;	
			}
			if(_bgImg && _bgImg.bitmapData)
			{
				_bgImg.bitmapData.dispose();
				_bgImg = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			_currentCell = null;
			_delBookBtn = null;
			_delUnload = null;
			_skillBookBtn = null;
			_showSkillBtn = null;
			if(parent) parent.removeChild(this);
		}
	}
}