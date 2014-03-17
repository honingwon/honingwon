package sszt.personal.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemArrangeSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import mhsm.personal.LuckyBigFlowerAsset;
	import mhsm.personal.LuckySelectAsset;
	import mhsm.personal.LuckySmallFlowerAsset;
	import mhsm.personal.LuckyStartBtnAsset;
	import mhsm.personal.LuckyWeelAsset;
	import mhsm.personal.LuckyWheelTitleAsset;
	import sszt.personal.components.itemView.PersonalLuckyItemView;
	import sszt.personal.data.PersonalPartInfo;
	import sszt.personal.data.PersonalPartLuckyInfo;
	import sszt.personal.events.PersonalPartUpdateEvents;
	import sszt.personal.mediators.PersonalMediator;
	
	public class PersonalLuckyWheelPanel extends MPanel implements ITick
	{
		private var _mediator:PersonalMediator;
		private var _bg:IMovieWrapper;
		private var _startBtn:MBitmapButton;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,8);
		private var _poses:Array = [new Point(113,37),new Point(168,61),new Point(190,114),new Point(168,167),new Point(113,192),new Point(59,167),new Point(35,114),new Point(59,61)];
		private var _selectSprite:Bitmap;
		private var _currentIndex:int;
		//帧率总数
		private var _count:int;
		private var _itemList:Array;
		private var _userId:Number;
		
		public function PersonalLuckyWheelPanel(argMediator:PersonalMediator,argUserId:Number)
		{
			_mediator = argMediator;
			_userId = argUserId;
			super(new MCacheTitle1("",new Bitmap(new LuckyWheelTitleAsset())),true,-1);
			personalPartInfo.initPersonalPartLuckyInfo();
			initEvents();
			_mediator.sendLuckyList();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(514,282);
			_bg = BackgroundUtils.setBackground([
																		new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,514,282)),
																		new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,6,269,269)),
																		new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(280,6,229,269)),
																		new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(292,60,216,214),new Bitmap(new LuckyBigFlowerAsset()))
			]);
			addContent(_bg as DisplayObject);
			
			var _descriptionLabel:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_descriptionLabel.move(290,28);
			_descriptionLabel.width = 215;
			_descriptionLabel.defaultTextFormat = LABEL_FORMAT;
			_descriptionLabel.setTextFormat(LABEL_FORMAT);
			_descriptionLabel.wordWrap = true;
			_descriptionLabel.multiline = true;
			addContent(_descriptionLabel);
//			_descriptionLabel.htmlText = "游戏说明：\n\n1.每次开启轮盘需要扣除30点体力值。\n2.每日首次开启轮盘不需要体力值。\n3.体力可以通过在线时间获得，也可以在个人中心动态完成各种共享活动获得。";
			_descriptionLabel.htmlText = LanguageManager.getWord("ssztl.navigation.luckyWheelExplain");
			
			var flower1:Bitmap = new Bitmap(new LuckySmallFlowerAsset());
			flower1.x = 8;
			flower1.y = 13;
			addContent(flower1);
			var flower2:Bitmap = new Bitmap(new LuckySmallFlowerAsset());
			flower2.scaleX = -1;
			flower2.x = 274;
			flower2.y = 13;
			addContent(flower2);
			var flower3:Bitmap = new Bitmap(new LuckySmallFlowerAsset());
			flower3.scaleY = -1;
			flower3.x = 8;
			flower3.y = 271;
			addContent(flower3);
			var flower4:Bitmap = new Bitmap(new LuckySmallFlowerAsset());
			flower4.scaleX = -1;
			flower4.scaleY = -1;
			flower4.x = 274;
			flower4.y = 271;
			addContent(flower4);
			
			var luckyWheel:Bitmap = new Bitmap(new LuckyWeelAsset());
			luckyWheel.x = 15;
			luckyWheel.y = 16;
			addContent(luckyWheel);
			
//			(Math.floor((4-2+1)*Math.random()+2)
			_currentIndex = Math.floor((7-0+1)*Math.random()+0);
			_selectSprite = new Bitmap(new LuckySelectAsset());
			_selectSprite.x = _poses[_currentIndex].x;
			_selectSprite.y = _poses[_currentIndex].y;
			addContent(_selectSprite);
			
			_startBtn = new MBitmapButton(new LuckyStartBtnAsset());
			_startBtn.move(95,96);
			addContent(_startBtn);
			
			_itemList = [];
			for(var i:int =0;i < _poses.length;i++)
			{
				var tempLuckyItem:PersonalLuckyItemView = new PersonalLuckyItemView();
				tempLuckyItem.move(_poses[i].x + 10,_poses[i].y + 10);
				addContent(tempLuckyItem);
				_itemList.push(tempLuckyItem);
			}
		}
		
		private function initEvents():void
		{
			_startBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			luckyInfo.addEventListener(PersonalPartUpdateEvents.LUCKYLIST_UPDATE,luckyListUpdateHandler);
			luckyInfo.addEventListener(PersonalPartUpdateEvents.LUCKYSELECT_UPDATE,luckySelectUpdateHandler);
		}
		
		private function removeEvents():void
		{
			_startBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			luckyInfo.removeEventListener(PersonalPartUpdateEvents.LUCKYLIST_UPDATE,luckyListUpdateHandler);
			luckyInfo.removeEventListener(PersonalPartUpdateEvents.LUCKYSELECT_UPDATE,luckySelectUpdateHandler);
		}
		
		private function luckyListUpdateHandler(e:PersonalPartUpdateEvents):void
		{
			clearList();
			for(var i:int = 0;i < luckyInfo.luckyTemplateIdList.length;i++)
			{
				_itemList[i].info = ItemTemplateList.getTemplate(luckyInfo.luckyTemplateIdList[i]);
			}
		}
		
		private function luckySelectUpdateHandler(e:PersonalPartUpdateEvents):void
		{
//			startWheel();
		}
		
		private function clearList():void
		{
			for(var i:int = 0;i < _itemList.length;i++)
			{
				_itemList[i].info = null;
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
//				QuickTips.show("背包已满！！");
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			GlobalAPI.tickManager.addTick(this);
			_mediator.sendLuckySelect();
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(luckyInfo.selectTemplateId == -1)
			{
				_currentIndex +=Math.floor((3-2+1)*Math.random()+2);
				if(_currentIndex >=_poses.length)
				{
					_currentIndex = 0;	
				}
				_selectSprite.x = _poses[_currentIndex].x;
				_selectSprite.y = _poses[_currentIndex].y;
			}
			else if(luckyInfo.selectTemplateId == 0)
			{
				GlobalAPI.tickManager.removeTick(this);
			}
			else
			{
				startWheel();
			}
		}
		
		private function startWheel():void
		{
			//---------控制随机、快慢----------------//
			_count++;
			if(_count < 10)
			{
				_currentIndex +=Math.floor((3-2+1)*Math.random()+2);
			}
			else if(10<=_count && _count<20)
			{
				_currentIndex +=Math.floor((2-1+1)*Math.random()+1);
			}
			else
			{
				_currentIndex++;
			}
			//-------------------//
			if(_currentIndex >=_poses.length)
			{
				_currentIndex = 0;	
			}
			_selectSprite.x = _poses[_currentIndex].x;
			_selectSprite.y = _poses[_currentIndex].y;
			
			//------控制时长--------//
			if(_count > 80)
			{
				if(_currentIndex == getSelectIndex())
				{
					_count = 0;
					GlobalAPI.tickManager.removeTick(this);
//					QuickTips.show("恭喜您获得："+_itemList[_currentIndex].info.name);
					QuickTips.show(LanguageManager.getWord("ssztl.common.gain")+_itemList[_currentIndex].info.name);
				}
			}
		}
		
		private function getSelectIndex():int
		{
			for(var i:int = 0;i< _itemList.length;i++)
			{
				if(_itemList[i] && (_itemList[i].info.templateId == luckyInfo.selectTemplateId))
				{
					return i;
				}
			}
			return 0;
		}
		
		private function get luckyInfo():PersonalPartLuckyInfo
		{
			return personalPartInfo.personalPartLuckyInfo;
		}
		
		private function get personalPartInfo():PersonalPartInfo
		{
			return _mediator.personalModule.personalInfoList[_userId];
		}
		
		
		override public function dispose():void
		{
			removeEvents();
			GlobalAPI.tickManager.removeTick(this);
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_startBtn)
			{
				_startBtn.dispose();
				_startBtn = null;
			}
			_selectSprite = null;
			for(var i:int = 0;i<_itemList.length;i++)
			{
				if(_itemList[i])
				{
					_itemList[i].dispose();
					_itemList[i] = null;
				}
			}
			_itemList = null;
			super.dispose();
		}
	}
}