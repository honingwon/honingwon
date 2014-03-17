package sszt.activity.socketHandlers
{
	import flash.utils.Dictionary;
	
	import sszt.activity.ActivityModule;
	import sszt.activity.data.BossItemInfo;
	import sszt.constData.BossType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.BossTemplateInfo;
	import sszt.core.data.activity.BossTemplateInfoList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BossInfoSocketHandler extends BaseSocketHandler
	{
		public function BossInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BOSS_INFO;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var i:int;
			var list:Dictionary = new Dictionary;
			var bossItemInfo:BossItemInfo;
			for(i = 0; i < len; i++)
			{
				bossItemInfo = new BossItemInfo();
				bossItemInfo.bossId = _data.readInt();
				bossItemInfo.isLive = _data.readBoolean();
				bossItemInfo.deadTime = _data.readInt();
				//boss死亡才会计算剩余刷新时间
				if(!bossItemInfo.isLive)
				{
					var bossTemplateInfo:BossTemplateInfo = BossTemplateInfoList.getBoss(bossItemInfo.bossId);
					if(bossTemplateInfo.type == BossType.INTERVAL)
					{
						bossItemInfo.intervalRemaining = getIntervalRemaining(bossTemplateInfo.interval, bossItemInfo.deadTime);
					}
					else
					{
						bossItemInfo.nextTime = getNextTime(bossTemplateInfo.constant);
					}
				}
				list[bossItemInfo.bossId] = bossItemInfo;
			}
			module.activityInfo.updateBossList(list);
				
			handComplete();
		}
		
		/**
		 * 获取固定间隔时间刷新BOSS刷新剩余时间
		 * @return 单位：秒
		 */
		private function getIntervalRemaining(interval:int, deadTime:int):int
		{
			//过去的时间，秒
			var passedTime:int = GlobalData.systemDate.getSystemDate().time / 1000 - deadTime;
			return interval - passedTime;
		}
		
		/**
		 * 获取固定时间点刷新BOSS下一个刷新时间点
		 * @param constant 固定时间点刷新类boss刷新时间点组 (11:11,11:12 ...)
		 * @return
		 */
		private function getNextTime(constant:Array):String
		{
			var now:Date =  GlobalData.systemDate.getSystemDate();
			var nowHour:int = now.hours;
			var nowMinutes:int = now.minutes;
			var hour:int;
			var minutes:int;
			var i:int;
			var tmp:Array;
			var flag:Boolean;
			for(i = 0; i < constant.length; i++)
			{
				tmp = (constant[i] as String).split(':');
				hour = tmp[0];
				minutes = tmp[1];
				if((hour * 60 + minutes) > (nowHour * 60 + nowMinutes))
				{
					flag = true;
					break;
				}
			}
			if(!flag) i = 0;
			return constant[i] + ':00';
		}
		
		private function get module():ActivityModule
		{
			return _handlerData as ActivityModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BOSS_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}