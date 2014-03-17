/**
 * @author lxb
 *  2012-9-13 修改
 */
package sszt.ui.container
{
	import fl.controls.Button;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.UIManager;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.mcache.btns.MCacheCloseBtn;
	
	import ssztui.ui.TitleBackgroundLeftAsset;
	import ssztui.ui.TitleBackgroundRightAsset;
	
	
	public class MPanel extends UIComponent implements IPanel
	{
		protected var _minHeight:Number = 80;
		protected var _minWidth:Number = 240;
		protected var _minTitleWidth:Number = 204;
		
		protected var _paddingWidth:Number = 0;
		
		protected var _paddingTop:Number = 0;
		protected var _paddingBottom:Number = 0;
		
		protected var _titleHeight:Number = 30;
		protected var _titleTopOffset:int = 8;
		
		private const _closeBtnYoffset:int = 6;
		private const _closeBtnXoffset:int = 6;
		
		
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		protected var _contentX:Number;
		protected var _contentY:Number;
		/**
		 * 
		 */		
		private var _subContainer:Sprite;
		
		protected var _title:DisplayObject;
		private var _dragable:Boolean;
		private var _mode:Number;
		private var _closeable:Boolean;
		
		private var _background:DisplayObject;
		private var _closeBtn:MAssetButton;
		private var _dragarea:Sprite;
		private var _setCenter:Boolean;
		protected var _container:Sprite;
		
		private var _hadDraw:Boolean;
		private var _tmpX:Number,_tmpY:Number;
		private var _bgRecordList:Dictionary;
		
		protected var _innerEscHandler:Function;
		
		private var _rect:Rectangle;
		
		/**
		 * 
		 * @param title
		 * @param dragable
		 * @param mode -1表示非mode
		 * @param closeable
		 * 
		 */		
		public function MPanel(title:DisplayObject = null,dragable:Boolean = true,mode:Number = 0.5,closeable:Boolean = true,toCenter:Boolean = true,rect:Rectangle=null)
		{
			_title = title;
			_dragable = dragable;
			_mode = mode;
			_closeable = closeable;
			_setCenter = toCenter;
			_tmpX = _tmpY = 0;
			_innerEscHandler = innerEscHandler;
			_rect = rect;
			_bgRecordList = new Dictionary();
			super();
			super.move(5000,5000);
		}
		
		protected function setToBackgroup( list:Array):void
		{
			if(list) {
				var bg:IMovieWrapper = BackgroundUtils.setBackground(list);
				addContent(bg as DisplayObject);
			}
		}
		protected function initConfigDatas():void
		{
			_contentWidth = _minWidth;
			_contentHeight = _minHeight;
			_contentY = _titleHeight;
			_contentX = _paddingWidth;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			initConfigDatas();
			_container = new Sprite();
			_subContainer = new Sprite();
			_subContainer.x = _contentX;
			_subContainer.y = _contentY;
			if(_mode >= 0)
			{
				var sp:Sprite = new Sprite();
				sp.graphics.beginFill(0,_mode);
				sp.graphics.drawRect(-1000,-1000,4000,4000);
				sp.graphics.endFill();
				addChild(sp);
			}
			addChild(_container);
			if(_dragable)
			{
				if(_dragarea == null)
				{
					_dragarea = new Sprite();
					_dragarea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
					_dragarea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
					_container.addChild(_dragarea);
				}
			}
			if(_closeable)
			{
				if(_closeBtn == null)
				{
					_closeBtn = new MCacheCloseBtn();
					_container.addChild(_closeBtn);
					_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
				}
			}
			_container.addChild(_subContainer);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.SIZE))
				drawLayout();
			if(isInvalid("center") && _setCenter)
			{
				_hadDraw = true;
				x = (CommonConfig.GAME_WIDTH - _background.width) / 2;
				y = (CommonConfig.GAME_HEIGHT - _background.height) / 2;
			}
			else if(!_hadDraw)
			{
				_hadDraw = true;
				if(_rect && _rect.x + _rect.width + _background.width <= CommonConfig.GAME_WIDTH)
				{
					x = _rect.x + _rect.width;
					y = _rect.y;
				}
				else if(_rect && _rect.width + _background.width <= CommonConfig.GAME_WIDTH)
				{
					x = _rect.x -  _background.width;
					y = _rect.y;
				}
				else
				{
					x = _tmpX;
					y = _tmpY;
				}
			}
			super.draw();
		}
		
		override public function move(x:Number, y:Number):void
		{
			if(_hadDraw)
			{
				super.move(x,y);
			}
			else
			{
				_tmpX = x;
				_tmpY = y;
			}
		}
		
		public function setToTop():void
		{
			if(parent)
			{
				parent.setChildIndex(this,parent.numChildren - 1);
			}
		}
		
		override public function set x(value:Number):void
		{
			if(_hadDraw)
			{
				super.x = value;
			}
			else
			{
				move(value,_tmpY);
			}
		}
		
		override public function set y(value:Number):void
		{
			if(_hadDraw)
			{
				super.y = value;
			}
			else
			{
				move(_tmpX,value);
			}
		}
		
		protected function drawLayout():void
		{
			var bgWidth:Number = _contentWidth + _paddingWidth * 2;
			if(_title)
			{
				_title.x = (bgWidth - _title.width) / 2;
				_title.y = _titleTopOffset;
			}
			if(_closeBtn)
			{
				_closeBtn.move(bgWidth - _closeBtnXoffset -_closeBtn.width ,_closeBtnYoffset);
			}
			if(_dragarea)
			{
				_dragarea.graphics.beginFill(0,0);
				_dragarea.graphics.drawRect(0,0,bgWidth,_titleHeight);
				_dragarea.graphics.endFill();
			}
			_contentY = _titleHeight;
			_contentX = _paddingWidth;
			var bgHeight:Number = _contentHeight + _contentY + _paddingBottom + _paddingTop;
			if(_background && _background.parent)_background.parent.removeChild(_background);
			if(_bgRecordList == null)_bgRecordList = new Dictionary();
			if(_bgRecordList[int(bgWidth) + "," + int(bgHeight)] == null)
			{
				_background = createBg(bgWidth,bgHeight) as DisplayObject;
				_bgRecordList[int(bgWidth) + "," + int(bgHeight)] = _background;
			}
			else
			{
				_background = _bgRecordList[int(bgWidth) + "," + int(bgHeight)];
			}
			_container.addChildAt(_background,0);
		}
		
		protected function createBg(bgWidth:Number,bgHeight:Number):IMovieWrapper
		{
			var list:Array = [
					new BackgroundInfo(BackgroundType.BORDER_1,new Rectangle(0,0,bgWidth,bgHeight))
					];
			if(_title)
			{
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x-28,_title.y+2,28,18),new Bitmap(new TitleBackgroundLeftAsset())));
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x+_title.width,_title.y+2,28,18),new Bitmap(new TitleBackgroundRightAsset())));
				list.push(new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(_title.x,_title.y,_title.width,_title.height),_title));
				
			}
			return BackgroundUtils.setBackground(list);
		}
		
		override public function get height():Number
		{
			if(_background)
			{
				return _background.height;
			}
			return 0;
		}
		override public function get width():Number
		{
			if(_background)
			{
				return _background.width;
			}
			return 0;
		}
		
		public function setContentSize(width:Number,height:Number):void
		{
			_contentWidth = width;
			_contentHeight = height;
			invalidate(InvalidationType.SIZE);
		}
		
		public function addContent(content:DisplayObject):void
		{
			if(content.parent == _subContainer)return;
			_subContainer.addChild(content);
		}
		
		public function addContentAt(content:DisplayObject,index:int):void
		{
			if(content.parent == _subContainer)
			{
				_subContainer.setChildIndex(content,index);
			}
			_subContainer.addChildAt(content,index);
		}
		
		protected function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		public function setCenter():void
		{
			_setCenter = true;
			invalidate("center");
		}
		
		public function getContainer():Sprite
		{
			return _container;
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			_container.startDrag(false,new Rectangle(-x,-y,parent.stage.stageWidth - width,parent.stage.stageHeight - height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			_container.stopDrag();
		}
		
		public function doEnterHandler():void
		{
		}
		
		public function doEscHandler():void
		{
			if(_innerEscHandler != null)
				_innerEscHandler();
			
		}
		
		public function setEscHandler(handler:Function):void
		{
			_innerEscHandler = handler;
		}
		
		protected function innerEscHandler():void
		{
//			var flag:uint = 10000;
//			if(_cancelBtn)flag = CANCEL;
//			else if(_noBtn)flag = NO;
//			else if(_refuseBtn)flag = REFUSE;
//			if(flag != 10000)
//			{
//				doCallBack(flag);
//			}
			dispose();
		}
		
		/**
		 * 方法不同于copyStylesToChild,此方法style的值是显示对象，copyStylesToChild中style的值是string，需再次提取显示对象
		 * @param component
		 * @param style
		 * 
		 */		
		public function setStyleToChild(component:UIComponent,style:Object):void
		{
			for(var i:String in style)
			{
				component.setStyle(i,style[i]);
			}
		}
		
		 public function dispose():void
		{
			if(stage)
				stage.focus = stage;
			if(_dragarea)
			{
				_dragarea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
				_dragarea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			}
			if(_closeBtn)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
				if(_closeBtn.parent)_closeBtn.parent.removeChild(_closeBtn);
				_closeBtn.dispose();
				_closeBtn = null;
			}
			if(parent)parent.removeChild(this);
			for each(var i:DisplayObject in _bgRecordList)
			{
				if(i is IMovieWrapper)
				{
					IMovieWrapper(i).dispose();
				}
			}
			_bgRecordList = null;
			_background = null;
			dispatchEvent(new Event(Event.CLOSE));
			try
			{
				delete StyleManager.getInstance().classToInstancesDict[StyleManager.getClassDef(this)][this];
			}
			catch(e:Error){}
		}
		
//		public static function getStyleDefinition():Object
//		{
//			return mergeStyles(DEFAULT_STYLE,UIComponent.getStyleDefinition());
//		}
	}
}