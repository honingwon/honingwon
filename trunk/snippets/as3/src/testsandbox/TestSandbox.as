package testsandbox
{
	import flash.display.Sprite;
	import flash.system.Security;
	
	public class TestSandbox extends Sprite
	{
		public function TestSandbox()
		{
			trace(Security.sandboxType);
		}
	}
}
