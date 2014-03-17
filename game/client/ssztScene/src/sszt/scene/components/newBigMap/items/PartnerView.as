package sszt.scene.components.newBigMap.items
{
    import flash.display.*;
    
    import sszt.core.utils.AssetUtil;
    import sszt.scene.components.newBigMap.CurrentMapView;
    import sszt.scene.data.roles.BaseScenePlayerInfo;
    import sszt.ui.container.MSprite;
    import sszt.ui.label.MAssetLabel;

    public class PartnerView extends MSprite
    {
        private var _playerId:Number;
        private var _view:Bitmap;
		private var _nameLabel:MAssetLabel;

        public function PartnerView()
        {
			super();
        } 

        override protected function configUI() : void
        {
            super.configUI();
            mouseEnabled = false;
            mouseChildren = false;
			_view = new Bitmap(AssetUtil.getAsset("ssztui.scene.MapTeamPointAsset") as BitmapData);
            addChild(this._view);
			_nameLabel = new MAssetLabel("", MAssetLabel.LABELTYPE13);
			addChild(this._nameLabel);
        } 

        public function get playerId() : Number
        {
            return this._playerId;
        } 

		public function setName(value:String):void
		{
			_nameLabel.setValue(value);
			_nameLabel.move(this._view.x - (this._nameLabel.textWidth - this._view.width) / 2 - 2, this._view.y - 15);
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
            super.dispose();
            this._nameLabel = null;
			this._view = null;
        } 
    }
}
