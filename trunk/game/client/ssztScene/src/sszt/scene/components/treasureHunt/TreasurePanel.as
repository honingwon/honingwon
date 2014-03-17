/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-24 下午3:12:47 
 * 
 */ 
package sszt.scene.components.treasureHunt
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.events.TreasureUpdateEvent;
	import sszt.scene.mediators.TreasureMediator;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;

	public class TreasurePanel extends MSprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _digBtn:MAssetButton1;
		private var _autoFindBtn:MAssetButton1;
		private var _flyBtn:MAssetButton1;
		private var _cancelBtn:MBitmapButton;
		private var _mediator:TreasureMediator;
		private var _mapData:BitmapData;
		private var _mapContainer:Sprite;
		private var _treasureMap:Bitmap;
		private var _mask:Shape;
		private var _itemInfo:ItemInfo;
		private var _chanzi:BaseLoadEffect;
		private var _mapNameText:MAssetLabel;
		
		public function TreasurePanel(mediator:TreasureMediator, item:ItemInfo){
			var title:DisplayObject;
			this._mediator = mediator;
			this._itemInfo = item;
			super();
//			super(new MCacheTitle1(""), true, -1, true, false);
			if (this._itemInfo.enchase2 == 0){
				this.openMap();
			} else {
				this.getMapData();
			}
			
		}
		private function openMap():void{
			this._mediator.openMap(this._itemInfo.place);
		}
		private function getMapData():void{
			this._mediator.loadMapPre(this._itemInfo.template.property1, this.loadMapDataComplete);
		}
		private function loadMapDataComplete(value:BitmapData):void{
			this._mapData = value;
			this._treasureMap.bitmapData = value;
			this._treasureMap.scaleX = (this._treasureMap.scaleY = 1.2);
			var x:int = (this._itemInfo.template.property2 * 0.12);
			var y:int = (this._itemInfo.template.property3 * 0.12);
			var minX:int = 200;
			var maxX:int = ((this._mapData.width * 1.2) - minX);
			var minY:int = 150;
			var maxY:int = ((this._mapData.height * 1.2) - minY);
			var deltX:int = (minX - x);
			var deltY:int = (minY - y);
			var cX:int = (minX - 25);
			var cY:int = (minY - 165);
			this._mapNameText.setValue(MapTemplateList.getMapTemplate(this._itemInfo.template.property1).name);
			if (x < minX){
				deltX = 0;
				cX = (x - 25);
			} 
			else {
				if (x > maxX){
					deltX = ((minX - maxX) + 12);
					cX = (((minX + x) - maxX) - 13);
				}
			}
			if (y < minY){
				deltY = 0;
				cY = (y - 165);
			} else {
				if (y > maxY){
					deltY = ((minY - maxY) + 10);
					cY = (((minY + y) - maxY) - 155);
				}
			}
			this._mapContainer.x = deltX;
			this._mapContainer.y = (deltY + 30);
			this._chanzi.move(cX, (cY + 30));
			this._chanzi.play(SourceClearType.TIME, 600000);
		}
		
		override protected function configUI():void{
			super.configUI();
//			setContentSize(410, 350);
//			setToBackgroup([new BackgroundInfo(BackgroundType.BORDER_2, new Rectangle(0, 0, 410, 350))]);
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,333,355);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_bg = BackgroundUtils.setBackground([				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,333,355),new Bitmap(AssetUtil.getAsset("ssztui.treasure.BgAsset",BitmapData) as BitmapData)),
			]);
			addChild(_bg as DisplayObject);
			
			this._mapContainer = new Sprite();
			addChild(this._mapContainer);
			this._mask = new Shape();
			this._mask.x = 17;
			this._mask.y = 45;
			this._mask.graphics.beginFill(0xFF0000, 0.1);
			this._mask.graphics.drawRect(0, 0, 300, 225);
			this._mask.graphics.endFill();
			addChild(this._mask);
			this._mapContainer.mask = this._mask;			
			this._treasureMap = new Bitmap();
			this._mapContainer.addChild(this._treasureMap);
			
			this._digBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.treasure.DigBtnAsset",MovieClip) as MovieClip);
			this._digBtn.move(18, 274);
			addChild(this._digBtn);
			this._cancelBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.treasure.CloseBtnAsset",Bitmap));
			this._cancelBtn.move(300, 17);
			addChild(this._cancelBtn);
			
			this._autoFindBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.treasure.LeaveBtnAsset",MovieClip) as MovieClip);
			this._autoFindBtn.move(90, 277);
			addChild(this._autoFindBtn);
			
			this._flyBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.treasure.ArriveBtnAsset",MovieClip) as MovieClip);
			this._flyBtn.move(162, 277);
			addChild(this._flyBtn);
			
			_chanzi = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.CHANZI));
			addChild(this._chanzi);
			this._mapNameText = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,"left");
			this._mapNameText.width = 120;
			this._mapNameText.move(60, 318);
			addChild(this._mapNameText);
			move(0, 100);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(24,318,30,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.sceneModule")+"：",MAssetLabel.LABEL_TYPE1,"left")));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(17,45,300,225),AssetUtil.getAsset("ssztui.treasure.MaskAsset",MovieClip) as MovieClip));
			this.initEvent();
		}
		
		private function initEvent():void{
			this._digBtn.addEventListener(MouseEvent.CLICK, digClickHandler);
			this._cancelBtn.addEventListener(MouseEvent.CLICK, cancelClickHandler);
			this._autoFindBtn.addEventListener(MouseEvent.CLICK, autoFindBtnClickHandler);
			this._flyBtn.addEventListener(MouseEvent.CLICK, transferBitmapBtnClickHandler);
			this._mediator.sceneModule.treasureInfo.addEventListener(TreasureUpdateEvent.OPEN_MAP_UPDATE, this.openMapHandler);
			this._mediator.sceneModule.treasureInfo.addEventListener(TreasureUpdateEvent.IDENTIFY_MAP_UPDATE, this.identifyMapHandler);
			
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		private function removeEvent():void{
			this._digBtn.removeEventListener(MouseEvent.CLICK, digClickHandler);
			this._cancelBtn.removeEventListener(MouseEvent.CLICK, cancelClickHandler);
			this._autoFindBtn.removeEventListener(MouseEvent.CLICK, autoFindBtnClickHandler);
			this._flyBtn.removeEventListener(MouseEvent.CLICK, transferBitmapBtnClickHandler);
			this._mediator.sceneModule.treasureInfo.removeEventListener(TreasureUpdateEvent.OPEN_MAP_UPDATE, this.openMapHandler);
			this._mediator.sceneModule.treasureInfo.removeEventListener(TreasureUpdateEvent.IDENTIFY_MAP_UPDATE, this.identifyMapHandler);
			
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - 333,parent.stage.stageHeight - 355));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function openMapHandler(evt:TreasureUpdateEvent):void{
			this._itemInfo = this._mediator.sceneModule.treasureInfo.treasureMap;
			this.getMapData();
		}
		private function identifyMapHandler(evt:TreasureUpdateEvent):void{
			this._itemInfo = this._mediator.sceneModule.treasureInfo.treasureMap;
			var mapTemplate:MapTemplateInfo = MapTemplateList.getMapTemplate(this._itemInfo.enchase2);
		}
		
		private function digClickHandler(evt:MouseEvent):void{
			this._itemInfo = GlobalData.bagInfo.getItemByItemId(this._itemInfo.itemId);
			if (this._itemInfo == null){
				QuickTips.show(LanguageManager.getWord("ssztl.scene.treasureMapNotExist"));
			} 
			else {
				if (this.canDig() == false){
					QuickTips.show(LanguageManager.getWord("ssztl.scene.wrongPlaceToDig"));
				} else {
					if(_mediator.sceneModule.sceneInfo.teamData.leadId> 0)
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.isSureEnterCopy1"),
							LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
						function leaveCloseHandler(e:CloseEvent):void
						{
							if(e.detail == MAlert.OK)
							{
								TeamLeaveSocketHandler.sendLeave();
								var ti:Timer = new Timer(1000,1);
								ti.start();
								GlobalData.selfPlayer.scenePath = null;
								GlobalData.selfPlayer.scenePathTarget = null;
								GlobalData.selfPlayer.scenePathCallback = null;
								_mediator.sendNotification(SceneMediatorEvent.STOP_MOVING);
								ItemUseSocketHandler.sendItemUse(_itemInfo.place);
								QuickTips.show(LanguageManager.getWord("ssztl.scene.treasureUse"));
								dispose();
							}
						}
					}
					else
					{
						GlobalData.selfPlayer.scenePath = null;
						GlobalData.selfPlayer.scenePathTarget = null;
						GlobalData.selfPlayer.scenePathCallback = null;
						this._mediator.sendNotification(SceneMediatorEvent.STOP_MOVING);
						ItemUseSocketHandler.sendItemUse(this._itemInfo.place);
						QuickTips.show(LanguageManager.getWord("ssztl.scene.treasureUse"));
						this.dispose();
					}
				}
			}
		}
		
		private function canDig():Boolean{
			if (GlobalData.currentMapId != this._itemInfo.template.property1){
				return false;
			}
			var deltX:Number = (GlobalData.selfScenePlayerInfo.sceneX - Number(this._itemInfo.template.property2));
			var deltY:Number = (GlobalData.selfScenePlayerInfo.sceneY - Number(this._itemInfo.template.property3));
			var distance:Number = Math.sqrt(((deltX * deltX) + (deltY * deltY)));
			if (distance != 0){
				return false;
			}
			return true;
		}
		
		private function autoFindBtnClickHandler(event:MouseEvent) : void
		{
			if(!_itemInfo) return;
			WalkChecker.doWalk(this._itemInfo.template.property1, new Point(this._itemInfo.template.property2, this._itemInfo.template.property3));
			
		}
		
		private function transferBitmapBtnClickHandler(event:MouseEvent) : void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {sceneId:this._itemInfo.template.property1, 
				target:new Point(this._itemInfo.template.property2, this._itemInfo.template.property3), checkItem:true, checkWalkField:true, type:4}));
		}
		
		
		private function cancelClickHandler(evt:MouseEvent):void{
			this.dispose();
		}
		
		public function doEscHandler():void
		{
			dispose();
			
		}
		
		override public function dispose():void{
			this.removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_dragArea)
			{
				_dragArea.graphics.clear();
				_dragArea = null;
			}
			if (this._chanzi){
				this._chanzi.dispose();
				this._chanzi = null;
			}
			if (this._digBtn){
				this._digBtn.dispose();
				this._digBtn = null;
			}
			if (this._autoFindBtn){
				this._autoFindBtn.dispose();
				this._autoFindBtn = null;
			}
			if (this._flyBtn){
				this._flyBtn.dispose();
				this._flyBtn = null;
			}
			if (this._cancelBtn){
				this._cancelBtn.dispose();
				this._cancelBtn = null;
			}
			this._mediator = null;
			this._mapData = null;
			this._mapContainer = null;
			this._treasureMap = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}