package sszt.scene.components.cityCraft
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.core.view.tips.TipsUtil;
    import sszt.scene.components.newBigMap.CurrentMapView;
    import sszt.ui.container.MSprite;
    import sszt.ui.label.MAssetLabel;

    public class GuardView extends MSprite
    {
        private var _view:Bitmap;
        private var _name:String;
		private var _guardType:String="无";
        private var _nameLabel:MAssetLabel;

        public function GuardView(name:String)
        {
            _name = name;
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            this._view = new Bitmap(CurrentMapView.npcPointAsset);
            this._view.x = (-this._view.width) / 2;
            this._view.y = -this._view.height;
            addChild(this._view);
			
            this._nameLabel = new MAssetLabel(_name, MAssetLabel.LABEL_TYPE1);			
			this._nameLabel.move(this._view.x - (this._nameLabel.textWidth - this._view.width) / 2 - 2, this._view.y - 15);
			addChild(this._nameLabel);
        }
		
		public function set guardType(value:String):void
		{
			_guardType = value;
			_nameLabel.setValue(_name+":"+_guardType);
		}
		
		public function get guardType():String
		{
			return _guardType;
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
        } 

    }
}
