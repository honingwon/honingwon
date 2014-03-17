package sszt.core.view.itemPick
{
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.getTimer;
    
    import sszt.core.data.GlobalAPI;
    import sszt.core.data.item.ItemTemplateInfo;
    import sszt.core.data.item.ItemTemplateList;
    import sszt.core.view.itemPick.ItemPickInfo;
    import sszt.core.view.itemPick.ItemPickView;
    import sszt.interfaces.tick.ITick;

    public class ItemPickManager extends Sprite implements ITick
    {
        private var _items:Array;
        private var _startTime:Number;
        private static var _instance:ItemPickManager;

        public function ItemPickManager()
        {
            this._items = [];
        }

		public static function getInstance() : ItemPickManager
		{
			if (!_instance)
			{
				_instance = new ItemPickManager;
			}
			return _instance;
		}
		
        public function pickItem(itemTempId:int, point:Point = null) : void
        {
            var itemTemplateInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(itemTempId);
            var itemPickInfo:ItemPickInfo = new ItemPickInfo();
			itemPickInfo.itemTempInfo = itemTemplateInfo;
			itemPickInfo.pickPoint = point;
            if (this._items.length == 0)
            {
                this._startTime = getTimer();
                this._items.push(itemPickInfo);
                GlobalAPI.tickManager.addTick(this);
            }
            else if (this._items.length < 10)
            {
                this._items.push(itemPickInfo);
            }
        }

        public function update(times:int, dt:Number = 0.04) : void
        {
            var itemPickInfo:ItemPickInfo = null;
            var itemPickView:ItemPickView = null;
            if (getTimer() - this._startTime > 150)
            {
                this._startTime = getTimer();
				itemPickInfo = this._items.shift() as ItemPickInfo;
                if (itemPickInfo&&itemPickInfo.itemTempInfo.categoryId!=531)//宝箱不出现
                {
					itemPickView = new ItemPickView(itemPickInfo.itemTempInfo, itemPickInfo.pickPoint);
                    GlobalAPI.layerManager.getTipLayer().addChild(itemPickView);
                }
                else
                {
                    GlobalAPI.tickManager.removeTick(this);
                    this._items.length = 0;
                }
            }
        }

       

    }
}
