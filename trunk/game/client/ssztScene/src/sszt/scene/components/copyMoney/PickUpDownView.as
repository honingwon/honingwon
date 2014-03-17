package sszt.scene.components.copyMoney
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.DateUtil;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.scene.ComboNumberAsset0;
	import ssztui.scene.ComboNumberAsset1;
	import ssztui.scene.ComboNumberAsset2;
	import ssztui.scene.ComboNumberAsset3;
	import ssztui.scene.ComboNumberAsset4;
	import ssztui.scene.ComboNumberAsset5;
	import ssztui.scene.ComboNumberAsset6;
	import ssztui.scene.ComboNumberAsset7;
	import ssztui.scene.ComboNumberAsset8;
	import ssztui.scene.ComboNumberAsset9;
	import ssztui.scene.PickUpDownBgAsset;

	public class PickUpDownView extends MSprite implements ITick
	{
		private var _bg:Bitmap;
		private var _txtBox:MSprite;
		private var _numAssets:Array;
		protected var _updateTime:int;
		private var _time:Number;
		
		public function PickUpDownView()
		{
			super();
		}
		override protected function configUI():void
		{
			_numAssets = [ComboNumberAsset0,ComboNumberAsset1,ComboNumberAsset2,ComboNumberAsset3,ComboNumberAsset4,ComboNumberAsset5,ComboNumberAsset6,ComboNumberAsset7,ComboNumberAsset8,ComboNumberAsset9];
			
			_bg = new Bitmap(new PickUpDownBgAsset());
			_bg.x = -117;
			addChild(_bg);
			
			_txtBox = new MSprite();
			_txtBox.move(-12,-25);
			addChild(_txtBox);
		}
		private function setNumbers(n:Number):void
		{
			while(_txtBox && _txtBox.numChildren>0){
				_txtBox.removeChildAt(0);
			}
			var f:String = n.toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(new _numAssets[int(f.charAt(i))]() as BitmapData);
				mc.x = i*34; 
				_txtBox.addChild(mc);
			}
			_txtBox.move(25-_txtBox.width/2,-25);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - _updateTime >= 1000)
			{
				if(_time > 0)
				{
					_time -= Math.floor((getTimer() - _updateTime) / 1000);
				}else
				{
					GlobalAPI.tickManager.removeTick(this);
					dispatchEvent(new Event(Event.COMPLETE));
					_updateTime = getTimer();
				}
				setNumbers(_time);
				_updateTime = getTimer();
			}
		}
		public function start(seconds:Number):void
		{
			_time = DateUtil.millsecondsToSecond(seconds * 1000);
			setNumbers(_time);
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		public function run():void
		{
			GlobalAPI.tickManager.addTick(this);
		}
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			while(_txtBox && _txtBox.numChildren>0){
				_txtBox.removeChildAt(0);
			}
			_txtBox = null;
			super.dispose();
		}
	}
}