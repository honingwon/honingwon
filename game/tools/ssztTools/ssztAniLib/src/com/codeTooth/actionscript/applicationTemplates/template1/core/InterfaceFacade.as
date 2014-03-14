package com.codeTooth.actionscript.applicationTemplates.template1.core 
{
	import com.codeTooth.actionscript.applicationTemplates.template1.commands.CommandBase;
	import com.codeTooth.actionscript.applicationTemplates.template1.data.Data;
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainer;
	import com.codeTooth.actionscript.dependencyInjection.core.DiXMLLoader;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.patterns.observer.IObserver;
	
	public class InterfaceFacade
	{
		
		public function InterfaceFacade(data:Data, commandsDIXML:XML) 
		{
			if (data == null)
			{
				throw new NullPointerException("Null data");
			}
			
			if (commandsDIXML == null)
			{
				throw new NullPointerException("Null commandsDIXML");
			}
			
			_data = data;
			
			_commandsDIContainer = new DiContainer();
			_commandsDIContainer.load(new DiXMLLoader(), commandsDIXML);
		}
		
		//-------------------------------------------------------------------------------------------------------------------------------
		// 命令
		//-------------------------------------------------------------------------------------------------------------------------------
		
		protected var _commandsDIContainer:DiContainer;
		
		private var _command:CommandBase;
		
		public function executeCommand(commandID:String, data:Object = null):*
		{
			_command = _commandsDIContainer.createObject(commandID);
			_command.interfaceFacade = this;
			
			return _command.execute(data);
		}
		
		public function createCommand(commandID:String):*
		{
			_command = _commandsDIContainer.createObject(commandID);
			_command.interfaceFacade = this;
			
			return _command;
		}
		
		app_templ1_ns_internal function addLocal(localName:String, object:Object):void
		{
			_commandsDIContainer.addLocal(localName, object);
		}
		
		app_templ1_ns_internal function getLocal(localName:String):*
		{
			return _commandsDIContainer.getLocal(localName);
		}
		
		app_templ1_ns_internal function hasLocal(localName:String):Boolean
		{
			return _commandsDIContainer.hasLocal(localName);
		}
		
		//-------------------------------------------------------------------------------------------------------------------------------
		// 数据
		//-------------------------------------------------------------------------------------------------------------------------------
		
		protected var _data:Object;
		
		app_templ1_ns_internal function get data():Data
		{
			return Data(_data);
		}
		
		app_templ1_ns_internal function dataGetterAccessor(accessorName:String, ns:Namespace):*
		{
			return _data.ns::[accessorName];
		}
		
		app_templ1_ns_internal function dataSetterAccessor(accessorName:String,	 ns:Namespace, value:Object):void
		{
			_data.ns::[accessorName] = value;
		}
		
		app_templ1_ns_internal function dataMethod(methodName:String, ns:Namespace, ...parameters):*
		{
			return _data.ns::[methodName].apply(null, parameters);
		}
		
		app_templ1_ns_internal function addObserver(observerName:String, observer:IObserver):void
		{
			_data.addObserver(observerName, observer);
		}
		
		app_templ1_ns_internal function removeObserver(observerName:String):void
		{
			_data.removeObserver(observerName);
		}
		
		app_templ1_ns_internal function hasObserver(observerName:String):Boolean
		{
			return _data.hasObserver(observerName);
		}
		
		app_templ1_ns_internal function getObserver(observerName:String):IObserver
		{
			return _data.getObserver(observerName);
		}
		
		//-------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-------------------------------------------------------------------------------------------------------------------------------
		
		app_templ1_ns_internal function destroy():void
		{
			_data = null;
			
			_commandsDIContainer.destroy();
			_commandsDIContainer = null;
		}
		
	}

}