package
{
	import fl.core.InvalidationType;
	
	import sszt.ui.container.MSprite;

	public class Test extends MSprite
	{
		public function Test()
		{
			super();
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STATE))
			{
				trace(2);
				
			}
			super.draw();
			trace(1);
		}
	}
}