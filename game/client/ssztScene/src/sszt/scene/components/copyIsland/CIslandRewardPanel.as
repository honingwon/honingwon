package sszt.scene.components.copyIsland
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.copyIsland.CIMaininfo;
	import sszt.scene.data.copyIsland.CIRewardInfo;
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	
	public class CIslandRewardPanel extends Sprite implements IcopyIslandPanel
	{
		private var _mediator:SceneMediator;
		private var _currentExpLabel:MAssetLabel;
		private var _allExpLabel:MAssetLabel;
		private var _currentLifeExpLabel:MAssetLabel;
		private var _allLiftExpLabel:MAssetLabel;
		private var _shape:Shape;
		public function CIslandRewardPanel(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			mouseChildren = mouseEnabled = false;
			_shape = new Shape();
			_shape.graphics.beginFill(0,0.6);
			_shape.graphics.drawRect(0,0,200,120);
			_shape.graphics.endFill();
			_shape.x = 10;
			_shape.y = 0;
			addChild(_shape);
			var label:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.curFloorExpAward"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			label.textColor = 0xff9d34;
			label.move(16,9);
			addChild(label);
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.totalExpAward"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			label1.textColor = 0xff9d34;
			label1.move(16,27);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.curFloorLifeExpAward"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			label2.move(16,45);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.totalLifeExpAward"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			label3.move(16,63);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.getMoreAwardDescript"),MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			label4.move(16,81);
			addChild(label4);
			
			_currentExpLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_currentExpLabel.move(110,9);
			addChild(_currentExpLabel);
			
			_allExpLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_allExpLabel.move(110,27);
			addChild(_allExpLabel);
			
			_currentLifeExpLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_currentLifeExpLabel.move(110,45);
			addChild(_currentLifeExpLabel);
			
			_allLiftExpLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.LEFT);
			_allLiftExpLabel.move(110,63);
			addChild(_allLiftExpLabel);
		}
		
		private function initEvents():void
		{
			cIMaininfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_MAININFO_UPDATE,updateHandler);
		}
		
		private function removeEvents():void
		{
			cIMaininfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_MAININFO_UPDATE,updateHandler);
		}
		
		private function updateHandler(e:SceneCopyIslandUpdateEvent):void
		{
			if(!cIMaininfo)return;
			_currentExpLabel.text = cIMaininfo.singleExp.toString();
			_allExpLabel.text = cIMaininfo.allExp.toString();
			_currentLifeExpLabel.text = cIMaininfo.singleLifeExp.toString();
			_allLiftExpLabel.text = cIMaininfo.allLifeExp.toString();
		}
		
		public function show():void
		{
			updateHandler(null);
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function get cIMaininfo():CIMaininfo
		{
			return _mediator.copyIslandInfo.cIMainInfo;
		}

		public function move(argX:int, argY:int):void
		{
			this.x = argX;
			this.y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			 _mediator = null;
			 _currentExpLabel = null;
			 _allExpLabel = null;
			 _currentLifeExpLabel = null;
			 _allLiftExpLabel = null;
			 _shape = null;
			if(parent)parent.removeChild(this);
		}
	}
}