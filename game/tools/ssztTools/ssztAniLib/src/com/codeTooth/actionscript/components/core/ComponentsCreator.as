package com.codeTooth.actionscript.components.core
{
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainer;
	import com.codeTooth.actionscript.dependencyInjection.core.DiXMLLoader;
	
	/**
	 * @private
	 * 
	 * 组件创建器
	 */	
	
	internal class ComponentsCreator
	{
		include "ComponentsDIXML.as"
		
		public function ComponentsCreator(stylesManager:StylesManager, skinsManager:SkinsManager)
		{
			_diContainer = new DiContainer();
			_diContainer.load(new DiXMLLoader(), _componentsDIXML);
			
			_diContainer.addLocal("stylesManager", stylesManager);
			_diContainer.addLocal("skinsManager", skinsManager);
			
			_stylesManager = stylesManager;
			_skinsManager = skinsManager;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 创建组件
		//--------------------------------------------------------------------------------------------------------------------------
		
		// 组件的注入容器
		private var _diContainer:DiContainer;
		
		// 样式管理器
		private var _stylesManager:StylesManager;
		
		// 皮肤管理器
		private var _skinsManager:SkinsManager;
		
		/**
		 * 创建一个组件
		 * 
		 * @param id
		 * 
		 * @return 
		 */		
		public function createComponent(id:String):*
		{
			var component:* = _diContainer.createObject(id);
			_stylesManager.registerStyleable(component);
			_skinsManager.registerSkinable(component);
			
			return component;
		}
	}
}