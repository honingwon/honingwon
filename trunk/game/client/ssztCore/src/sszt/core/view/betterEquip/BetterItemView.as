package sszt.core.view.betterEquip
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Rectangle;
    import flash.text.*;
    
    import sszt.constData.CategoryType;
    import sszt.constData.CommonBagType;
    import sszt.core.data.item.ItemInfo;
    import sszt.core.manager.LanguageManager;
    import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
    import sszt.interfaces.moviewrapper.IMovieWrapper;
    import sszt.ui.backgroundUtil.BackgroundInfo;
    import sszt.ui.backgroundUtil.BackgroundType;
    import sszt.ui.backgroundUtil.BackgroundUtils;
    import sszt.ui.label.MAssetLabel;
    import sszt.ui.mcache.btns.MCacheAssetBtn1;
    import sszt.ui.mcache.cells.CellCaches;

    public class BetterItemView extends Sprite
    {
        private var _cell:BetterCell;
        private var _itemInfo:ItemInfo;
        private var _label:MAssetLabel;
        private var _btn:MCacheAssetBtn1;
        private var _bg:IMovieWrapper;

        public function BetterItemView(item:ItemInfo)
        {
            this._itemInfo = item;
            this.init();
        }

        private function init() : void
        {
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14, new Rectangle(0,0,192,50)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,6,38,38),new Bitmap(CellCaches.getCellBg())),
				
			]);
			addChild(_bg as DisplayObject);
			
            this._cell = new BetterCell();
            this._cell.move(5, 6);
            addChild(this._cell);
            this._cell.itemInfo = this._itemInfo;
			
            this._label = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
            this._label.move(51, 17);
            addChild(this._label);
            this._label.textColor = CategoryType.getQualityColor(this._itemInfo.template.quality);
            this._label.text = this._itemInfo.template.name;
			
            this._btn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.equip2"));
            this._btn.move(142, 14);
            addChild(this._btn);
            this.initEvent();
        }

        private function initEvent() : void
        {
            this._btn.addEventListener(MouseEvent.CLICK, this.clickHandler);
        }

        private function removeEvent() : void
        {
            this._btn.removeEventListener(MouseEvent.CLICK, this.clickHandler);
        }

        public function get itemInfo() : ItemInfo
        {
            return this._itemInfo;
        }

        private function clickHandler(event:MouseEvent) : void
        {
//            if (GlobalData.securityType == SecurityType.LOCKED)
//            {
//                SecurityUnlockPanel.show();
//                return;
//            }
//            if (GlobalData.selfPlayer.isShapeShifting)
//            {
//                QuickTips.show(LanguageManager.getWord("mhsm.common.shapeShiftCannotEquip"));
//                return;
//            }
            ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG, this._itemInfo.place, CommonBagType.BAG, 29, 1);
            dispatchEvent(new Event(Event.CLOSE));
        }

        public function dispose() : void
        {
            this.removeEvent();
            if (this._cell)
            {
                this._cell.dispose();
                this._cell = null;
            }
            this._bg = null;
            this._label = null;
            if (this._btn)
            {
                this._btn.dispose();
                this._btn = null;
            }
            if (parent)
            {
                parent.removeChild(this);
            }
        }

    }
}
