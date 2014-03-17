package sszt.scene.components.newBigMap.items
{
    import flash.display.*;
    
    import sszt.scene.data.roles.BaseSceneMonsterInfo;
    import sszt.ui.container.MSprite;

    public class MonsterView extends MSprite
    {
        private var _info:BaseSceneMonsterInfo;
        private var _monsterId:Number;

        public function MonsterView(info:BaseSceneMonsterInfo)
        {
            this._info = info;
            this._monsterId = this._info.getObjId();
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            mouseEnabled = false;
            mouseChildren = false;
            graphics.beginFill(16711680);
            graphics.drawCircle(-1, -1, 2);
            graphics.endFill();
        }

        public function get monsterId() : Number
        {
            return this._monsterId;
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
            this._info = null;
            super.dispose();
        }

    }
}
