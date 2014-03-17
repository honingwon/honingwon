package sszt.club.components.clubMain.pop.manage.war
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.labelField.MLabelField;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.club.mediators.ClubWarMediator;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import mhsm.ui.BtnAsset4;
	
	public class WarPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ClubWarMediator;
		private var _btns:Array;
		private var _classes:Array;
		public var currentIndex:int = -1;
		private var _panels:Array;
		private var _descriptionLabel:MAssetLabel;
		private var _descriptionSprite:Sprite;

		private var _beginIndex:int;
		public function WarPanel(argMediator:ClubWarMediator,argIndex:int)
		{
			_mediator = argMediator;
			_beginIndex = argIndex;
			_mediator.clubInfo.initClubWarInfo();
//			super(new Bitmap(new WarTitleAsset()),true,-1);
			initialEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(627,374);
			_bg = BackgroundUtils.setBackground([
									new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,627,374)),
									new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,33,97,334)),
									new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(109,33,512,334)),
									new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(113,37,505,22)),

									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,89,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,123,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,157,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,191,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,225,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,259,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,293,501,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,327,501,2),new MCacheSplit2Line()),
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(11,9,382,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.declearWarTimePrompt"),MAssetLabel.LABELTYPE1)));

			
			_descriptionLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_descriptionLabel.mouseEnabled = _descriptionLabel.mouseWheelEnabled = false;
			_descriptionLabel.move(550,12);
			_descriptionLabel.htmlText = LanguageManager.getWord("ssztl.club.clubDeclearWarIntroduce");
			addContent(_descriptionLabel);
			
			_descriptionSprite = new Sprite();
			_descriptionSprite.graphics.beginFill(0,0);
			_descriptionSprite.graphics.drawRect(515,9,76,17);
			_descriptionSprite.graphics.endFill();
			_descriptionSprite.buttonMode = true;
//			_descriptionSprite.x = 529;
//			_descriptionSprite.y = 9;
//			_descriptionSprite.width = 76;
//			_descriptionSprite.height = 17;
			addContent(_descriptionSprite);
			
			var nameList:Array = [LanguageManager.getWord("ssztl.club.clubDeclearWar"),
				LanguageManager.getWord("ssztl.club.dealDeclearWar"),
				LanguageManager.getWord("ssztl.club.enemyClub")];
			var poses:Array = [new Point(12,46),new Point(12,86),new Point(12,126)];
			_btns = [];
			var tmpBtn:MSelectButton;
			for(var i:int = 0;i < nameList.length;i++)
			{
				tmpBtn = new MSelectButton(new BtnAsset4(),nameList[i],-1,-1,0.75);
				tmpBtn.unselectedTextformat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,true);
				tmpBtn.unselectedFilter = [new GlowFilter(0x274943,1,4,4,6,10)];
				tmpBtn.selectedTextformat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00FE0B,true);
				tmpBtn.selectedFilter = [new GlowFilter(0x274943,1,4,4,6,10)];
				_btns.push(tmpBtn);
				tmpBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				tmpBtn.move(poses[i].x,poses[i].y);
				addContent(tmpBtn);
			}
			
			_classes = [WarDeclearPanel,WarDealPanel,WarEnemyPanel];
			_panels =new Array(nameList.length);
			setIndex(_beginIndex);
		}
		
		public function setIndex(argIndex:int):void
		{
			if(currentIndex == argIndex)return;
			if(currentIndex != -1)
			{
				_btns[currentIndex].selected = false;
				if(_panels[currentIndex])
				{
					_panels[currentIndex].hide();
				}
			}
			currentIndex = argIndex;
			_btns[currentIndex].selected = true;
			if(!_panels[currentIndex])
			{
				_panels[currentIndex] = new _classes[argIndex](_mediator);	
				_panels[currentIndex].move(113,37);
			}
			addContent(_panels[currentIndex]);
			_panels[currentIndex].show();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			setIndex(_btns.indexOf(e.currentTarget as MSelectButton));
		}
		
		private function initialEvents():void
		{
			_descriptionSprite.addEventListener(MouseEvent.CLICK,descirptionSpriteClickHandler);
		}
		
		private function removeEvetns():void
		{
			_descriptionSprite.addEventListener(MouseEvent.CLICK,descirptionSpriteClickHandler);
		}
		
		private function descirptionSpriteClickHandler(e:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.club.clubDeclearWarDescript"),LanguageManager.getWord("ssztl.club.clubDeclearWarDescriptTitle"),4,null,null,TextFormatAlign.LEFT);
		}
		
		override public function dispose():void
		{
			removeEvetns();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			for each(var i:MSelectButton in _btns)
			{
				if(i)
				{
					i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
					i.dispose();
					i = null;
				}
			}
			_btns = null;
			for(var j:int = 0;j < _panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			_classes = null;
			_descriptionLabel = null;
			_descriptionSprite = null;
			super.dispose();
		}
			
	}
}