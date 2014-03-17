package sszt.openActivity.components
{
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
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.JSUtils;
	import sszt.events.ActivityEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.mediator.OpenActivityMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.openServer.BgAsset;
	import ssztui.openServer.BtnPayAsset;
	import ssztui.openServer.TitleAsset;
	
	
	public class OpenActivityPanel extends MPanel implements ITick
	{
		private var _bg:IMovieWrapper;
		private var _mediator:OpenActivityMediator;
		
		/**
		 * 当前选择的活动类型  1:"充值礼包"，2："消费礼包",3："冲级礼包"
		 */
		private var _currentIndex:int = -1;
		private var _btns:Array;
		private var _classes:Array = [];
		private var _panels:Array;
		
		private var _itemTile:MTile;
		
		/**
		 * 开服活动 groupId
		 */		
		private var _openActType:Array = [1,3,4,5,6,7];
		
		/**
		 * 是否已经加过类型7的开服活动 
		 */
		private var _isAddType7:Boolean = false;
		
		private var _index:Array = [];
		
		private var _btnPay:MAssetButton1;
		
		private var _tagLable:MAssetLabel;
		public static var tfStyle:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),12,0xd9ad60,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,6);
		public static var titleStyle:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),16,0xffcc00,true);
		
		public function OpenActivityPanel(mediator:OpenActivityMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new TitleAsset() as BitmapData)),true,-1,true,true);
			_mediator = mediator;
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,openServerDataHandler);
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			setContentSize(618,405);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,602,395)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,170,387)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(184,6,422,387)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(186,8,418,169),new Bitmap(new BgAsset())),
				
				new BackgroundInfo(
					BackgroundType.DISPLAY,new Rectangle(199,71,60,18),
					new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime") + "：\n" +LanguageManager.getWord("ssztl.activity.activityIntroduce") + "：",[tfStyle],TextFormatAlign.LEFT)
				),
			]);
			addContent(_bg as DisplayObject);
			
			_itemTile = new MTile(157,52,1);
			_itemTile.setSize(170,378);
			_itemTile.move(19,13);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemTile.verticalScrollPolicy =  ScrollPolicy.AUTO;
			addContent(_itemTile);
			
			_btnPay = new MAssetButton1(new BtnPayAsset() as MovieClip);
			_btnPay.move(296,6);
//			addContent(_btnPay);
			_btnPay.addEventListener(MouseEvent.CLICK,toPay);
			
			_classes = [PayTagView,ConsumTagView,SingleRecharge,MakeMyVip,PurpleEquipment,RoleLevelUp];
			_btns = [];
			_panels = [];
			
		}
		
		private function openServerDataHandler(evt:ModuleEvent):void
		{
			
			selectData();
			
			initData();
		}
		
		private function selectData():void
		{
			var now:int = GlobalData.systemDate.getSystemDate().valueOf()*0.001;
			var tempDic:Dictionary = GlobalData.openActivityInfo.activityDic;
			for each(var obj:Object in tempDic)
			{
				var groupId:int = obj.groupId;
				if(groupId > 10) groupId = groupId / 10;
				
				var value:int = _openActType.indexOf(groupId);
				if(value != -1)
				{
					if(int(obj.openTime) > now)
					{
						if(_index.indexOf(value) == -1)
							_index.push(value);
					}
				}
			}
			_index.sort();
		}

		private function initData():void
		{
			removeEvent();
			clearData();
			
			for(var i:int = 0;i< _classes.length ; i++)
			{
				var index:int = _index.indexOf(i);
				if(index != -1)
				{
					var item:IndexItemView = new IndexItemView(_openActType[_index[index]]);
					_itemTile.appendItem(item);
					_btns.push(item);
				}
			}
			if(_btns.length ==0) return;
			initEvent();
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
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[ _index[_currentIndex]](_mediator);
				_panels[_currentIndex].move(184,6);
			}
			addContent(_panels[_currentIndex]);
			_panels[_currentIndex].show();
			_panels[_currentIndex].addChild(_btnPay);
		}
		
		
		private function initEvent():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		
		private function removeEvent():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
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
		
		private function toPay(evt:MouseEvent):void
		{
			JSUtils.gotoFill();
		}
		
		public function assetsCompleteHandler():void
		{
		}

		
		public function clearData():void
		{
			var i:int = 0;
			if (_btns)
			{
				while (i < _btns.length)
				{
					
					_btns[i].dispose();
					i++;
				}
				_btns = [];
			}
			if(_itemTile)
			{
				_itemTile.clearItems();
			}
		}
		
		override public function dispose():void
		{
			_mediator = null;
			_btnPay.removeEventListener(MouseEvent.CLICK,toPay);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,openServerDataHandler);
			removeEvent();
			clearData();
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

	}
}