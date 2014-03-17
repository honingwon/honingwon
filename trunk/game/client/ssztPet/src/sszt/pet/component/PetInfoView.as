package sszt.pet.component
{
	import flash.display.Sprite;

	public class PetInfoView extends Sprite implements IPetView
	{
		public function PetInfoView()
		{
		}
		public function assetsCompleteHandler():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			
		}
	}
}