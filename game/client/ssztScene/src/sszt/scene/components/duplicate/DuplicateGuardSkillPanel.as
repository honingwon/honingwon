package sszt.scene.components.duplicate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBSkillBarBgAsset;
	
	public class DuplicateGuardSkillPanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		private var _dragHit:Sprite;
		private var _spNumber:Sprite;
		
		public function DuplicateGuardSkillPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			this.visible = false;
			x = CommonConfig.GAME_WIDTH - 600;
			y = CommonConfig.GAME_HEIGHT - 190;
			mouseEnabled = false;
			
			_container = new Sprite();
			addChild(_container);
			_container.mouseEnabled = false;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,359,75),new Bitmap(new FBSkillBarBgAsset() as BitmapData))
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,50,24,26),new Bitmap(new FBTaskIconAsset() as BitmapData)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,85,200,2),new MCacheSplit2Line()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,20,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.MaxBatter"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
			_container.addChild(_bg as DisplayObject);
			_dragHit = new Sprite();
			_dragHit.graphics.beginFill(0x000000,0.01);
			_dragHit.graphics.drawRect(0,0,359,75);
			_dragHit.graphics.endFill();
			_container.addChild(_dragHit);
			
			_spNumber = new Sprite();
			_spNumber.x = 100;
			_spNumber.y = 0;
			_container.addChild(_spNumber);
			setNumbers(10086);
			//47,22 间隔：1
			
		}
		private function initialEvents():void
		{
			_dragHit.addEventListener(MouseEvent.MOUSE_DOWN,dragBtnDownHandler);
			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.MOUSE_UP,dragStopHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		private function removeEvents():void
		{
			_dragHit.removeEventListener(MouseEvent.MOUSE_DOWN,dragBtnDownHandler);
			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.MOUSE_UP,dragStopHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		private function dragBtnDownHandler(e:MouseEvent):void
		{
			this.startDrag(false,new Rectangle(0,0,CommonConfig.GAME_WIDTH - this.width, CommonConfig.GAME_HEIGHT - this.height));
		}
		private function dragStopHandler(e:MouseEvent):void
		{
			this.stopDrag();
		}
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 600;
			y = CommonConfig.GAME_HEIGHT - 200;
		}
		private function setNumbers(number:int):void
		{
			while(_spNumber.numChildren>0){
				_spNumber.removeChildAt(0);
			}
			
			var comboStr:String = number.toString();
			for(var i:int=0; i<comboStr.length; i++)
			{
				var mc:Bitmap = new Bitmap(AssetUtil.getAsset("ssztui.scene.NumberAsset" + comboStr.charAt(i)) as BitmapData);
				mc.x = _spNumber.width - 2;
				_spNumber.addChild(mc);
			}
		}
		public function show():void
		{
			
		}
		public function hide():void
		{
			
		}
		public function dispose():void
		{
			removeEvents();
			if(parent)parent.removeChild(this);
		}
	}
}