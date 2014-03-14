package com.codeTooth.actionscript.applicationTemplates.template1.commands.common.notify 
{
	import com.codeTooth.actionscript.applicationTemplates.template1.commands.CommandBase;
	import com.codeTooth.actionscript.applicationTemplates.template1.core.app_templ1_ns_internal;
	
	public class NotifyCommand extends CommandBase
	{
		use namespace app_templ1_ns_internal;
		
		public function NotifyCommand() 
		{
			
		}
		
		override public function execute(data:Object = null):*
		{
			interfaceFacade.app_templ1_ns_internal::dataMethod("notify", data);
		}
		
	}

}