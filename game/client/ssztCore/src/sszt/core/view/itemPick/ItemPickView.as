package sszt.core.view.itemPick
{
    import flash.display.*;
    import flash.geom.*;
    
    import sszt.constData.CommonConfig;
    import sszt.core.data.GlobalAPI;
    import sszt.core.data.GlobalData;
    import sszt.core.data.item.ItemTemplateInfo;
    import sszt.core.view.cell.BaseCell;
    import sszt.interfaces.tick.ITick;

    public class ItemPickView extends Sprite implements ITick
    {
        private var _item:ItemTemplateInfo;
        private var _cell:BaseCell;
        private var _startPos:Point;
        private var _currentPos:Point;
        private var _targetPos:Point;
        private var _baseX:Number;
        private var _baseY:Number;

        public function ItemPickView(item:ItemTemplateInfo, startPos:Point = null)
        {
            this._item = item;
            this._cell = new BaseCell();
            this._cell.info = this._item;
            addChild(this._cell);
            this._targetPos = new Point(GlobalData.bagIconPos.x,GlobalData.bagIconPos.y);
//            if (CommonConfig.GAME_WIDTH > 1265)
//            {
//                this._targetPos.x = 253 + (CommonConfig.GAME_WIDTH - 253 - width) / 2 + 55;
//                this._targetPos.y = CommonConfig.GAME_HEIGHT - 76;
//            }
//            else
//            {
//                this._targetPos.x = (CommonConfig.GAME_WIDTH - width) / 2 + 7 + 55;
//                this._targetPos.y = CommonConfig.GAME_HEIGHT - 76;
//            }
			_startPos  = startPos;
            if (!_startPos)
            {
				_startPos = new Point((CommonConfig.GAME_WIDTH - this._cell.width) / 2, (CommonConfig.GAME_HEIGHT - this._cell.height) / 2);
            }
            var _loc_3:* = Point.distance(_startPos, this._targetPos);
            this._baseX = 15 * (this._targetPos.x - _startPos.x) / _loc_3;
            this._baseY = 15 * (this._targetPos.y - _startPos.y) / _loc_3;
            this.x = _startPos.x;
            this.y = _startPos.y;
            GlobalAPI.tickManager.addTick(this);
        }

        public function update(times:int, dt:Number = 0.04) : void
        {
            if (this.y > CommonConfig.GAME_HEIGHT - 92)
            {
                GlobalAPI.tickManager.removeTick(this);
                this.dispose();
            }
            else
            {
                this.x = this.x + this._baseX;
                this.y = this.y + this._baseY;
            }
        }

        public function dispose() : void
        {
            if (this._cell)
            {
                this._cell.dispose();
            }
            if (parent)
            {
                parent.removeChild(this);
            }
        }

    }
}
