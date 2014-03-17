package sszt.scene.components.newBigMap.items
{
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;

    public class MonsterPointView extends MSprite
    {
        private var _nameLabel:MAssetLabel;
        private var _info:MonsterTemplateInfo;

        public function MonsterPointView(info:MonsterTemplateInfo)
        {
            this._info = info;
			super();
        } 

        override protected function configUI() : void
        {
            super.configUI();
            var _loc_1:Boolean = false;
            mouseEnabled = false;
            mouseChildren = _loc_1;
            this._nameLabel = new MAssetLabel(this._info.name + "(" + this._info.level + ")", MAssetLabel.LABEL_TYPE1);
			this._nameLabel.textColor = 0xff4747;
            this._nameLabel.move((-this._nameLabel.textWidth) / 2 - 2, (-this._nameLabel.height) / 2);
            addChild(this._nameLabel);
        } 

        override public function dispose() : void
        {
            this._info = null;
            this._nameLabel = null;
            super.dispose();
        } 

    }
}
