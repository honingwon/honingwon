package sszt.core.view.petSkill
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.TitleAsset1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemList;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.ui.BtnStairUpAsset;
	import ssztui.ui.WinTitleHintAsset;
	
	
	public class PetSkillPanel extends MPanel
	{
		private static var instance:PetSkillPanel;
		private var _bg:IMovieWrapper;
		private var _itemMTile:MTile;
		private var _itemMTile1:MTile;
		private var _titleList:Array = [];
		private var _currentItem:TreeItemView;
		private var _comboxClass:ComboBox;
		private var _currentSkillList:Array = [];
		private var _pageView:PageView;
		
		public function PetSkillPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.PetSkillListTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.PetSkillListTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			
			super.configUI();
			setContentSize(585,384);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,2,569,374)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,120,366)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(134,6,439,366)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,9,114,30),new BtnStairUpAsset()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,111,114,30),new BtnStairUpAsset()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(47,16,50,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.petSkill"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(47,117,50,14),new MAssetLabel(LanguageManager.getWord("ssztl.mounts.mountsSkill"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_itemMTile = new MTile(114,23);
			_itemMTile.itemGapH = _itemMTile.itemGapW = 0;
			_itemMTile.setSize(114,100);
			_itemMTile.move(15,40);
			addContent(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollBar.lineScrollSize = 26;
			
			_itemMTile1 = new MTile(426,80);
			_itemMTile1.itemGapH = _itemMTile1.itemGapW = 1;
			_itemMTile1.setSize(426,324);
			_itemMTile1.move(140,12);
			addContent(_itemMTile1);
			_itemMTile1.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile1.verticalScrollPolicy = ScrollPolicy.OFF;
			
			var petSkillArr:Array = [
				{name:LanguageManager.getWord("ssztl.core.petSkill1"),type:1},
				{name:LanguageManager.getWord("ssztl.core.petSkill2"),type:2},
				{name:LanguageManager.getWord("ssztl.core.petSkill3"),type:3},
			];
			
			var mountSkillArr:Array = [{name:LanguageManager.getWord("ssztl.core.petSkill4"),type:4}];
			
			
			for each(var obj:Object in  petSkillArr )
			{
				var title:TreeItemView =new TreeItemView(obj);
				_itemMTile.appendItem(title);
				_titleList.push(title);
			}
			var mTitle:TreeItemView = new TreeItemView(mountSkillArr[0]);
			addContent(mTitle);
			mTitle.x = 15 ;
			mTitle.y = 143;
			_titleList.push(mTitle);
			
			_comboxClass = new ComboBox();
			_comboxClass.open();
			_comboxClass.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_comboxClass.x = 165;
			_comboxClass.y = 14;
			_comboxClass.width = 104;
			_comboxClass.height = 22;
			_comboxClass.rowCount = 4;
//			addContent(_comboxClass);
			
			_pageView = new PageView(1,false, 100);
			_pageView.move(300, 342);
			addContent(_pageView);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _titleList.length; i++)
			{
				TreeItemView(_titleList[i]).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
//			_comboxClass.addEventListener(Event.CHANGE,selectCharacter);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		private function removeEvent():void
		{
			for(var i:int = 0; i < _titleList.length; i++)
			{
				TreeItemView(_titleList[i]).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
//			_comboxClass.removeEventListener(Event.CHANGE,selectCharacter);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		public function show(type:int):void
		{
			if(type==1)
				_currentItem = _titleList[0];
			else
				_currentItem = _titleList[3];
			
			_currentItem.selected = true;
			switchTo(_currentItem);
			if(!parent) GlobalAPI.layerManager.addPanel(this);
		}
		private function pageChangeHandler(e:PageEvent):void
		{
			updateView();
		}
		
		private function selectCharacter(e:Event):void
		{
			_pageView.currentPage = Math.ceil(_comboxClass.selectedIndex/4);
			updateView();
		}
		private function itemClickHandler(evt:MouseEvent):void
		{
			var target:TreeItemView = evt.currentTarget as TreeItemView;
			if(_currentItem == target) return;
			switchTo(target);
		}
		
		private function switchTo(tv:TreeItemView):void
		{
			if(_currentItem)
				_currentItem.selected = false;
			_currentItem = tv;
			_currentItem.selected = true;
			var obj:Object = null;
			var i:int = 1;
			var dp:DataProvider = new DataProvider();
			if(_currentItem.info.type==1)
			{
				dp.addItem({label:LanguageManager.getWord("ssztl.core.petSkill1")});
				_currentSkillList =SkillTemplateList.getPetActiveSkills();
			}
			else if(_currentItem.info.type==2)
			{
				dp.addItem({label:LanguageManager.getWord("ssztl.core.petSkill2")});
				_currentSkillList = SkillTemplateList.getPetPassSkills();
			}
			else if(_currentItem.info.type==3)
			{
				dp.addItem({label:LanguageManager.getWord("ssztl.core.petSkill3")});
				_currentSkillList = SkillTemplateList.getPetAssistSkills();
			}
			else if(_currentItem.info.type==4)
			{
				dp.addItem({label:LanguageManager.getWord("ssztl.core.petSkill4")});
				_currentSkillList = SkillTemplateList.getMountSkills();
			}
			for each(obj in _currentSkillList)
			{
				dp.addItem({label:obj.name});
			}
			_comboxClass.dataProvider =dp;
			
			updateView();
		}
		
		private function updateView():void
		{
			if(_currentItem==null)return;
			clearCells();
			var list:Array = getList(_pageView.currentPage - 1);				
			for each(var petObj:Object in list)
			{
				var skillView:SkillItemView = new SkillItemView(petObj);
				_itemMTile1.appendItem(skillView);
			}	
		}
		
		private function clearCells():void
		{
			_itemMTile1.disposeItems();
		}
		
		private function getList(pageIndex:int = 0,pageSize:int = 4):Array
		{
			var result:Array;
			result = [];
			if(_currentSkillList.length>0)
			{
				for each(var fd:Object in _currentSkillList)
				{
					result.push(fd);
				}
			}
			_pageView.totalRecord = Math.ceil(result.length/pageSize);
			_pageView.setPage(_pageView.currentPage);
			return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);			
		}
		
		public static function getInstance():PetSkillPanel
		{
			if(instance == null)
			{
				instance = new PetSkillPanel();
			}
			return instance;
		}
		override public function dispose():void
		{
			validate();
			if(parent) parent.removeChild(this);
			instance = null
			super.dispose();
		}
	}
}