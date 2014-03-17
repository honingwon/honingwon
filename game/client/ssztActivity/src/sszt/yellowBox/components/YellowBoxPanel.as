package sszt.yellowBox.components
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.openActivity.YellowBoxTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.openActivity.YellowBoxGetRewardSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.YellowBoxEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	import sszt.yellowBox.mediator.YellowBoxMediator;
	
	import ssztui.ui.SplitCompartLine2;
	import ssztui.yellowVip.BtnAllGetAsset;
	import ssztui.yellowVip.BtnPayAsset1;
	import ssztui.yellowVip.BtnPayAsset12;
	import ssztui.yellowVip.BtnPayAsset2;
	import ssztui.yellowVip.BtnPayAsset22;
	import ssztui.yellowVip.BtnPayAsset3;
	import ssztui.yellowVip.BtnPayAsset32;
	import ssztui.yellowVip.TitleAsset;
	
	
	public class YellowBoxPanel extends MPanel implements ITick
	{
		
		private var _bg:IMovieWrapper;
		private var _mediator:YellowBoxMediator;
		
		/**
		 * 当前选择的活动类型  1、"新手礼包",2、"每日礼包",3、"豪华礼包",4、"升级礼包"
		 */
		private var _currentIndex:int = -1;
		private var _lables:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		
		
		private var _getedRewardBtn:MAssetButton1;
		
		/**
		 * 开通黄钻 
		 */
		private var _openYellowBtn:MAssetButton1;
		/**
		 * 开通年费黄钻 
		 */
		private var _openYearYellowBtn:MAssetButton1;
		/**
		 * 开通豪华黄钻 
		 */
		private var _openLuxBtn:MAssetButton1;
		
		private var assetsReady:Boolean;
		
		/**
		 * 当前领取黄钻类型 0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包 
		 */		
		private var _currentType:int = 0;
		
		public function YellowBoxPanel(mediator:YellowBoxMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new TitleAsset() as BitmapData)),true,-1,true,true);
			_mediator = mediator;
			initView();
			initEvent();
			initData();
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			setContentSize(598,367);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,27,582,332)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,31,574,264)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,294,574,25),new Bitmap(new SplitCompartLine2())),
			]); 
			addContent(_bg as DisplayObject);
			_lables = [LanguageManager.getWord("ssztl.yellowBox.newHand"),LanguageManager.getWord("ssztl.yellowBox.everyDay"),LanguageManager.getWord("ssztl.yellowBox.luxGif"),LanguageManager.getWord("ssztl.yellowBox.levelUp")];
			_classes = [NewHandGift,EveryDayGift,LuxGift,LevelUpGift];
			_btns = [];
			_panels = [];
			for(var i:int = 0;i<_classes.length;i++)
			{
				var item:MCacheTabBtn1 = new MCacheTabBtn1(0,3,_lables[i]);
				item.move(15+85*i,2);
				addContent(item);
				_btns.push(item);
			}
		}
		
		private function initView():void
		{
			_getedRewardBtn = new MAssetButton1(new BtnAllGetAsset() as MovieClip);
			_getedRewardBtn.move(69,308);
			addContent(_getedRewardBtn);
			
			/**
			 * 设置续费
			 */	
			
			if(GlobalData.tmpIsYellowVip == 1)
				_openYellowBtn = new MAssetButton1(new BtnPayAsset12() as MovieClip);
			else
				_openYellowBtn = new MAssetButton1(new BtnPayAsset1() as MovieClip);
			_openYellowBtn.move(284,305);
			addContent(_openYellowBtn);
			
			if(GlobalData.tmpIsYellowYearVip == 1)
				_openYearYellowBtn = new MAssetButton1(new BtnPayAsset22() as MovieClip);
			else
				_openYearYellowBtn = new MAssetButton1(new BtnPayAsset2() as MovieClip);
			_openYearYellowBtn.move(421,305);
			addContent(_openYearYellowBtn);
			
			if(GlobalData.tmpIsYellowHighVip == 1)
				_openLuxBtn = new MAssetButton1(new BtnPayAsset32() as MovieClip);
			else
				_openLuxBtn = new MAssetButton1(new BtnPayAsset3() as MovieClip);
			_openLuxBtn.move(380,305);
			addContent(_openLuxBtn);
			
			setIndex(0);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			getCurrentType(_currentIndex);
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](0);
				_panels[_currentIndex].move(12,31);
				if(assetsReady)
					_panels[_currentIndex].assetsCompleteHandler();
			}
			addContent(_panels[_currentIndex]);
			_panels[_currentIndex].show();
			
			_openLuxBtn.visible = false;
			if(argIndex == 1 || argIndex == 3)
			{
				_getedRewardBtn.visible = true;
				_openYellowBtn.x = 284;
				_openYearYellowBtn.x = 421;
			}else
			{
				_getedRewardBtn.visible = false;
				_openYellowBtn.x = 148;
				_openYearYellowBtn.x = 290;
				
				if(argIndex == 2){
					_openYellowBtn.x = 68;
					_openYearYellowBtn.x = 210;
					_openLuxBtn.visible = true;
				}
			}
			
		}
		
		private function getCurrentType(currentIndex:int):void
		{
			switch(currentIndex)
			{
				case 0:
					YellowBoxUtils.currentType = 2;
					break;
				case 1:
					YellowBoxUtils.currentType = 0;
					break;
				case 2:
					YellowBoxUtils.currentType = 5;
					break;
				case 3:
					YellowBoxUtils.currentType = 1;
					break;
			}
			_currentType =  YellowBoxUtils.currentType;
			setData();
		}
		
		private function setData():void
		{
			switch(YellowBoxUtils.currentType)
			{
				case 0:
					if(GlobalData.yellowBoxInfo.receDayPack > 0 || GlobalData.tmpIsYellowVip == 0)
					{
						_getedRewardBtn.enabled = false;
					}
					else
					{
						_getedRewardBtn.enabled = true;
					}
					break;
				case 1:
					if(GlobalData.tmpIsYellowVip == 0)
					{
						_getedRewardBtn.enabled = false;
					}
					else
					{
						if(getLevlUp(GlobalData.yellowBoxInfo.levelUpPack))
						{
							_getedRewardBtn.enabled = true;
						}
						else
						{
							_getedRewardBtn.enabled = false;
						}
					}
					break;
				case 2:
					if(GlobalData.yellowBoxInfo.isReceNewPack || GlobalData.tmpIsYellowVip == 0)
					{
						_getedRewardBtn.enabled = false;
					}
					else
					{
						_getedRewardBtn.enabled = true;
					}
					break;
				case 5:
					_getedRewardBtn.enabled = false;
					break;
			}
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_getedRewardBtn.addEventListener(MouseEvent.CLICK,getRewardClick);
			_openYellowBtn.addEventListener(MouseEvent.CLICK,openYClick);
			_openYearYellowBtn.addEventListener(MouseEvent.CLICK,openYYClick);
			_openLuxBtn.addEventListener(MouseEvent.CLICK,openLuxClick);
			
			ModuleEventDispatcher.addModuleEventListener(YellowBoxEvent.GET_INFO,yellowBoxInfo);
			ModuleEventDispatcher.addModuleEventListener(YellowBoxEvent.GET_AWARD,getAwardPanel);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget);
			if(_currentIndex == index)
			{
				return;
			}
			setIndex(index);
		}
		
		private function getRewardClick(e:MouseEvent):void
		{
			YellowBoxGetRewardSocketHandler.send(YellowBoxUtils.currentType);
		}
		
		private function openYClick(e:MouseEvent):void
		{
			JSUtils.gotoPayYellow();
		}
		
		private function openYYClick(e:MouseEvent):void
		{
			JSUtils.gotoPayYellowYeay();
		}
		
		private function openLuxClick(e:MouseEvent):void
		{
			JSUtils.gotoPayYellow();
		}
		
		private function yellowBoxInfo(evt:ModuleEvent):void
		{
			setData();
		}
		
		private function getAwardPanel(evt:ModuleEvent):void
		{
			//0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包
			switch(_currentIndex)
			{
				case 0:
//					YellowBoxUtils.currentType = 2;
					if(int(evt.data.type) == 2)
					{
						_getedRewardBtn.enabled = false;
					}
					break;
				case 1:
//					YellowBoxUtils.currentType = 0;
					if(int(evt.data.type) == 0 || int(evt.data.type) == 3)
					{
						_getedRewardBtn.enabled = false;
					}
					break;
				case 2:
//					YellowBoxUtils.currentType = 5;
					if(int(evt.data.type) == 5)
					{
						_getedRewardBtn.enabled = false;
					}
					break;
				case 3:
//					YellowBoxUtils.currentType = 1;
					if(int(evt.data.type) == 1 || int(evt.data.type) == 4)
					{
						if(getLevlUp(GlobalData.yellowBoxInfo.levelUpPack))
						{
							_getedRewardBtn.enabled = true;
						}
						else
						{
							_getedRewardBtn.enabled = false;
						}
						
					}
					break;
			}
		}
		
		private function getLevlUp(returnLevel:int=0):Boolean
		{
			var isReturn:Boolean = false;
			var templateObj:YellowBoxTemplateListInfo;
			var temArray:Array = YellowBoxUtils.getYellowBoxArray(1);
			for(var i:int=0;i<temArray.length;i++)
			{
				templateObj = temArray[i];
				if(templateObj.level > returnLevel && GlobalData.selfPlayer.level >= templateObj.level)
				{
					isReturn = true;
				}
			}
			return isReturn;
		}
		
		private function initData():void
		{
			if(GlobalData.tmpIsYellowVip == 1)
			{
//				_openYellowBtn.enabled = false;
			}
			
			if(GlobalData.tmpIsYellowYearVip == 1)
			{
//				_openYearYellowBtn.enabled = false;
			}
			
//			if(GlobalData.tmpIsYellowHighVip == 1)
//			{
//				_openLuxBtn.enabled = false;
//			}
			
			setData();
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_getedRewardBtn.addEventListener(MouseEvent.CLICK,getRewardClick);
			_openYellowBtn.removeEventListener(MouseEvent.CLICK,openYClick);
			_openYearYellowBtn.removeEventListener(MouseEvent.CLICK,openYYClick);
			_openLuxBtn.removeEventListener(MouseEvent.CLICK,openLuxClick);
			
			ModuleEventDispatcher.removeModuleEventListener(YellowBoxEvent.GET_INFO,yellowBoxInfo);
			ModuleEventDispatcher.removeModuleEventListener(YellowBoxEvent.GET_AWARD,getAwardPanel);
		}
		
		override public function dispose():void
		{
			_mediator = null;
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for(var i:int = 0;i<_panels.length;i++)
			{
				if(_panels[i])
				{
					_panels[i].dispose();
					_panels[i] = null;
				}
			}
			_classes = null;
			_btns = null;
			_panels = null;
			super.dispose();
		}
		
		public function assetsCompleteHandler():void
		{
			assetsReady = true;
			for(var i:int=0; i<_panels.length; i++)
			{
				_panels[i].assetsCompleteHandler();
			}
		}
	}
}