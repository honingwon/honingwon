package sszt.core.view.tips
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class FightModeTip extends BaseMenuTip
	{
		private static var instance:FightModeTip;
		private var _timeoutIndex:int = -1;
		
		public function FightModeTip()
		{
			super();
		}
		
		public static function getInstance():FightModeTip
		{
			if(instance == null)
			{
				instance = new FightModeTip();
			}
			return instance;
		}
		
		public function show(pos:Point):void
		{
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:FightModeTip = this;
			function showHandler():void
			{
//				setLabels(["和平","全体","善恶","队伍","帮会","阵营"],[0,1,2,3,4,5]);
				var idArr:Array = [0,1,2,3,4,5];
				if(MapTemplateList.isMaya())
					idArr = [-1,1,2,3,4,-1];
				setLabels([LanguageManager.getWord("ssztl.common.peace"),
					LanguageManager.getWord("ssztl.common.free"),
					LanguageManager.getWord("ssztl.common.goodness"),
					LanguageManager.getWord("ssztl.common.team"),
					LanguageManager.getWord("ssztl.common.club"),
					LanguageManager.getWord("ssztl.common.camp")
				],idArr);
				setFilter();
				setPos(pos);
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function setFilter():void
		{
			for(var i:int = 0;i<_menus.length;i++)
			{
				if(_menus[i].id != i)
				{
					_menus[i].enabled = false;
					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
				}
			}
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			if (item.id == 5 && GlobalData.selfPlayer.camp == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.campError1"));
			}
			else
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.CHANGE_PK_MODE,item.id));
		}
		
		private function setPos(pos:Point):void
		{
			this.x = pos.x;
			this.y = pos.y;
		}
	}
}