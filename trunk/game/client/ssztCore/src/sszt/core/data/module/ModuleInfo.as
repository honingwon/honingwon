package sszt.core.data.module
{
	/**
	 * 模块信息 
	 * 包含模块id、名称
	 */
	public class ModuleInfo
	{
		public var moduleId:int;
		public var name:String;
		
		/**
		 * 模块信息 
		 * @param moduleId 模块id
	     * @param name 模块名称
		 */
		public function ModuleInfo(moduleId:int,name:String)
		{
			this.moduleId = moduleId;
			this.name = name;
		}
	}
}
