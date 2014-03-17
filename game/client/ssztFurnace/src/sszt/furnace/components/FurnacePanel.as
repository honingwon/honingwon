package sszt.furnace.components
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	import fl.controls.TextArea;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.furnace.FurnaceIntroInfo;
	import sszt.core.data.furnace.FurnaceIntroList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.core.view.tips.TipsUtil;
	import sszt.furnace.components.materialTabPanel.MaterialPanel;
	import sszt.furnace.components.qualityTabPanel.QualityPanel;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset4Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.furnace.IconTipAsset;
	import ssztui.furnace.TabBtnAsset1;
	import ssztui.furnace.TabBtnAsset2;
	import ssztui.furnace.TitleTxtAsset;
	
	public class FurnacePanel extends MPanel
	{
		private var _mediator:FurnaceMediator;
		private var _bg:IMovieWrapper;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int;
		
		private var _qualityTabPanel:QualityPanel;
		private var _materialTabPanel:MaterialPanel;
		
		private var _btnHelpExplain:Sprite;
		private var _introList:Array;
		
		private var _yuanBaoView:MAssetLabel;               //元宝
		private var _copperView:MAssetLabel;                //铜币
		private var _bindCopperView:MAssetLabel;           //绑定铜币
		
		private var _defaultBg:Bitmap;
		private var _assetsComplete:Boolean;
		
		private var _useBindCheckBox:CheckBox;
		private var _autoBuyCheckBox:CheckBox;
		
		private var _TabBtn1:MSelectButton;
		private var _TabBtn2:MSelectButton;
		
		public function FurnacePanel(mediator:FurnaceMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new TitleTxtAsset())),true,-1);
			initEvent();
			
		}
		
		public function addAssets():void
		{
//			_refiningBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.RefiningBgAsset",BitmapData) as BitmapData;
			_defaultBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.DefaultBgAsset",BitmapData) as BitmapData;
			_assetsComplete = true;
			if(_currentIndex != -1 && _panels[_currentIndex])
			{
				(_panels[_currentIndex] as IFurnaceTabPanel).addAssets();
			}
		}
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(607,442);
			_TabBtn1 = new MSelectButton(new TabBtnAsset1());
			_TabBtn1.move(-31,33);			
			addContent(_TabBtn1);
			_TabBtn2 = new MSelectButton(new TabBtnAsset2());
			_TabBtn2.move(-31,95);
			addContent(_TabBtn2);
			_TabBtn1.selected = true;
			
			smithingConfigUI();
//			_smithingBtn.enabled = false;
//			refiningConfigUI();
//			_refiningBtn.enabled = true;
			//是否默认填物品
//			if(_mediator.furnaceModule.toData.itemId != -1)
//				_mediator.furnaceModule.furnaceInfo.putAgainHandler(_mediator.furnaceModule.toData.itemId);
		}
		public function getUseBindItem():Boolean
		{
			return _useBindCheckBox.selected;
		}
		public function getAutoBuy():Boolean
		{
			return _autoBuyCheckBox.selected;
		}
		private function smithingConfigUI():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,591,409)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,334,375)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(12,407,100,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(113,407,115,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(229,407,117,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,409,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(117,409,18,18),new Bitmap(MoneyIconCaches.copperAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(232,409,18,18),new Bitmap(MoneyIconCaches.bingCopperAsset)),
				]);
			addContent(_bg as DisplayObject);
			_defaultBg = new Bitmap();
			_defaultBg.x = 14;
			_defaultBg.y = 31;
			addContent(_defaultBg as DisplayObject);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(26,350,20,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.fare"),MAssetLabel.LABEL_TYPE20,"left")));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(60,349,18,18),new Bitmap(MoneyIconCaches.copperAsset)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(27,375,15,15),new Bitmap(new IconTipAsset() as BitmapData)));
			
			//帮助说明
			var txtHelp:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			txtHelp.htmlText = "<u>"+LanguageManager.getWord("ssztl.common.helpExplain")+"</u>";
			txtHelp.move(45,374);
			addContent(txtHelp);
			_btnHelpExplain = new Sprite();
			_btnHelpExplain.graphics.beginFill(0xffffff,0);
			_btnHelpExplain.graphics.drawRect(25,372,74,17);
			_btnHelpExplain.graphics.endFill();
			_btnHelpExplain.buttonMode = true;
			addContent(_btnHelpExplain);
			
			_currentIndex = -1;			
			_useBindCheckBox = new CheckBox();
			_useBindCheckBox.label = LanguageManager.getWord("ssztl.furnace.priorityUseBindMaterial");
			_useBindCheckBox.setSize(124,20);
			_useBindCheckBox.move(215,372);
			_useBindCheckBox.selected = true;
			addContent(_useBindCheckBox);			
			_autoBuyCheckBox = new CheckBox();
			_autoBuyCheckBox.label = LanguageManager.getWord("ssztl.furnace.autoBuyMaterial");
			_autoBuyCheckBox.setSize(100,20);
			_autoBuyCheckBox.move(193,361);
			_autoBuyCheckBox.visible = false;
			addContent(_autoBuyCheckBox);
			
			_yuanBaoView= new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_yuanBaoView.move(36,411);
			_yuanBaoView.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			addContent(_yuanBaoView);
			_copperView = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_copperView.move(137,411);
			_copperView.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
			addContent(_copperView);
			_bindCopperView = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_bindCopperView.move(251,411);
			_bindCopperView.setValue(GlobalData.selfPlayer.userMoney.bindCopper.toString());
			addContent(_bindCopperView);
			
			
			_introList = [
				LanguageManager.getWord("ssztl.furnace.intro1"),
				LanguageManager.getWord("ssztl.furnace.intro2"),
				LanguageManager.getWord("ssztl.furnace.intro4"),
				LanguageManager.getWord("ssztl.furnace.intro5"),
				LanguageManager.getWord("ssztl.furnace.intro6"),
				LanguageManager.getWord("ssztl.furnace.intro7"),
				LanguageManager.getWord("ssztl.furnace.intro8"),
				LanguageManager.getWord("ssztl.furnace.intro3"),
				LanguageManager.getWord("ssztl.furnace.intro9"),
				LanguageManager.getWord("ssztl.furnace.intro10")];

			_labels = [
				LanguageManager.getWord("ssztl.furnace.strengthEquip"),
				LanguageManager.getWord("ssztl.furnace.rebuildEquip"),
				LanguageManager.getWord("ssztl.furnace.equipUplevel"),
				LanguageManager.getWord("ssztl.furnace.equipUpgrade"),
				LanguageManager.getWord("ssztl.furnace.enchaseStone"),
				LanguageManager.getWord("ssztl.furnace.removeStone"),
				LanguageManager.getWord("ssztl.furnace.itemCompose"),
				LanguageManager.getWord("ssztl.furnace.strengthTransformEquip"),
				LanguageManager.getWord("ssztl.furnace.quenchingTabLabel"),
				LanguageManager.getWord("ssztl.furnace.equipFuse")
			];
			_classes = [StrengthTabPanel,RebuildTabPanel,EquipUpLevelTabPanel,EquipUpgradeTabPanel,EnchaseTabPanel,RemoveTabPanel,ComposeTabPanel,StrengthTransformTabPanel,QuenchingTabPanel,EquipFuseTabPanel];
			
			if(!GlobalData.functionYellowEnabled)
			{
				_introList = [
					LanguageManager.getWord("ssztl.furnace.intro1"),
					LanguageManager.getWord("ssztl.furnace.intro2"),
					LanguageManager.getWord("ssztl.furnace.intro4"),
					LanguageManager.getWord("ssztl.furnace.intro5"),
					LanguageManager.getWord("ssztl.furnace.intro6"),
					LanguageManager.getWord("ssztl.furnace.intro7"),
					LanguageManager.getWord("ssztl.furnace.intro8"),
					LanguageManager.getWord("ssztl.furnace.intro3"),
					LanguageManager.getWord("ssztl.furnace.intro10")];
				_labels = [
					LanguageManager.getWord("ssztl.furnace.strengthEquip"),
					LanguageManager.getWord("ssztl.furnace.rebuildEquip"),
					LanguageManager.getWord("ssztl.furnace.equipUplevel"),
					LanguageManager.getWord("ssztl.furnace.equipUpgrade"),
					LanguageManager.getWord("ssztl.furnace.enchaseStone"),
					LanguageManager.getWord("ssztl.furnace.removeStone"),
					LanguageManager.getWord("ssztl.furnace.itemCompose"),
					LanguageManager.getWord("ssztl.furnace.strengthTransformEquip"),
					LanguageManager.getWord("ssztl.furnace.equipFuse")
				];
				_classes = [StrengthTabPanel,RebuildTabPanel,EquipUpLevelTabPanel,EquipUpgradeTabPanel,EnchaseTabPanel,RemoveTabPanel,ComposeTabPanel,StrengthTransformTabPanel,EquipFuseTabPanel];
			}
			
			_btns =[];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,0,_labels[i]);
				btn.move(i * 47 + 15,0);
				_btns.push(btn);
				addContent(btn);
			}
			
			_panels = new Array(_labels.length);
			
			_materialTabPanel = new MaterialPanel(_mediator);
			_materialTabPanel.move(348,271);
			addContent(_materialTabPanel);
			_qualityTabPanel = new QualityPanel(_mediator);
			//选中哪个面板
//			if(_mediator.furnaceModule.toData.selectIndex == 8)
//			{
//				//				fireBoxBtnClickHandler(null);
//			}
//			else
//			{
//				setIndex(_mediator.furnaceModule.toData.selectIndex);
//			}			
			
			_qualityTabPanel.move(348,30);
			addContent(_qualityTabPanel);
			
			
			if(_classes[_currentIndex] == ComposeTabPanel && _qualityTabPanel)
			{
				_qualityTabPanel.setComposeIndex();
			}
			
		}
		
		private function initEvent():void
		{
			for each(var i:MSelectButton in _btns)
			{
				i.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
//			for each(var j:MSelectButton in _refinBtns)
//			{
//				j.addEventListener(MouseEvent.CLICK,refinBtnClickHandler);
//			}
//			_smithingBtn.addEventListener(MouseEvent.CLICK, smithingClickHandler);
//			_refiningBtn.addEventListener(MouseEvent.CLICK, refiningClickHandler);
			_TabBtn2.addEventListener(MouseEvent.CLICK, tabBtnClickHandler);
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			
			_btnHelpExplain.addEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_btnHelpExplain.addEventListener(MouseEvent.MOUSE_OUT,helpTipOutHandler);
		}
		
		private function removeEvent():void
		{
			for each(var i:MSelectButton in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_TabBtn2.removeEventListener(MouseEvent.CLICK, tabBtnClickHandler);
//			for each(var j:MSelectButton in _refinBtns)
//			{
//				j.removeEventListener(MouseEvent.CLICK,refinBtnClickHandler);
//			}
//			_smithingBtn.removeEventListener(MouseEvent.CLICK, smithingClickHandler);
//			_refiningBtn.removeEventListener(MouseEvent.CLICK, refiningClickHandler);
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			
			_btnHelpExplain.removeEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_btnHelpExplain.removeEventListener(MouseEvent.MOUSE_OUT,helpTipOutHandler);
		}		
		private function helpTipOverHandler(e:MouseEvent):void
		{
			if(_introList[_currentIndex])
				TipsUtil.getInstance().show(_introList[_currentIndex],null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function helpTipOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function tabBtnClickHandler(e:MouseEvent):void
		{
//			dispose();
			SetModuleUtils.addFireBox();
//			
			//			SetModuleUtils.addFireBox();
		}
		private function btnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget);
			setIndex(index);
		}
//		private function refinBtnClickHandler(evt:MouseEvent):void
//		{
//			var index:int = _refinBtns.indexOf(evt.currentTarget);
//			setRefiningIndex(index);
//		}
		private function smithingClickHandler(evt:MouseEvent):void
		{	
//			_isSmithing = false;
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].visible = true;
			}
//			_smithingBtn.enabled = false;			
//			_refiningBtn.enabled = true;
			setIndex(_currentIndex);
//			setRefiningIndex(-1);			
//			_refiningPanel.visible = false;			
		}
		
		private function moneyUpdataHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBaoView.setValue(GlobalData.selfPlayer.userMoney.yuanBao.toString());
			_copperView.setValue(GlobalData.selfPlayer.userMoney.copper.toString());
			_bindCopperView.setValue(GlobalData.selfPlayer.userMoney.bindCopper.toString());
		}
		public function getIndex():int
		{
			return _currentIndex;
		}
		public function setIndex(index:int):void
		{
			_qualityTabPanel.setCurrentPage();
			_materialTabPanel.setCurrentPage();
			if(_currentIndex == index)return;
			if(_currentIndex != -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			if(index == -1)return;
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as IFurnaceTabPanel).addAssets();
				}
				_panels[_currentIndex].move(13,30);				
			}
			//如果是合成，直接控制_materialTabPanel选择为背包
			if(_classes[_currentIndex] == ComposeTabPanel && _qualityTabPanel)
			{
				_qualityTabPanel.setComposeIndex();
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
			
			
//			var introInfo:FurnaceIntroInfo = FurnaceIntroList.getIntroInfo(index+1);
//			if(introInfo)
//			{
//				_introField.appendMessage(introInfo.content,introInfo.deployList,introInfo.formatList);
//			}
//			else
//			{
//				_introField.appendMessage("",[],[]);
//			}
//			/**从背包向右边两个面板填充数据**/
//			_mediator.furnaceModule.furnaceInfo.initialFurnaceVector(FurnaceType.FURNACETYPE_ALL_LIST[_currentIndex][0],FurnaceType.FURNACETYPE_ALL_LIST[_currentIndex][1]);
		}
		
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;			
			_labels = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for each(var i:MSelectButton in _btns)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_btns = null;
			_TabBtn1.dispose();
			_TabBtn1 = null;
			_TabBtn2.dispose();
			_TabBtn2 = null;
			_classes = null;
			for(var j:int = 0;j<_panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			
			if(_qualityTabPanel)
			{
				_qualityTabPanel.dispose();
				_qualityTabPanel = null;
			}
			if(_materialTabPanel)
			{
				_materialTabPanel.dispose();
				_materialTabPanel = null;
			}
			if(_defaultBg && _defaultBg.bitmapData)
			{
				_defaultBg.bitmapData.dispose();
				_defaultBg = null;
			}
			GlobalData.furnaceState = 0;
			super.dispose();
		}
	}
}