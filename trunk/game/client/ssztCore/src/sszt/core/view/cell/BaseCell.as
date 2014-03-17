package sszt.core.view.cell
{
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DragActionType;
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.ColorUtils;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CellEvent;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.container.MSprite;
	
	public class BaseCell extends MSprite implements ICell
	{
		protected var _levelPic:Bitmap;
		protected var _lockPic:Bitmap;
		protected var _info:ILayerInfo;
		protected var _figureBound:Rectangle;
		protected var _showLoading:Boolean;
		protected var _pic:Bitmap;
		protected var _boundSprite:Sprite;
//		private var _loadingAsset:BaseLoadEffect;
		private var _loadingAsset:Bitmap;
		private var _fillBg:int;
		private var _bgShape:Shape;
		private var _autoDisposeLoader:Boolean;
		private var _picPath:String;
		/**
		 * 是否锁定状态，图片加载完会检测些状态
		 */		
		private var _isLock:Boolean;
		/**
		 * 避免反复创建
		 */		
		private var _hasLoading:Boolean;
		
		private static var levelArray:Array = [];
		private static var qualityArray:Array = [];
		protected var _qualitBox:Bitmap;
		
		public function BaseCell(info:ILayerInfo = null,showLoading:Boolean = true,autoDisposeLoader:Boolean = true,fillBg:int = -1)
		{
			_levelPic = new Bitmap();
			_levelPic.y = 4;
			_levelPic.x = 4;
			
			_lockPic = new Bitmap();
			_lockPic.y = 27;
			_lockPic.x = 2;
			
			_qualitBox = new Bitmap();
			super();
			_info = info;
			_showLoading = showLoading;
			mouseEnabled = false;
			_fillBg = fillBg;
			_autoDisposeLoader = autoDisposeLoader;
			initEvent();
			
		}
		
		public static function setup():void
		{
			levelArray = [
				null,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset6") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset7") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset8") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset9") as BitmapData,
				AssetUtil.getAsset("ssztui.common.StoneLevelAsset10") as BitmapData,
				null
			];
			qualityArray = [
				null,
				AssetUtil.getAsset("ssztui.common.CellQuality0Asset") as BitmapData,
				AssetUtil.getAsset("ssztui.common.CellQuality1Asset") as BitmapData,
				AssetUtil.getAsset("ssztui.common.CellQuality2Asset") as BitmapData,
				AssetUtil.getAsset("ssztui.common.CellQuality3Asset") as BitmapData,
				AssetUtil.getAsset("ssztui.common.CellQuality4Asset") as BitmapData,
			];
		}
		
		override protected function configUI():void
		{
			super.configUI();
			initFigureBound();
			initChildren();
		}
		
		protected function initChildren():void
		{
			_boundSprite = new Sprite();
			_boundSprite.x = _figureBound.x;
			_boundSprite.y = _figureBound.y;
			_boundSprite.graphics.beginFill(0,0);
			_boundSprite.graphics.drawRect(0,0,_figureBound.width,_figureBound.height);
			_boundSprite.graphics.endFill();
			addChildAt(_boundSprite,0);
		}
		
		protected function initEvent():void
		{
			_boundSprite.addEventListener(MouseEvent.MOUSE_OVER,showTipHandler);
			_boundSprite.addEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
			_boundSprite.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function removeEvent():void
		{
			_boundSprite.removeEventListener(MouseEvent.MOUSE_OVER,showTipHandler);
			_boundSprite.removeEventListener(MouseEvent.MOUSE_OUT,hideTipHandler);
			_boundSprite.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function showTipHandler(evt:MouseEvent):void
		{
		}
		
		protected function hideTipHandler(evt:MouseEvent):void
		{
		}
		protected function clickHandler(evt:MouseEvent):void
		{
		}
		
		override protected function draw():void
		{
			if(isInvalid("initLoading"))
			{
				if(_hasLoading)
				{
					createLoading();
				}
				else
				{
					clearLoading();
				}
			}
			super.draw();
		}
		
		/**
		 * 初始化物品图标的位置和大小
		 * */
		protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,32,32);
		}
		
		public function set info(value:ILayerInfo):void
		{
			locked = false;
			if(_info != null && value != null)
			{
//				if(_info.templateId == value.templateId && _info.iconPath == value.iconPath)return;
			}
			if(_info)
			{
//				clearLoading();
				
				_hasLoading = false;
				clearPic();
				clearEffect();
				if(_levelPic && _levelPic.parent) _levelPic.parent.removeChild(_levelPic);
				if(_qualitBox && _qualitBox.parent) _qualitBox.parent.removeChild(_qualitBox);
				if(_lockPic && _lockPic.parent) _lockPic.parent.removeChild(_lockPic);
			}
			_info = value;
			if(_info)
			{
				if(_showLoading)
				{
					_hasLoading = true;
//					createLoading();
				}
				createContent();
				if(_fillBg >= 0)
				{
					if(_bgShape == null)
					{
						_bgShape = new Shape();
						_bgShape.filters = [new GlowFilter(0x7F714B,1,2,2,8)];
					}
					addChild(_bgShape);
				}
			}
			else
			{
				clearTip();
			}
			invalidate("initLoading");
			dispatchEvent(new CellEvent(CellEvent.CELL_CHANGE));
			
		}
		protected function clearEffect():void
		{
			
		}
		private function clearPic():void
		{
			if(_pic && _pic.parent)_pic.parent.removeChild(_pic);
			_pic = null;
			if(_picPath)
			{
				GlobalAPI.loaderAPI.removeAQuote(_picPath,createPicComplete);
			}
		}
		
		private function clearTip():void
		{
			TipsUtil.getInstance().hide();
		}
		
		protected function createPicComplete(data:BitmapData):void
		{
//			clearLoading();
			_hasLoading = false;
			invalidate("initLoading");
			if(!info)return;
			_pic = new Bitmap(data);
			updateSize(_pic);
			addChild(_pic);
			updatePicGrayFilters();
			updateLock();
			if(_fillBg >= 0)
			{
				_bgShape.graphics.beginFill(_fillBg);
				_bgShape.graphics.drawRoundRect(_boundSprite.x,_boundSprite.y,_boundSprite.width,_boundSprite.height,4,4);
				_bgShape.graphics.endFill();
			}
			if((_info is ItemTemplateInfo) && CategoryType.STONE_LEVEL_TYPES.indexOf(ItemTemplateInfo(_info).categoryId)!= -1)
			{
				_levelPic.bitmapData = levelArray[ItemTemplateInfo(_info).property3];
				if(!_levelPic.parent) addChild(_levelPic);
			}
		}
		
		public function get info():ILayerInfo
		{
			return _info;
		}
		
		
		private function createContent():void
		{
			_picPath = GlobalAPI.pathManager.getDisplayItemPath(_info.iconPath,getLayerType());
			GlobalAPI.loaderAPI.getPicFile(_picPath,createPicComplete,SourceClearType.NEVER);
//			GlobalAPI.loaderAPI.getDisplayFile(_picPath,GlobalAPI.pathManager.getItemClassPath(_info.picPath,getLayerType()),createPicComplete,SourceClearType.NEVER);
		}
		
		protected function getLayerType():String
		{
			return LayerType.ICON;
		}
		
		private function createLoading():void
		{
			if(_loadingAsset == null)
			{
//				_loadingAsset = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.ITEM_LOADING));
//				_loadingAsset.play(SourceClearType.CHANGESCENE_AND_TIME,100000);
				_loadingAsset = new Bitmap(AssetUtil.getAsset("ssztui.common.CellLoadAsset") as BitmapData);
			}
			updateLoading();
			addChild(_loadingAsset);
		}
		
		private function clearLoading():void
		{
			if(_loadingAsset && _loadingAsset.bitmapData)
			{
//				_loadingAsset.dispose();
				_loadingAsset.bitmapData.dispose();
			}
			_loadingAsset = null;
		}
		
		private function updateLoading():void
		{
			var tmpX:int,tmpY:int;
			if(32 > _figureBound.width)
			{
				tmpX = _figureBound.x;
			}
			else
			{
				tmpX = (_figureBound.width - 32) / 2 + _figureBound.x; 
			}
			if(32 > _figureBound.height)
			{
				tmpY = _figureBound.y;
			}
			else
			{
				tmpY = (_figureBound.height - 32) / 2 + _figureBound.y;
			}
			if(_loadingAsset){
//				_loadingAsset.move(tmpX - 9,tmpY - 10);
				_loadingAsset.x = (_figureBound.width - 38) / 2 + _figureBound.x; 
				_loadingAsset.y = (_figureBound.height - 38) / 2 + _figureBound.y; 
			}
		}
		
		private function updateSize(obj:DisplayObject):void
		{
			if(obj.width > _figureBound.width)
			{
				obj.width = _figureBound.width;
				obj.x = _figureBound.x;
			}
			else
			{
				obj.x = (_figureBound.width - obj.width) / 2 + _figureBound.x; 
			}
			if(obj.height > _figureBound.height)
			{
				obj.height = _figureBound.height;
				obj.y = _figureBound.y;
			}
			else
			{
				obj.y = (_figureBound.height - obj.width) / 2 + _figureBound.y;
			}
		}
		
		public function set locked(value:Boolean):void
		{
			if(_isLock == value)return;
			_isLock = value;
			updateLock();
		}
		public function get locked():Boolean
		{
			return _isLock;
		}
		
		public function dragStart():void
		{
			//			locked = true;
			GlobalAPI.dragManager.startDrag(this);
		}
		
		protected function updatePicGrayFilters():void
		{
			if(_info is ItemTemplateInfo && getLayerType() != LayerType.STORE_ICON && CategoryType.isEquip((_info as ItemTemplateInfo).categoryId))
			{
				_qualitBox.bitmapData = qualityArray[(_info as ItemTemplateInfo).quality];
				if(!_qualitBox.parent) addChild(_qualitBox);
			}else{
				if(_qualitBox && _qualitBox.parent)
					_qualitBox.parent.removeChild(_qualitBox);
			}			
		}
		
		protected function updateLock():void
		{
			if(_pic == null)return;
			if(_isLock)
			{
				_pic.filters = [ColorUtils.grayMatrix];
			}
			else
			{
				_pic.filters = null;
			}
		}
		
		public function getSourceType():int
		{
			return CellType.NONE;
		}
		
		override public function dispose():void
		{
			clearPic();
			clearLoading();
			removeEvent();
			_levelPic = null;
			_qualitBox = null;
			_lockPic = null;
			super.dispose();
		}
		
		public function getDragImage():DisplayObject
		{
			if(_pic==null)return null;
			return new Bitmap((_pic as Bitmap).bitmapData);
		}
		
		public function dragStop(data:IDragData):void{}
		public function dragDrop(data:IDragData):int{return DragActionType.NONE;}
		public function getSourceData():Object{return info;}
	}
}