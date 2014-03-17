package sszt.core.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.layer.ILayerManager;
	import sszt.interfaces.layer.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MPanel;
	
	public class LayerManager implements ILayerManager
	{
		private var _container:DisplayObjectContainer;
		private var _moduleLayer:DisplayObjectContainer;
		private var _popLayer:DisplayObjectContainer;
		private var _tipLayer:DisplayObjectContainer;
		private var _effectLayer:DisplayObjectContainer;
		
//		private var _popPanels:Vector.<IPanel>;
		private var _popPanels:Array;
//		private var _changeModuleClosePanels:Vector.<IPanel>;
		private var _changeModuleClosePanels:Array;
		
		public function LayerManager(sp:DisplayObjectContainer)
		{
			_container = sp;
//			_popPanels = new Vector.<IPanel>();
			_popPanels = [];
//			_changeModuleClosePanels = new Vector.<IPanel>();
			_changeModuleClosePanels = [];
			_moduleLayer = new Sprite();
			_popLayer = new Sprite();
			_popLayer.mouseEnabled = false;
			_tipLayer = new Sprite();
			_tipLayer.mouseEnabled = false;
			_effectLayer = new Sprite();
			_effectLayer.mouseEnabled =_effectLayer.mouseChildren = false;
			_container.addChild(_moduleLayer);
			_container.addChild(_popLayer);
			_container.addChild(_tipLayer);
			_container.addChild(_effectLayer);
			
			ModuleEventDispatcher.addModuleEventListener(ModuleEvent.MODULE_CHANGE,moduleChangeHandler);
		}
		
		/**
		 * 放置模块和模块过渡层
		 * @return 
		 * 
		 */		
		public function getModuleLayer():DisplayObjectContainer
		{
			return _moduleLayer;
		}
		
		public function getPopLayer():DisplayObjectContainer
		{
			return _popLayer;
		}
		
		public function getTipLayer():DisplayObjectContainer
		{
			return _tipLayer;
		}
		
		public function getEffectLayer():DisplayObjectContainer
		{
			return _effectLayer;
		}
		
		public function setCenter(display:DisplayObject):void
		{
			display.x = (CommonConfig.GAME_WIDTH - display.width) / 2;
			display.y = (CommonConfig.GAME_HEIGHT - display.height) / 2;
		}
		
		public function getTopPanelRec():Rectangle
		{
			if(_popPanels && _popPanels.length>0)
			{
				var p:MPanel = getTopPanel() as MPanel;
				if(p && p.getContainer() && p.width)
				{
					return new Rectangle(p.x + p.getContainer().x,p.y + p.getContainer().y,p.width,p.height);
				}
			}
			return null;
		}
		
		public function addPanel(panel:IPanel,closeWhenModuleChangle:Boolean = true,swapWhenClick:Boolean = true):void
		{
			var n:int = _popPanels.indexOf(panel);
			if(n == -1)
			{
				_popPanels.push(panel);
				panel.addEventListener(Event.CLOSE,panelCloseHandler);
				if(swapWhenClick)panel.addEventListener(MouseEvent.MOUSE_DOWN,panelDownHandler);
			}
			_popLayer.addChild(panel as DisplayObject);
			if(closeWhenModuleChangle)
			{
				n = _changeModuleClosePanels.indexOf(panel);
				if(n == -1)_changeModuleClosePanels.push(panel);
			}
			
		}
		
		public function getTopPanel():IPanel
		{
			return _popLayer.getChildAt(_popLayer.numChildren - 1) as IPanel;
		}
		
		public function escPress():void
		{
			for(var i:int = _popLayer.numChildren - 1; i >= 0; i--)
			{
				var panel:IPanel = _popLayer.getChildAt(i) as IPanel;
				if(panel)
				{
					panel.doEscHandler();
					return;
				}
			}
		}
		
		private function panelCloseHandler(evt:Event):void
		{
			var target:IPanel = evt.currentTarget as IPanel;
			target.removeEventListener(Event.CLOSE,panelCloseHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN,panelDownHandler);
			var n:int = _popPanels.indexOf(target);
			if(n != -1)_popPanels.splice(n,1);
			n = _changeModuleClosePanels.indexOf(target);
			if(n != -1)_changeModuleClosePanels.splice(n,1);
		}
		
		private function panelDownHandler(evt:MouseEvent):void
		{
			_popLayer.setChildIndex((evt.currentTarget as DisplayObject),_popLayer.numChildren - 1);
		}
		
		private function moduleChangeHandler(evt:ModuleEvent):void
		{
			for(var i:int = _changeModuleClosePanels.length - 1; i >= 0; i--)
			{
				_changeModuleClosePanels[i].dispose();
			}
//			_changeModuleClosePanels = new Vector.<IPanel>();
			_changeModuleClosePanels = [];
		}
	}
}
