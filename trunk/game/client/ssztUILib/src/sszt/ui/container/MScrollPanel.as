package sszt.ui.container
{
	import fl.containers.BaseScrollPane;
	import fl.controls.ScrollPolicy;
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class MScrollPanel extends BaseScrollPane
	{
		protected var _container:UIComponent;
		
		private static var defaultStyles:Object = {
										upSkin:null,
										disabledSkin:null,
										focusRectSkin:null,
										focusRectPadding:null,
										contentPadding:0
										}
		
		public static function getStyleDefinition():Object 
		{
			return mergeStyles(defaultStyles, BaseScrollPane.getStyleDefinition());
		}
		
		public function MScrollPanel()
		{
			super();
		}

		public function getContainer():UIComponent
		{
			return _container;
		}
		
		override protected function setVerticalScrollPosition(scrollPos:Number, fireEvent:Boolean=false):void 
		{
			if(!_container)return;
			var contentScrollRect:Rectangle = _container.scrollRect;
			var m:Number = Math.min(Math.ceil((scrollPos) / verticalScrollBar.lineScrollSize) * verticalScrollBar.lineScrollSize,verticalScrollBar.maxScrollPosition);
			contentScrollRect.y = Math.max(m,0);
			_container.scrollRect = contentScrollRect;
		}

		override protected function setHorizontalScrollPosition(scrollPos:Number, fireEvent:Boolean=false):void 
		{
			if(!_container)return;
			var contentScrollRect:Rectangle = _container.scrollRect;
			contentScrollRect.x = scrollPos;
			_container.scrollRect = contentScrollRect;
		}
		
		/**
		 * 更新滚动条
		 * @param width -1不改变当前container实际宽度，否则刚container当前宽度设为width，再更新滚动条
		 * @param height
		 * 
		 */		
		public function update(width:Number = -1,height:Number = -1):void
		{
			if(_container == null)return;
			if(width != -1)getContainer().width = width;
			if(height != -1)getContainer().height = height;
			setContentSize(_container.width,_container.height);
		}
		
		override protected function drawLayout():void 
		{
			super.drawLayout();
			if(_container == null)return;
			contentScrollRect = _container.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			
			_container.cacheAsBitmap = useBitmapScrolling;
			_container.scrollRect = contentScrollRect;
			_container.x = _container.y = contentPadding;
		}
		
		override protected function drawBackground():void
		{
			background = new Shape();
		}
		
		override protected function configUI():void 
		{
			super.configUI();
			_container = new UIComponent();
			addChild(_container);
			_container.scrollRect = contentScrollRect; 
			_horizontalScrollPolicy = ScrollPolicy.AUTO;
			_verticalScrollPolicy = ScrollPolicy.AUTO;
		}
		
		public function dispose():void
		{
			_container = null;
			if(parent)parent.removeChild(this);
			try
			{
				delete StyleManager.getInstance().classToInstancesDict[StyleManager.getClassDef(this)][this];
			}
			catch(e:Error){}
		}
	}
}