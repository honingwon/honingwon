package com.codeTooth.actionscript.components.core
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 组件应用入口
	 */
	
	public class ComponentsApplication extends EventDispatcher
	{	
		
		public function ComponentsApplication()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationException("Singleton ComponentsApplication");
			}
			
			_stylesManager = new StylesManager("stylesManager", this);
			
			_skinsManager = new SkinsManager("skinsManager", this);
			
			_componentsCreator = new ComponentsCreator(_stylesManager, _skinsManager);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 单例
		//--------------------------------------------------------------------------------------------------------------------------
		
		private static var _allowInstance:Boolean = false;
		
		private static var _instance:ComponentsApplication;
		
		public static function getInstance():ComponentsApplication
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new ComponentsApplication();
				_allowInstance = false;
			}
			
			return _instance;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 样式管理器
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 样式管理器
		private var _stylesManager:StylesManager;
		
		/**
		 * 加载一组样式定义
		 * 
		 * @param url
		 */
		public function loadStyles(url:String):void
		{
			_stylesManager.loadDeinitions(url);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 皮肤管理器
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 皮肤管理器
		private var _skinsManager:SkinsManager;
		
		/**
		 *  加载一组皮肤
		 * 
		 * @param url
		 */		
		public function loadSkins(url:String):void
		{
			_skinsManager.loadDeinitions(url);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 组件创建器
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 组件创建器
		private var _componentsCreator:ComponentsCreator;
		
		/**
		 * 创建一个组件
		 * 
		 * @param id
		 * 
		 * @return 
		 */		
		public function createComponent(id:String):*
		{
			return _componentsCreator.createComponent(id);
		}
	}
}