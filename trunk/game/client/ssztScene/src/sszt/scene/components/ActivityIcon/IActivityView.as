/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-7-18 下午7:12:49 
 * 
 */ 
package sszt.scene.components.ActivityIcon
{
	import sszt.interfaces.dispose.IDispose;

	public interface IActivityView extends IDispose
	{
		function show(arg1:int=0,arg2:Object =null,isDispatcher:Boolean=false):void;
		function hide(isDispatcher:Boolean=true):void;
	}
}