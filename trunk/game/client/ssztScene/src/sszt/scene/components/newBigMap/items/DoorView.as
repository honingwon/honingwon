package sszt.scene.components.newBigMap.items
{
    import flash.display.*;
    
    import sszt.core.data.scene.DoorTemplateInfo;
    import sszt.scene.components.newBigMap.CurrentMapView;
    import sszt.ui.container.MSprite;
    import sszt.ui.label.MAssetLabel;

    public class DoorView extends MSprite
    {
        private var _info:DoorTemplateInfo;
        private var _view:Bitmap;
        private var _nameLabel:MAssetLabel;

        public function DoorView(info:DoorTemplateInfo)
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
            this._view = new Bitmap(CurrentMapView.jumpPointAsset);
            this._view.x = (-this._view.width) / 2;
            this._view.y = (-this._view.height) / 2;
            addChild(this._view);
            buttonMode = true;
            this._nameLabel = new MAssetLabel(this._info.getDoorName(), MAssetLabel.LABEL_TYPE1);
			this._nameLabel.textColor = 0xffcc00;
            this._nameLabel.move(this._view.x - (this._nameLabel.textWidth - this._view.width) / 2 - 2, this._view.y - 15);
            addChild(this._nameLabel);
            return;
        }

        override public function dispose() : void
        {
            super.dispose();
            this._info = null;
            this._nameLabel = null;
            return;
        }

    }
}
