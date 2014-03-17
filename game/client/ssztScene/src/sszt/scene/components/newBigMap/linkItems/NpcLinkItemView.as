package sszt.scene.components.newBigMap.linkItems
{
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.core.data.GlobalData;
    import sszt.core.data.npc.NpcTemplateInfo;
    import sszt.core.manager.LanguageManager;
    import sszt.events.SceneModuleEvent;
    import sszt.module.ModuleEventDispatcher;
    import sszt.scene.checks.WalkChecker;
    import sszt.scene.mediators.BigMapMediator;

    public class NpcLinkItemView extends BaseLinkItemView
    {
        private var _info:NpcTemplateInfo;
        private var _mediator:BigMapMediator;

        public function NpcLinkItemView(info:NpcTemplateInfo, mediator:BigMapMediator)
        {
            this._mediator = mediator;
            this._info = info;
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            if (this._info.funcName != LanguageManager.getWord("ssztl.common.none") && this._info.funcName!="") //LanguageManager.getWord("ssztl.common.none"))
            {
                _itemField.setHtmlValue(this._info.name + "·" + this._info.funcName);
            }
            else
            {
                _itemField.setHtmlValue(this._info.name);
            }
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
            WalkChecker.doWalkToNpc(this._info.templateId);
            this._mediator.sceneInfo.playerList.self.state.setFindPath(true);
        }

        override protected function transferHandler(event:MouseEvent) : void
        {
			super.transferHandler(event);
            ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {sceneId:GlobalData.currentMapId, target:new Point(this._info.sceneX, this._info.sceneY), npcId:this._info.templateId, checkItem:true, checkWalkField:true}));
        }

        override public function dispose() : void
        {
            super.dispose();
            this._info = null;
            this._mediator = null;
        }
    }
}
