package sszt.core.data.mail
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.socketHandlers.mail.MailClearSocketHandler;
	
	public class MailInfo extends EventDispatcher
	{
//		public var mails:Vector.<MailItemInfo>;
		public var mails:Array;
		public var totalRecords:int;
		public var currentPage:int;
		public var currentCount:int;
		public static const PAGE_SIZE:int = 6;
		public function MailInfo()
		{
//			mails = new Vector.<MailItemInfo>();
			mails = [];
		}
		
		public function addItem(item:MailItemInfo):void
		{
			mails.push(item);
			dispatchEvent(new MailEvent(MailEvent.MAIL_ADD,item));
		}
		
		public function hasUnread():Boolean
		{
			for(var i:int = 0;i<mails.length;i++)
			{
				if(!mails[i].isRead)
					return true;
			}
			return false;
		}
		
		public function getUnReadCount():int
		{
			var count:int = 0;
			for(var i:int = 0;i<mails.length;i++)
			{
				if(!mails[i].isRead) count++;
			}
			return count;
		}
		
		private function compareFunction(item1:MailItemInfo,item2:MailItemInfo):int
		{
			if(item1.isRead && !item2.isRead)
				return 1;
			else
				return -1;
		}
		
		private function sort():void
		{
//			var list:Vector.<MailItemInfo> = new Vector.<MailItemInfo>();
			var list:Array = [];
			for(var i:int = 0;i< mails.length;i++)
			{
				if(!mails[i].isRead)
				{
					list.push(mails[i]);
					mails.splice(i,1);
					i--;
				}
			}
			for(i = 0;i<mails.length;i++)
			{
				list.push(mails[i]);
			}
			mails = list;
		}
		
//		public function getListByType(type:int,page:int):Vector.<MailItemInfo>
		public function getListByType(type:int,page:int):Array
		{
			var result:Array;
			currentCount = 0;
			if(type == 0)
			{
				sort();
				result = mails;
				currentCount = mails.length;
			}	
			else
			{
//				result = new Vector.<MailItemInfo>();
				result = [];
				switch (type)
				{
					case 1:
						for(var i:int = 0;i<mails.length;i++)
						{
							if(mails[i].type == MailType.SYSTEM)
							{
								result.push(mails[i]);
								currentCount ++;
							}
						}
						break;
					case 2:
						for(i= 0;i<mails.length;i++)
						{
							if(mails[i].type == MailType.PRIVATE)
							{
								result.push(mails[i]);
								currentCount ++;
							}
						}
						break;
					case 3:
						for(i = 0;i<mails.length;i++)
						{
							if(!mails[i].isRead)
							{
								result.push(mails[i]);
								currentCount ++;
							}
						}
						break;
					case 4:
						for(i = 0;i<mails.length;i++)
						{
							if(mails[i].isRead)
							{
								result.push(mails[i]);
								currentCount ++;
							}
						}
						break;
				}	
			}
			return result.slice(page*PAGE_SIZE,(page+1)*PAGE_SIZE);
		}
		
		/**
		 *删除邮件 
		 * @param mailId
		 * 
		 */		
		public function removeItem(mailId:Number):void
		{
			for(var i:int = 0; i<mails.length;i++)
			{
				if(mails[i].mailId == mailId)
				{
					mails.splice(i,1);
					break;
				}
			}
			dispatchEvent(new MailEvent(MailEvent.MAIL_DELETE,mailId));
			if(!hasUnread())
			{
				GlobalData.mailIcon.hide();
			}
		}
		
//		public function clear(data:Vector.<Number>):void
		public function clear(data:Array):void
		{
			for(var i:int = 0;i<data.length;i++)
			{
				for(var j:int = 0; j<mails.length;j++)
				{
					if(mails[j].mailId == data[i])
					{
						mails.splice(j,1);
						break;
					}
				}
			}
			if(!hasUnread())
			{
				GlobalData.mailIcon.hide();
			}
		}
		
		/**
		 *改变邮件读取状态 
		 * @param mailId
		 * 
		 */		
		public function change(mailId:Number):void
		{
			for(var i:int=0;i<mails.length;i++)
			{
				if(mails[i].mailId == mailId)
				{
					mails[i].isRead = true;
					break;
				}
			}
			dispatchEvent(new MailEvent(MailEvent.MAIL_READ,mailId));
		}
		/**
		 *更改附件获取状态 
		 * @param list
		 * 
		 */
		public function changeAttach(mailId:Number,flag:int):void
		{
			for(var i:int = 0;i<mails.length;i++)
			{
				if(mails[i].mailId == mailId)
				{
					mails[i].setFetch(flag);
					dispatchEvent(new MailEvent(MailEvent.MAIL_ATTACH_RECEIVE,mailId));
					break;
				}
			}
		}
		
		/**
		 *检查邮件是否超过有效期30天，是则删除 
		 * 
		 */		
		public function checkValid():void
		{
//			var list:Vector.<Number> = new Vector.<Number>();
			var list:Array = [];
			for(var i:int =0 ;i<mails.length;i++)
			{
				if(mails[i].leftDay <= 0)
				{
					list.push(mails[i].mailId);
				}
			}
			clear(list);
			MailClearSocketHandler.sendClear(list);
		}
		
		/**
		 *获取邮件列表 
		 * @param list
		 * 
		 */		
//		public function updates(list:Vector.<MailItemInfo>):void
		public function updates(list:Array):void
		{
			for(var i:int = 0;i<list.length;i++)
			{
				mails.unshift(list[i]);
			}
			currentCount = mails.length;
			dispatchEvent(new MailEvent(MailEvent.MAIL_LOAD_FINISH));
		}
		
		/**
		 * 标志发送成功或失败，用来发出事件更新视图
		 */	
		public function updateSuccess(value:Boolean):void
		{
			dispatchEvent(new MailEvent(MailEvent.MAIL_SEND_RESULT,value));
		}
	}
}