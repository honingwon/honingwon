/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:47:48 
 * 
 */ 
package sszt.core.data.chat.club
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.events.ChatModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class ClubChatInfo  extends EventDispatcher 
	{
		public var list:Array;
		public var unReadCount:int = 0;
		public var isFlash:Boolean = true;
		
		public function ClubChatInfo(_arg1:IEventDispatcher=null){
			super(_arg1);
			this.list = [];
		}
		public function addItem(info:ClubChatItemInfo):void{
			this.list.push(info);
			if (this.list.length > 30){
				this.list.shift();
			}
			
			dispatchEvent(new ChatInfoUpdateEvent(ChatInfoUpdateEvent.ADD_CLUB_CHATINFO, info));
			if (GlobalData.selfPlayer.userId != info.info.fromId){
				this.unReadCount++;
				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.NEW_CLUB_MESSAGE));
			}
		}
		public function clear():void{
			this.unReadCount = 0;
			this.list = [];
		}
	}
}