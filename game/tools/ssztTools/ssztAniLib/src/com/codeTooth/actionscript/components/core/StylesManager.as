package com.codeTooth.actionscript.components.core
{
	import com.codeTooth.actionscript.components.styles.IStyle;
	import com.codeTooth.actionscript.lang.utils.collection.collection_internal;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.events.IEventDispatcher;
	
	internal class StylesManager extends AbstractObjectsManager
	{
		use namespace collection_internal;
		
		include "StylesDIXML.as"
		
		public function StylesManager(definitionsLoaderName:String, eventDispatcherDelegate:IEventDispatcher)
		{
			super(definitionsLoaderName, eventDispatcherDelegate, _stylesDIXML);
		}
		
		override protected function update(iterator:IIterator):void
		{
			while(iterator.hasNext())
			{
				iterator.next().updateStyle();
			}
		}
		
		public function registerStyleable(styleable:IStyleable):void
		{
			_collection.addItem(styleable, styleable);
		}
		
		public function logoutStyleable(styleable:IStyleable):void
		{
			_collection.removeItem(styleable);
		}
		
		public function createStyle(styleName:String):*
		{
			return _diContainer.createObject(styleName).getStyle();
		}
	}
}