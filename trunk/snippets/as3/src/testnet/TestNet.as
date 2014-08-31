package testnet
{
	import flash.display.Sprite;
	
	[SWF(width="500", height="300")]
	public class TestNet extends Sprite
	{
		public function TestNet()
		{
//			trace("testnet");
			var testnet1:TestNet1=new TestNet1(this);
			testnet1.go();
//			var testnet2:TestNet2=new TestNet2(this);
//			testnet2.go();
//			var testnet3:TestNet3=new TestNet3(this);
//			testnet3.go();
		}
	}
}
