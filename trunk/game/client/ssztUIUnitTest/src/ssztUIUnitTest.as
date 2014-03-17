package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;
	
	import net.hires.debug.Stats;
	
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	
	[SWF(width=1024,height=800,backgroundColor=0xffffff,frameRate=25)]
	public class ssztUIUnitTest extends Sprite
	{
		
		private var _panel:MPanel;
		
		public function ssztUIUnitTest()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
						
			ssztPrepare();
						
		}
		
		private function test():void
		{
			var b:ByteArray = new ByteArray;
			b.compress();
		
			_panel = new BagPanel();
			_panel.x = 300;
			addChild(_panel);
			
			
			var msp:MScrollPanel = new MScrollPanel();
			
			addChild(msp);
			
//			addChild(bt);
		}
		
		
		private function ssztPrepare():void
		{
			var t:ssztPrepareUIUnitTesxt = new ssztPrepareUIUnitTesxt(prepareComplete);
			t.setup(this);
		}
		
		private function prepareComplete(param:Object):void
		{
			var t:ssztGameUIUnitTesxt = new ssztGameUIUnitTesxt();
			t.preSetup(param);
			addChild(t);
			t.setup();
			var s:Stats = new Stats();
			s.y = 150;
			addChild(s);
			
			test();
		}
		
	}
}