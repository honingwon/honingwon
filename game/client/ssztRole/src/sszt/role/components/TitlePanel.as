package sszt.role.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.PropertyType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.titles.TitleNameEvents;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.data.titles.TitleTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.role.RoleNameSaveSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.role.components.itemView.TitleItemView;
	import sszt.role.mediator.RoleMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	import ssztui.role.TitleTagAsset1;
	import ssztui.role.TitleTagAsset2;
	import ssztui.role.TitleTagAsset3;

	/**
	 * 角色称号
	 * */
	public class TitlePanel  extends Sprite implements IRolePanelView
	{
		public var info:FigurePlayerInfo = new FigurePlayerInfo();
		public var rolePlayerId:Number;
		private var _roleMediator:RoleMediator;
		private var _bg:IMovieWrapper;
		private var _topBg:Bitmap;
		private var _assetsComplete:Boolean;
		private var _currentTitle:MAssetLabel
		private var _currentTitleName:MAssetLabel
		private var _sureBtn:MCacheAssetBtn1
		private var _cancelBtn:MCacheAssetBtn1
		private var _labels:Array;
		private var _btns:Array;
		private var _currentIndex:int = -1;
		private var _titleViewList:Array;
		private var _itemMTile:MTile;
		private var _currentItem:TitleItemView;
		private var _desTxt:TextField
		private var _charTxt:TextField
		private var _titleImg:Bitmap;
		private var _titleImgBd:BitmapData;
		
		public function TitlePanel(argRoleMediator:RoleMediator,argRolePlayerId:Number,selectIndex:int = 0)
		{
			this._roleMediator = argRoleMediator;
			initialView();
			initTitleData();
			initialTab(selectIndex);
			initialEvents();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,435,75)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(3,77,435,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,85,435,292)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(8,90,190,282)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(201,90,232,95)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(201,188,232,75)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(201,266,232,105)),
				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(204,89,226,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(204,187,226,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(204,265,226,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(286,95,62,15),new Bitmap(new TitleTagAsset1())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(286,193,62,15),new Bitmap(new TitleTagAsset2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(286,271,62,15),new Bitmap(new TitleTagAsset3())),
			]);
			addChild(_bg as DisplayObject);
			
			_topBg = new Bitmap();
			_topBg.x = 5;
			_topBg.y = 5;
			addChild(_topBg);
			
			_currentTitle = new MAssetLabel(LanguageManager.getWord("ssztl.role.titleNow"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_currentTitle.move(66,27);
			addChild(_currentTitle);
			
			_currentTitleName = new MAssetLabel(LanguageManager.getWord("ssztl.role.noTitle"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_currentTitleName.move(135,27);
			addChild(_currentTitleName);
			
			_sureBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.role.useTitle"));
			_sureBtn.move(306,21);
			_sureBtn.visible = true;
			_sureBtn.enabled = false;
			addChild(_sureBtn);
			
			_cancelBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.role.cancelTitle"));
			_cancelBtn.move(306,21);
			_cancelBtn.visible = false;
			addChild(_cancelBtn);
			
			if(GlobalData.selfPlayer.title!=0)
			{
				_currentTitleName.setHtmlValue(TitleTemplateList.getTitle(GlobalData.selfPlayer.title).name);
				_cancelBtn.visible = true;
				_sureBtn.visible = false;
			}
			
			_desTxt = new TextField();
			_desTxt.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x42ff00,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,6);
			_desTxt.mouseEnabled = _desTxt.mouseWheelEnabled = false;
			_desTxt.width = 208;
			_desTxt.height = 70;
			_desTxt.x = 213;
			_desTxt.y = 294;
			_desTxt.wordWrap = _desTxt.multiline = true;
			addChild(_desTxt);
			
			_charTxt = new TextField();
			_charTxt.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xecd099,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,6);
			_charTxt.mouseEnabled = _charTxt.mouseWheelEnabled = false;
			_charTxt.width = 208;
			_charTxt.height = 40;
			_charTxt.x = 213;
			_charTxt.y = 217;
			_charTxt.wordWrap = _charTxt.multiline = true;
			addChild(_charTxt);
			
			_itemMTile = new MTile(185,27);
			_itemMTile.itemGapH = _itemMTile.itemGapW = 0;
			_itemMTile.setSize(185,272);
			_itemMTile.move(11,97);
			addChild(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_itemMTile.verticalScrollBar.lineScrollSize = 26;
			
			
			_titleImg = new Bitmap();
			_titleImg.x =191;
			_titleImg.y = 112;
			addChild(_titleImg);
			
			_titleViewList = [];
		}
		
		private function initTitleData(type:int=0):void
		{
			_itemMTile.disposeItems();
			clearCells();
			if(type==0)
			{
				for each(var ownTitle:TitleTemplateInfo in GlobalData.titleInfo.allTitles)
				{
						var ownTitleView:TitleItemView = new TitleItemView(ownTitle);
						_itemMTile.appendItem(ownTitleView);
						_titleViewList.push(ownTitleView);
				}
			}
			else
			{
				for each(var title:TitleTemplateInfo in TitleTemplateList.titles)
				{
					if(title.type==type)
					{
						var titleView:TitleItemView = new TitleItemView(title);
						_itemMTile.appendItem(titleView);
						_titleViewList.push(titleView);
					}
				}
			}
		
//			if(_titleViewList.length>0)
//			{
//				switchTo(_titleViewList[0]);
//			}
		}
		private function switchTo(tv:TitleItemView):void
		{
			if(_currentItem)
				_currentItem.selected = false;
			_currentItem = tv;
			_currentItem.selected = true;
			updateView();
		}
		
		private function updateView():void
		{
			if(_currentItem==null)return;
			_cancelBtn.enabled = true;
			_sureBtn.enabled = true;
			clearCells();
			_currentTitleName.setHtmlValue(_currentItem.titleIfo.name);
			_charTxt.htmlText=  _currentItem.titleIfo.descript;
			_desTxt.htmlText= setCharTxt(_currentItem.titleIfo.effects);
			_titleImgBd = AssetUtil.getAsset(_currentItem.titleIfo.pic) as BitmapData;
			_titleImg.bitmapData = _titleImgBd;
			if(GlobalData.selfPlayer.title == _currentItem.titleIfo.id)
			{
				_cancelBtn.visible = true;
				_sureBtn.visible = false;
			}
			else
			{
				if(_currentItem.enabled)
				{
					_cancelBtn.visible = false;
					_sureBtn.visible = true;
				}
				else
				{
					if(GlobalData.selfPlayer.title)
					{
						_cancelBtn.visible = true;
						_sureBtn.visible = false;
						_cancelBtn.enabled = false;
						_currentTitleName.setHtmlValue(TitleTemplateList.getTitle(GlobalData.selfPlayer.title).name);
					}
					else
					{
						_cancelBtn.visible = false;
						_sureBtn.visible = true;
						_sureBtn.enabled = false;
						_currentTitleName.setHtmlValue(LanguageManager.getWord("ssztl.role.noTitle"));
					}
				}
			
			}
		}
		
		private function setCharTxt(str:String):String
		{
			var result:String = "";
			var array1:Array = new Array();
			var array2:Array = new Array();
			var i:int;
			if(str != null && str != "")
			{
				array1 = str.split("|");
				for(i =0; i < array1.length; i++)
				{
					array2 = array1[i].split(",");
					if(array2[1] != 0)
					{
						if(result.length > 1)result += "\n";
						result += PropertyType.getName(array2[0]).toString() + "+"+array2[1];
					}
				}
			}
			return result;
		}
		
		private function clearCells():void
		{
			_charTxt.htmlText = "";
			_desTxt.htmlText = "";
			_titleImg.bitmapData = null;
		}
		private function initialTab(selectIndex:int):void
		{
			_labels = [LanguageManager.getWord("ssztl.role.haveTitle"),
				LanguageManager.getWord("ssztl.role.nomalTitle"),
				LanguageManager.getWord("ssztl.role.rankTitle"),
				LanguageManager.getWord("ssztl.role.beatTitle"),
				LanguageManager.getWord("ssztl.role.toolTitle")
			];			
			
			var poses:Array = [new Point(10,59),new Point(79,59),new Point(148,59),new Point(217,59),new Point(286,59)];
			_btns = new Array();
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(poses[i].x,poses[i].y);
				addChild(btn);
				_btns.push(btn);
				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			setIndex(selectIndex);
		}
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			_currentIndex = index;
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].selected = false;
			}
			_btns[_currentIndex].selected = true;
			initTitleData(_currentIndex);
		}
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
//			updateView();
			initialEvents();
		}
		
		
		private function initialEvents():void
		{
			for(var i:int = 0; i < _titleViewList.length; i++)
			{
				TitleItemView(_titleViewList[i]).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_sureBtn.addEventListener(MouseEvent.CLICK,saveTile);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelTile);
			GlobalData.selfPlayer.addEventListener(TitleNameEvents.TITLE_NAME_CHANGE,updateTitleHandler);
			
		}
		private function updateTitleHandler(evt:TitleNameEvents):void
		{
			updateView();
		}
		private function itemClickHandler(evt:MouseEvent):void
		{
			var target:TitleItemView = evt.currentTarget as TitleItemView;
			if(_currentItem == target) return;
			switchTo(target);
		}
		private function saveTile(evt:MouseEvent):void
		{
			if(_currentItem.titleIfo.id)
				RoleNameSaveSocketHandler.sendSave(_currentItem.titleIfo.id,false);
		}
		private function cancelTile(evt:MouseEvent):void
		{
			RoleNameSaveSocketHandler.sendSave(0,false);
		}
		private function removeEvents():void
		{
			for(var i:int = 0; i < _titleViewList.length; i++)
			{
				TitleItemView(_titleViewList[i]).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_sureBtn.removeEventListener(MouseEvent.CLICK,saveTile);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelTile);
			GlobalData.selfPlayer.removeEventListener(TitleNameEvents.TITLE_NAME_CHANGE,updateTitleHandler);
		}
		
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function assetsCompleteHandler():void
		{
			_topBg.bitmapData = AssetUtil.getAsset("ssztui.role.TitleBgAsset",BitmapData) as BitmapData;
		}
		public function show():void
		{
//			if(_roleMediator.roleModule.assetsReady)
//			{
//				assetsCompleteHandler();
//			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			hide();
			if(_topBg && _topBg.bitmapData)
			{
				_topBg.bitmapData.dispose();
				_topBg = null;
			}
			removeEvents();
		}
	}
}