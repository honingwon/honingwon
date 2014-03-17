package sszt.scene.components.newBigMap.items
{
    
    import sszt.core.view.assets.AssetSource;
    import sszt.ui.button.MBitmapButton;

    public class TransferBtn extends MBitmapButton
    {
        public var mapId:int;
        public var sceneX:int;
        public var sceneY:int;

        public function TransferBtn()
        {
            super(AssetSource.getTransferShoes());
        } 

        public function show(mapId:int, sceneX:int, sceneY:int, x:int, y:int) : void
        {
            this.mapId = mapId;
            this.sceneX = sceneX;
            this.sceneY = sceneY;
            move(x - width / 2, y - height / 2);
            visible = true;
        } 

    }
}
