package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TestEventFlow extends Sprite
	{
		public function TestEventFlow()
		{
			stage.addEventListener(MouseEvent.CLICK, onStageClick);
			
			var text:TextField = new TextField();
			text.text = 'test';
			addChild(text);
			text.border = true;
			text.borderColor = 0xff0000;
			text.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
//				e.stopPropagation();
				stage.removeEventListener(MouseEvent.CLICK, onStageClick);
				trace('text clicked');
			});
			
		}
		
		private function onStageClick(e:MouseEvent):void
		{
			trace('stage clicked')
		}
	}
}