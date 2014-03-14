package com.codeTooth.actionscript.components.core
{
	import com.codeTooth.actionscript.lang.utils.collection.collection_internal;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.events.IEventDispatcher;

	internal class SkinsManager extends AbstractObjectsManager
	{
		use namespace collection_internal;
		
		include "SkinsDIXML.as"
		
		public function SkinsManager(definitionsLoaderName:String, eventDispatcherDelegate:IEventDispatcher)
		{
			super(definitionsLoaderName, eventDispatcherDelegate, _skinsDIXML);
		}
		
		override protected function update(iterator:IIterator):void
		{
			while(iterator.hasNext())
			{
				iterator.next().updateSkin();
			}
		}
		
		public function registerSkinable(skinable:ISkinable):void
		{
			_collection.addItem(skinable, skinable);
		}
		
		public function logoutSkinable(skinable:ISkinable):void
		{
			_collection.removeItem(skinable);
		}
		
		public function createSkin(skinName:String):*
		{
			return _diContainer.createObject(skinName);
		}
		
		public function hasSkin(skinName:String):Boolean
		{
			return _diContainer.hasObject(skinName);
		}
	}
}