package com.codeTooth.actionscript.components.core
{	
	import com.codeTooth.actionscript.lang.errors.AbstractError;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * 组件基础
	 */
	
	public class AbstractComponent extends Sprite 
																	implements IStyleable, ISkinable
	{
		
		public function AbstractComponent()
		{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		protected var _width:Number = 0;
		
		protected var _height:Number = 0;
		
		/**
		 * @inheritDoc
		 */				
		override public function set width(width:Number):void
		{
			throw new AbstractError();
		}
		
		/**
		 * @private
		 */	
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function set height(height:Number):void
		{
			throw new AbstractError();
		}
		
		/**
		 * @private
		 */	
		override public function get height():Number
		{
			return _height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 实现 IStyleable 接口
		//--------------------------------------------------------------------------------------------------------------------------
				
		/**
		 * @inheritDoc
		 */		
		public function updateStyle():void
		{
			throw new AbstractError();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 组件是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		protected var _enabled:Boolean = true;
		
		/**
		 * 组件是否可用
		 */		
		public function set enabled(bool:Boolean):void
		{
			throw new AbstractError();
		}
		
		/**
		 * @private
		 */		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 样式
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 样式的名称
		protected var _styleName:String;
		
		// 样式管理器
		protected var _stylesManager:StylesManager;
			
		/**
		 * 样式名称
		 * 
		 * @param styleName
		 */		
		public function set styleName(styleName:String):void
		{
			_styleName = styleName;
		}
		
		/**
		 * @private
		 */		
		public function get styleName():String
		{
			return _styleName;
		}
		
		/**
		 * @private
		 * 
		 * 设置组件注册到的样式管理器
		 * 
		 * @param stylesManager
		 */		
		public function setStylesManager(stylesManager:StylesManager):void
		{
			_stylesManager = stylesManager;
		}
		
		/**
		 * 注册到样式管理器
		 */		
		public function registerStyleable():void
		{
			_stylesManager.registerStyleable(this);
		}
		
		/**
		 * 从样式管理器中注销
		 */		
		public function logoutStyleable():void
		{
			_stylesManager.logoutStyleable(this);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 实现 ISkinable 接口
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */	
		public function updateSkin():void
		{
			throw new AbstractError();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 皮肤
		//--------------------------------------------------------------------------------------------------------------------------
		
		protected var _skinsManager:SkinsManager;
		
		public function setSkinsManager(skinsManager:SkinsManager):void
		{
			_skinsManager = skinsManager;
		}
		
		public function registerSkinable():void
		{
			_skinsManager.registerSkinable(this);
		}
		
		public function logoutSkinable():void
		{
			_skinsManager.logoutSkinable(this);
		}
	}
}