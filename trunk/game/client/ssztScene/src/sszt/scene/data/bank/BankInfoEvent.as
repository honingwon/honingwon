package sszt.scene.data.bank
{
	import flash.events.Event;
	
	public class BankInfoEvent extends Event
	{
		public static const BANK_INFO_UPDATE:String = 'bankInfoUpdate';
		
		public function BankInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}