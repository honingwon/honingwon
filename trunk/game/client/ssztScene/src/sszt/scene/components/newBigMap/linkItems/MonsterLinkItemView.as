package sszt.scene.components.newBigMap.linkItems
{
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.core.data.GlobalData;
    import sszt.core.data.monster.MonsterTemplateInfo;
    import sszt.events.SceneModuleEvent;
    import sszt.module.ModuleEventDispatcher;
    import sszt.scene.checks.WalkChecker;
    import sszt.scene.mediators.BigMapMediator;

    public class MonsterLinkItemView extends BaseLinkItemView
    {
        private var _info:MonsterTemplateInfo;
        private var _mediator:BigMapMediator;

        public function MonsterLinkItemView(info:MonsterTemplateInfo, mediator:BigMapMediator)
        {
            this._mediator = mediator;
            this._info = info;
			super();
        }

        override protected function linkClickHandler(event:MouseEvent) : void
        {
//            if (!GlobalData.isInCruise)
//            {
//            }
//            if (GlobalData.isInWedding)
//            {
//                QuickTips.show(LanguageManager.getWord("mhsm.scene.cannotOperate"));
//                return;
//            }
			
//            WalkChecker.doWalkToHangup(this._info.monsterId);
            this._mediator.sceneInfo.playerList.self.state.setFindPath(true);
        }

        override protected function transferHandler(event:MouseEvent) : void
        {
			super.transferHandler(event);
            ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {sceneId:GlobalData.currentMapId, target:new Point(this._info.centerX, this._info.centerY), checkItem:true, checkWalkField:true, type:2, targetID:this._info.monsterId}));
        }

        override protected function configUI() : void
        {
            super.configUI();
            _itemField.setHtmlValue("<font color=\'#00ff00\'><u><a href=\'event:0\'>" + this._info.name + "</a></u></font>");
        }

        override public function dispose() : void
        {
            super.dispose();
            this._mediator = null;
            this._info = null;
        }

    }
}
