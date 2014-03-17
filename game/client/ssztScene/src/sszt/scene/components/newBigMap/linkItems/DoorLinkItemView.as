package sszt.scene.components.newBigMap.linkItems
{
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.core.data.GlobalData;
    import sszt.core.data.scene.DoorTemplateInfo;
    import sszt.events.SceneModuleEvent;
    import sszt.module.ModuleEventDispatcher;
    import sszt.scene.checks.WalkChecker;
    import sszt.scene.mediators.BigMapMediator;

    public class DoorLinkItemView extends BaseLinkItemView
    {
        private var _info:DoorTemplateInfo;
        private var _mediator:BigMapMediator;

        public function DoorLinkItemView(info:DoorTemplateInfo, mediator:BigMapMediator)
        {
            this._info = info;
            this._mediator = mediator;
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            _itemField.setHtmlValue(this._info.getDoorName());
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
            WalkChecker.doWalkToDoor(this._info.templateId);
            this._mediator.sceneInfo.playerList.self.state.setFindPath(true);
        }

        override protected function transferHandler(event:MouseEvent) : void
        {
			super.transferHandler(event);
            ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {sceneId:GlobalData.currentMapId, target:new Point(this._info.sceneX, this._info.sceneY), checkItem:true, checkWalkField:true, type:4}));
        }

        override public function dispose() : void
        {
            this._info = null;
            this._mediator = null;
            super.dispose();
        }

    }
}
