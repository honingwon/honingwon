package com.codeTooth.actionscript.game.warFog.core
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * 战争迷雾
	 */	

	public class WarFog extends Sprite 
													implements IDestroy
	{
		// 显示区宽度
		private var _screenWidth:int = -1;
		
		// 显示区高度
		private var _screenHeight:int = -1;
		
		/**
		 * 构造函数
		 * 
		 * @param screenWidth 显示区宽度
		 * @param screenHeight 显示区高度
		 * @param fogColor 迷雾颜色
		 * @param fogAlpha 迷雾透明度
		 */		
		public function WarFog(screenWidth:int, screenHeight:int, fogColor:uint = 0x000000, fogAlpha:Number = .7)
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			blendMode = BlendMode.LAYER;
			
			_fogColor = fogColor;
			_fogAlpha = _fogAlpha;
			_fog = new Sprite();
			redrawFog();
			addChild(_fog);
			
			_eyeshotsContainer = new Sprite();
			addChild(_eyeshotsContainer);
			_eyeshotsContainer.blendMode = BlendMode.ERASE;
			
			_eyeshots = new Dictionary();
			
			_masksContainer = new Sprite();
			addChild(_masksContainer);
		}
		
		//-------------------------------------------------------------------------------------------
		// 遮罩
		//-------------------------------------------------------------------------------------------
		
		// 迷雾散开区域的遮罩
		private var _masksContainer:Sprite = null;
		
		/**
		 * 获得迷雾散开区域的遮罩
		 * 
		 * @return 
		 */		
		public function fogMask():DisplayObject
		{
			return _masksContainer;
		}
		
		//-------------------------------------------------------------------------------------------
		// 视野
		//-------------------------------------------------------------------------------------------
		
		// 显示视野的容器
		private var _eyeshotsContainer:Sprite = null;
		
		// 保存所有的视野对象
		private var _eyeshots:Dictionary = null;
		
		/**
		 * 添加一个迷雾中的视野
		 * 
		 * @param eyeshotObject
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 存在相同uniqueID的对象
		 */		
		public function addEyeshot(eyeshotObject:IEyeshot):void
		{
			if(eyeshotObject == null)
			{
				throw new NullPointerException("Null eyeshotObject");
			}
			
			if(_eyeshots[eyeshotObject.getUniqueID()] != undefined)
			{
				throw new IllegalOperationException("Has had the eyeshot \"" + eyeshotObject.getUniqueID() + "\"");
			}
			
			var eyeshot:Eyeshot = new Eyeshot(eyeshotObject);
			 _eyeshots[eyeshotObject.getUniqueID()] = eyeshot;
			 
			 _eyeshotsContainer.addChild(eyeshot.circle());
			 
			 _masksContainer.addChild(eyeshot.circleMask());
		}
		
		/**
		 * 移除一个迷雾中的视野
		 * 
		 * @param eyeshotObject
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 不存在指定的对象
		 */		
		public function removeEyeshot(eyeshotObject:IEyeshot):void
		{
			if(eyeshotObject == null)
			{
				throw new NullPointerException("Null eyeshotObject");
			}
			
			if(_eyeshots[eyeshotObject.getUniqueID()] == null)
			{
				throw new NoSuchObjectException("Has not the eyeshot \"" + eyeshotObject.getUniqueID() + "\"");
			}
			
			var eyeshot:Eyeshot = Eyeshot(_eyeshots[eyeshotObject.getUniqueID()]);
			
			_eyeshotsContainer.removeChild(eyeshot.circle());
			_masksContainer.removeChild(eyeshot.circleMask());
			
			eyeshot.destroy();
			
			delete _eyeshots[eyeshotObject.getUniqueID()];
		}
		
		//-------------------------------------------------------------------------------------------
		// 迷雾
		//-------------------------------------------------------------------------------------------
		
		// 迷雾
		private var _fog:Sprite = null;
		
		// 迷雾透明度
		private var _fogAlpha:Number = .7;
		
		// 迷雾颜色
		private var _fogColor:uint = 0x000000;
		
		/**
		 * 迷雾透明度
		 */		
		public function set fogAlpha(fogAlpha:Number):void
		{
			_fogAlpha = fogAlpha;
			redrawFog();
		}
		
		/**
		 * @private
		 */		
		public function get fogAlpha():Number
		{
			return _fogAlpha;
		}
		
		/**
		 * 迷雾颜色
		 */		
		public function set fogColor(fogColor:uint):void
		{
			_fogColor = fogColor;
			redrawFog();
		}
		
		/**
		 * @private
		 */		
		public function get fogColor():uint
		{
			return _fogColor;
		}
		
		/**
		 * 迷雾的偏移量，当场景发生移动时设置
		 * 
		 * @param tx
		 * @param ty
		 */		
		public function offsetFog(tx:Number, ty:Number):void
		{
			_fog.x = tx;
			_fog.y = ty;
		}
		
		/**
		 * 迷雾的缩放，当场景发生缩放时设置
		 * 
		 * @param scaleX
		 * @param scaleY
		 */		
		public function scaleFog(scaleX:Number, scaleY:Number):void
		{
			_fog.width = _screenWidth * scaleX;
			_fog.height = _screenHeight * scaleY;
		}
		
		// 重画迷雾
		private function redrawFog():void
		{
			_fog.graphics.clear();
			_fog.graphics.beginFill(_fogColor, _fogAlpha);
			_fog.graphics.drawRect(0, 0, _screenWidth, _screenHeight);
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IDestroy接口
		//-------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			blendMode = BlendMode.NORMAL;
			
			_fog.graphics.clear();
			removeChild(_fog);
			_fog = null;
			
			_eyeshotsContainer.blendMode = BlendMode.NORMAL;
			var numberEyeshots:int = _eyeshotsContainer.numChildren;
			for(var i:int = numberEyeshots - 1; i >= 0; i--)
			{
				_eyeshotsContainer.removeChildAt(i);
			}
			removeChild(_eyeshotsContainer);
			_eyeshotsContainer = null;
			
			var numberMasks:int = _masksContainer.numChildren;
			for(i = numberMasks - 1; i >= 0; i--)
			{
				_masksContainer.removeChildAt(i);
			}
			removeChild(_masksContainer);
			_masksContainer = null;
			
			DestroyUtil.destroyMap(_eyeshots);
			_eyeshots = null;
		}
	}
}


import com.codeTooth.actionscript.game.warFog.core.IEyeshot;
import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
import com.codeTooth.actionscript.game.warFog.core.EyeshotEvent;
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.filters.BlurFilter;
import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

class Eyeshot implements IDestroy
{
	private var _eyeshot:IEyeshot = null;
	
	private var _circle:Sprite = null;
	
	private var _mask:Sprite = null;
	
	public function Eyeshot(eyeshot:IEyeshot)
	{
		if(eyeshot == null)
		{
			throw new NullPointerException("Null eyeshot");
		}
		
		_eyeshot = eyeshot;
		_eyeshot.addEventListener(EyeshotEvent.EYESHOT_MOVE, eyeshotMoveHandler);
		_eyeshot.addEventListener(EyeshotEvent.EYESHOT_RADIUS_CHANGED, eyeshotRadiusChangedHandler);
		
		var filters:Array = [new BlurFilter(_eyeshot.eyeshotRadius() * .2, _eyeshot.eyeshotRadius() * .2, 2)];
		
		_circle = new Sprite();
		_circle.mouseEnabled = false;
		_circle.mouseChildren = false;
		_circle.filters = filters;
		
		_mask = new Sprite();
		_mask.mouseChildren = false;
		_mask.mouseEnabled = false;
		
		reset();
		eyeshotMoveHandler(null);
	}
	
	public function circle():DisplayObject
	{
		return _circle;
	}
	
	public function circleMask():DisplayObject
	{
		return _mask;
	}
	
	public function destroy():void
	{
		_mask = null;
		
		_circle.filters = null;
		_circle = null;
		
		_eyeshot.removeEventListener(EyeshotEvent.EYESHOT_MOVE, eyeshotMoveHandler);
		_eyeshot.removeEventListener(EyeshotEvent.EYESHOT_RADIUS_CHANGED, eyeshotRadiusChangedHandler);
		_eyeshot = null;
	}
	
	private function reset():void
	{
		_circle.graphics.clear();
		_circle.graphics.beginFill(0x000000);
		_circle.graphics.drawCircle(0, 0, _eyeshot.eyeshotRadius());
		
		_mask.graphics.clear();
		_mask.graphics.beginFill(0x000000);
		_mask.graphics.drawCircle(0, 0, _eyeshot.eyeshotRadius());
	}
	
	private function eyeshotMoveHandler(event:EyeshotEvent):void
	{
		_circle.x = _eyeshot.eyeshotX();
		_circle.y = _eyeshot.eyeshotY();
		
		_mask.x = _eyeshot.eyeshotX();
		_mask.y = _eyeshot.eyeshotY();
	}
	
	private function eyeshotRadiusChangedHandler(event:EyeshotEvent):void
	{
		reset();
	}
}