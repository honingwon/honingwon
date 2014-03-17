package sszt.scene.components.copyGroup
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import mhsm.ui.BarAsset3;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.components.copyGroup.sec.StateCircle;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.ui.ProgressBarGreen;
	
	public class CopyEnterAlert extends MPanel implements ITick
	{
		private var _bg:IMovieWrapper;
		private var _mediator:CopyGroupMediator
		private var _okBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _copyName:MAssetLabel;
		
//		private var _shapes:Vector.<StateCircle>;
		private var _shapes:Array;
		private var _tile:MTile;
		
		private var _progressBar:ProgressBar;
		private var _barBg:BarAsset3;
		private var _start:int = 0;
		private var _count:int = 0;
		
		private var _okNumber:int = 0;
		private var _denyNumber:int = 0;
		
		public function CopyEnterAlert(mediator:CopyGroupMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.common.EnthralTitle2Asset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.common.EnthralTitle2Asset") as Class)());
			}
			super(new MCacheTitle1("",title), true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(269,142);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,269,112)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,34,256,68))
				]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(60,12,90,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.sureEnter"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			
			_copyName = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_copyName.move(155,12);
			addContent(_copyName);
			
			_okBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(12,116);
			addContent(_okBtn);
			
			_cancelBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(185,116);
			addContent(_cancelBtn);
			
			_tile = new MTile(26,26,6);
			_tile.itemGapW = 5;
			_tile.setSize(181,26);
			_tile.move(45,40);
			addContent(_tile);
			
//			_shapes = new Vector.<StateCircle>();
			_shapes = [];
			for(var i:int = 0;i<6;i++)
			{
				var shape:StateCircle = new StateCircle();
				_shapes.push(shape);
				_tile.appendItem(shape);
			}
			
			_progressBar = new ProgressBar(new ProgressBarGreen(),0,30,216,12,true,false);
			_progressBar.move(26,79);
			addContent(_progressBar);
	
			_barBg = new BarAsset3();
			_barBg.width = 248;
			_barBg.height = 19;
			_barBg.x = 11;
			_barBg.y = 75;
			addContent(_barBg);
				
			initEvent();
			GlobalAPI.tickManager.addTick(this);
			_start = getTimer();
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_start  += 1;
			if(_start >= 25)
			{
				_start = 0;
				_count += 1;
				_progressBar.setValue(30,_count);
				if(_count >= 30) dispose();
			}
		}
		
		public function updateValue(ok:int,deny:int):void
		{
			_okNumber = ok;
			_denyNumber = deny;
			for(var i:int = 0;i<_okNumber;i++)
			{
				_shapes[i].state = 1;
			}
			for(var j:int = 5;j> 5 - _denyNumber;j--)
			{
				_shapes[j].state = 2;
			}
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelHandler);
		}
		
		private function removeEvent():void	
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelHandler);
		}
		
		private function okHandler(evt:MouseEvent):void
		{
			if(_okNumber <6)
			{
				_shapes[_okNumber].state = 1;
			}
			_okNumber ++;
		}
		
		private function cancelHandler(evt:MouseEvent):void
		{
			GlobalData.copyEnterCountList.lastCancelTime = getTimer();
			_shapes[5].state = 2;
			_count = 0;
//			dispose();
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			_mediator = null;
			_barBg = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			if(_progressBar)
			{
				_progressBar.dispose();
				_progressBar = null;
			}
			for(var i:int = 0;i<_shapes.length;i++)
			{
				_shapes[i].dispose();
			}
			_shapes = null;
			_copyName = null;
			super.dispose();
		}
	}
}