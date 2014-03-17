package sszt.scene.components.nearly
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.data.roles.NpcRoleInfo;
	import sszt.scene.mediators.NearlyMediator;
	
	public class NearlyNpcTabView extends BaseNearlyTabView
	{
		private var _tile:MTile;
//		private var _items:Vector.<NearlyNpcItemView>;
		private var _items:Array;
		private var _currentItem:NearlyNpcItemView;
		private var _autoMoveBtn:MCacheAsset1Btn;
		
		public function NearlyNpcTabView(mediator:NearlyMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			super.init();
			
			_tile = new MTile(280,22);
			_tile.verticalScrollPolicy = ScrollPolicy.ON;
			_tile.setSize(301,312);
			_tile.move(0,8);
			addChild(_tile);
			
			_autoMoveBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.autoMove"));
			_autoMoveBtn.move(110,359);
			addChild(_autoMoveBtn);
			
//			_items = new Vector.<NearlyNpcItemView>();
			_items = [];
			
			initData();
		}
		
		private function initData():void
		{
//			var list:Vector.<NpcRoleInfo> = _mediator.sceneInfo.mapInfo.npcList;
			var list:Array = _mediator.sceneInfo.mapInfo.npcList;
			for(var i:int =0;i<list.length;i++)
			{
				var itemView:NearlyNpcItemView = new NearlyNpcItemView(list[i],_mediator);
				itemView.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_tile.appendItem(itemView);
				_items.push(itemView);
			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_autoMoveBtn.addEventListener(MouseEvent.CLICK,autoMoveHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_autoMoveBtn.removeEventListener(MouseEvent.CLICK,autoMoveHandler);
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var item:NearlyNpcItemView = evt.currentTarget as NearlyNpcItemView;
			DoubleClickManager.addClick(item);
			if(_currentItem == item) return;
			if(_currentItem) _currentItem.selected = false;
			_currentItem = item;
			_currentItem.selected = true;
		}
		
		private function autoMoveHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_currentItem)
			{
				if(GlobalData.copyEnterCountList.isInCopy || _mediator.sceneInfo.mapInfo.isSpaScene())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
					return;
				}
//				_mediator.sceneModule.sceneInit.walkToNpc(_currentItem.info.template.templateId);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			_autoMoveBtn.dispose();
			_autoMoveBtn = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;	
			}
			for(var i:int =0;i<_items.length;i++)
			{
				_items[i].dispose();
			}
			_items = null;
			_currentItem = null;
			super.dispose();
		}
	}
}