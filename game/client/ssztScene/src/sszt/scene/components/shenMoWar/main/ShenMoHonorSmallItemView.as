package sszt.scene.components.shenMoWar.main
{
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.button.MAssetButton;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class ShenMoHonorSmallItemView extends Sprite
	{
		private var _mediator:SceneWarMediator;
		private var _info:ShenMoWarSceneItemInfo;
		
		private var _levelLabel:MAssetLabel;
		private var _numLabel:MAssetLabel;
		
		private var _selectedBorder:SelectedBorder;
		
		private var _selected:Boolean;
		
		public function ShenMoHonorSmallItemView(argMediator:SceneWarMediator,argInfo:ShenMoWarSceneItemInfo)
		{
			super();
			_mediator = argMediator;
			_info = argInfo;
			initialView();
		}
		
		private function initialView():void
		{
			_selectedBorder = new SelectedBorder();
			_selectedBorder.move(-3,-5);
			_selectedBorder.setSize(310,30);
			_selectedBorder.visible = false;
			addChild(_selectedBorder);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_levelLabel.move(3,2);
			addChild(_levelLabel);
			
			var descriptionLabel:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.shenMoWar"),MAssetLabel.LABELTYPE1);
			descriptionLabel.move(95,2);
			addChild(descriptionLabel);
			
			_numLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_numLabel.move(185,2);
			addChild(_numLabel);
			updateData();
		}
		
		private function updateData():void
		{
			_levelLabel.text = "[" + LanguageManager.getWord("ssztl.common.levelValue",_info.minLevel.toString() + "-" +_info.maxLevel.toString()) + "]";
			_numLabel.text = "(" + _info.currentPepNum.toString() + "/" + _info.maxPepNum.toString() + ")";
		}
		
		private function initialEvents():void
		{
			
		}
		
		private function removeEvents():void
		{
			
		}
		
		public function dispose():void
		{
			_mediator = null;
			_info = null;
			_levelLabel = null;
			_numLabel = null;
			_selectedBorder = null;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
				_selectedBorder.visible = true;	
			}
			else
			{
				_selectedBorder.visible = false;
			}
		}

		public function get info():ShenMoWarSceneItemInfo
		{
			return _info;
		}

		public function set info(value:ShenMoWarSceneItemInfo):void
		{
			_info = value;
		}
		
		
	}
}