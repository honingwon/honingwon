package sszt.scene.components.newBigMap.items
{
    import flash.display.*;
    
    import sszt.core.utils.AssetUtil;
    import sszt.scene.components.newBigMap.CurrentMapView;
    import sszt.scene.data.roles.BaseScenePlayerInfo;
    import sszt.ui.container.MSprite;

    public class PlayerView extends MSprite
    {
        private var _info:BaseScenePlayerInfo;
        private var _playerId:Number;
        private var _view:MovieClip;

        public function PlayerView(playerInfo:BaseScenePlayerInfo)
        {
            this._info = playerInfo;
            this._playerId = this._info.getObjId();
			super();
        } 

        override protected function configUI() : void
        {
            super.configUI();
            mouseEnabled = false;
            mouseChildren = false;
//            this._view = new Bitmap(CurrentMapView.playerPointAsset);
			this._view = AssetUtil.getAsset("ssztui.scene.BigmapLittleMeAsset", MovieClip) as MovieClip
//            this._view.x = -13;
//            this._view.y = -13;
            addChild(this._view);
        } 

        public function get playerId() : Number
        {
            return this._playerId;
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
            this._info = null;
        } 
    }
}
