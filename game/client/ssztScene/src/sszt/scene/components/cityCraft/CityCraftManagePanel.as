package sszt.scene.components.cityCraft
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.core.data.cityCraft.CityCraftGuardItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.cityCraft.CityCraftBuyGuardSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftChangeGuardPositionSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftDeleteGuardSocketHandler;
	import sszt.scene.socketHandlers.cityCraft.CityCraftGuardInfoSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class CityCraftManagePanel extends MPanel
	{
		public static const GUARD_TYPE:Array = ["无","青铜守卫","白银守卫","黄金守卫"];
		public static const GUARD_POSITION:Array = ["1号位","2号位","3号位","4号位","5号位","6号位","7号位","8号位","9号位","10号位"];
		public static const GUARD_POINT:Array = 
		   [new Point(20,200),
			new Point(40,250),
			new Point(60,300),
			new Point(80,350),
			new Point(100,400),
			new Point(120,200),
			new Point(140,250),
			new Point(160,301),
			new Point(180,351),
			new Point(200,401)];
		private var _guardViews:Array;
		private var _bg:IMovieWrapper;
		private var _bgImg:Bitmap;
		
		private var _buyBtn:MCacheAssetBtn1;
		private var _changeBtn:MCacheAssetBtn1;	
		private var _deleteBtn:MCacheAssetBtn1;		
		
		private var _mediator:SceneMediator;
		private var _buyTypeCombox:ComboBox;
		private var _positionCombox1:ComboBox;
		private var _positionCombox2:ComboBox;
		
		public function CityCraftManagePanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap()),true,-1);
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(394,422);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,378,412)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,370,404)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgImg = new Bitmap();
			_bgImg.x = 14;
			_bgImg.y = 8;
			addContent(_bgImg);
			
			_buyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.cityCraft.addGuard'));
			_buyBtn.move(100,20);
			addContent(_buyBtn);
			
			_changeBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.cityCraft.updateGuard'));
			_changeBtn.move(300,60);
			addContent(_changeBtn);
			
			_deleteBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.cityCraft.deleteGuard'));
			_deleteBtn.move(100,80);
			addContent(_deleteBtn);
			
			_buyTypeCombox = new ComboBox();
			_buyTypeCombox.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_buyTypeCombox.x = 20;
			_buyTypeCombox.y = 20;
			_buyTypeCombox.width = 78;
			_buyTypeCombox.height = 22;
			addContent(_buyTypeCombox);
			_buyTypeCombox.dataProvider = new DataProvider([{label:"青铜守卫",value:1},
				{label:"白银守卫",value:2},
				{label:"黄金守卫",value:3}]);
			_buyTypeCombox.selectedIndex = 0;
			
			
			_positionCombox1 = new ComboBox();
			_positionCombox1.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_positionCombox1.x = 20;
			_positionCombox1.y = 60;
			_positionCombox1.width = 78;
			_positionCombox1.height = 22;
			addContent(_positionCombox1);
			_positionCombox1.dataProvider = new DataProvider([{label:"1号位",value:1},
				{label:"2号位",value:2},
				{label:"3号位",value:3},
				{label:"4号位",value:4},
				{label:"5号位",value:5},
				{label:"6号位",value:6},
				{label:"7号位",value:7},
				{label:"8号位",value:8},
				{label:"9号位",value:9},
				{label:"10号位",value:10}]);
			_positionCombox1.selectedIndex = 0;
			
			
			_positionCombox2 = new ComboBox();
			_positionCombox2.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_positionCombox2.x = 160;
			_positionCombox2.y = 60;
			_positionCombox2.width = 78;
			_positionCombox2.height = 22;
			addContent(_positionCombox2);
			_positionCombox2.dataProvider = new DataProvider([{label:"1号位",value:1},
				{label:"2号位",value:2},
				{label:"3号位",value:3},
				{label:"4号位",value:4},
				{label:"5号位",value:5},
				{label:"6号位",value:6},
				{label:"7号位",value:7},
				{label:"8号位",value:8},
				{label:"9号位",value:9},
				{label:"10号位",value:10}]);
			_positionCombox2.selectedIndex = 0;
			
			_guardViews = new Array();
			var guardview:GuardView;
			var point:Point;
			var i:int=0;
			for(;i<GUARD_POSITION.length;i++)
			{
				guardview = new GuardView(GUARD_POSITION[i]);
				point = GUARD_POINT[i];
				guardview.move(point.x,point.y);
				addContent(guardview);
				_guardViews.push(guardview);
			}
		}
		
		private function initEvent():void
		{
			GlobalData.cityCraftInfo.addEventListener(CityCraftEvent.GUARD_UPDATE,guardUpdateHandler);
			CityCraftGuardInfoSocketHandler.send();
			_buyBtn.addEventListener(MouseEvent.CLICK,buyBtnClickHandler);
			_deleteBtn.addEventListener(MouseEvent.CLICK,deleteBtnClickHandler);	
			_changeBtn.addEventListener(MouseEvent.CLICK,changeBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_buyBtn.removeEventListener(MouseEvent.CLICK,buyBtnClickHandler);
			_changeBtn.removeEventListener(MouseEvent.CLICK,changeBtnClickHandler);			
			_deleteBtn.removeEventListener(MouseEvent.CLICK,deleteBtnClickHandler);	
			GlobalData.cityCraftInfo.removeEventListener(CityCraftEvent.GUARD_UPDATE,guardUpdateHandler);
		}
		
		protected function guardUpdateHandler(e:CityCraftEvent):void
		{
			var guardList:Array = GlobalData.cityCraftInfo.guardList;
			var i:int=0;
			var guardview:GuardView;
			var guardItem:CityCraftGuardItemInfo;
			for(;i<GUARD_POSITION.length;i++)
			{
				guardview = _guardViews[i];
				guardview.guardType = GUARD_TYPE[0];
			}
			for each(guardItem in guardList)
			{
				guardview = _guardViews[guardItem.position-1];
				guardview.guardType = GUARD_TYPE[guardItem.type];
			}
		}
		
		protected function deleteBtnClickHandler(e:MouseEvent):void
		{
			var position:int = _positionCombox1.selectedItem.value;			
			var guardview:GuardView = _guardViews[position-1];
			var type:String = guardview.guardType;
			MAlert.show(LanguageManager.getWord("ssztl.cityCraft.sureDeleteGuard",type),
				LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,getAlertCloseHandler);
			function getAlertCloseHandler(evt:CloseEvent):void		
			{
				if(evt.detail == MAlert.OK)
					CityCraftDeleteGuardSocketHandler.send(position);
			}
		}
		
		protected function buyBtnClickHandler(e:MouseEvent):void
		{
			CityCraftBuyGuardSocketHandler.send(_buyTypeCombox.selectedItem.value);
		}
		
		protected function changeBtnClickHandler(e:MouseEvent):void
		{
			CityCraftChangeGuardPositionSocketHandler.send(_positionCombox1.selectedItem.value,_positionCombox2.selectedItem.value)
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
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
			if(_bgImg && _bgImg.bitmapData)
			{
				_bgImg.bitmapData.dispose();
				_bg = null;
			}
		}
	}
}