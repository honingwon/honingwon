package sszt.scene.components.newBigMap.items
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.core.data.npc.NpcTemplateInfo;
    import sszt.core.manager.LanguageManager;
    import sszt.core.view.tips.TipsUtil;
    import sszt.scene.components.newBigMap.CurrentMapView;
    import sszt.ui.container.MSprite;
    import sszt.ui.label.MAssetLabel;

    public class NpcView extends MSprite
    {
        private var _view:Bitmap;
        private var _info:NpcTemplateInfo;
        private var _nameLabel:MAssetLabel;

        public function NpcView(info:NpcTemplateInfo)
        {
            this._info = info;
			super();
        } 

        public function getSceneX() : int
        {
            return this._info.sceneX;
        } 

        public function getSceneY() : int
        {
            return this._info.sceneY;
        } 

        override protected function configUI() : void
        {
            super.configUI();
            this._view = new Bitmap(CurrentMapView.npcPointAsset);
            this._view.x = (-this._view.width) / 2;
            this._view.y = -this._view.height;
            addChild(this._view);
            buttonMode = true;
            if (this._info.funcName == LanguageManager.getWord("ssztl.common.none") ||  this._info.funcName ==  '')
            {
				this._nameLabel = new MAssetLabel(this._info.name, MAssetLabel.LABEL_TYPE1);
            }
			else
			{
				this._nameLabel = new MAssetLabel(this._info.funcName, MAssetLabel.LABEL_TYPE1);
			}
			this._nameLabel.move(this._view.x - (this._nameLabel.textWidth - this._view.width) / 2 - 2, this._view.y - 15);
			addChild(this._nameLabel);
        } 

        private function initEvent() : void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
        } 

        private function removeEvent() : void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
        } 

        private function overHandler(event:MouseEvent) : void
        {
            TipsUtil.getInstance().show(this._info.name, null, new Rectangle(event.stageX, event.stageY, 0, 0));
        } 

        private function outHandler(event:MouseEvent) : void
        {
            TipsUtil.getInstance().hide();
        } 

        public function show(parentContainer:DisplayObjectContainer) : void
        {
            if (parent != parentContainer)
            {
                parentContainer.addChild(this);
            }
        } 

        public function hide() : void
        {
            if (parent)
            {
                parent.removeChild(this);
            }
        } 

        override public function dispose() : void
        {
            this.removeEvent();
            super.dispose();
            this._info = null;
            this._nameLabel = null;
        } 

    }
}
