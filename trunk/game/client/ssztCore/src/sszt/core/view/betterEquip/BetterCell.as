package sszt.core.view.betterEquip
{
    import flash.events.*;
    import flash.geom.*;
    
    import sszt.constData.CategoryType;
    import sszt.core.data.GlobalData;
    import sszt.core.view.cell.BaseItemInfoCell;
    import sszt.core.view.tips.TipsUtil;

    public class BetterCell extends BaseItemInfoCell
    {

        public function BetterCell()
        {
        } 

        override protected function showTipHandler(event:MouseEvent) : void
        {
            if (_iteminfo)
            {
                if (CategoryType.isWeapon(_iteminfo.template.categoryId))
                {
                    TipsUtil.getInstance().show(_iteminfo, GlobalData.bagInfo.getItem(1), new Rectangle(this.localToGlobal(new Point(_figureBound.x, _figureBound.y)).x, this.localToGlobal(new Point(_figureBound.x, _figureBound.y)).y, _figureBound.width, _figureBound.height));
                }
                else
                {
                    TipsUtil.getInstance().show(_iteminfo, GlobalData.bagInfo.getEquipByCategory(_iteminfo.template.categoryId), new Rectangle(this.localToGlobal(new Point(_figureBound.x, _figureBound.y)).x, this.localToGlobal(new Point(_figureBound.x, _figureBound.y)).y, _figureBound.width, _figureBound.height));
                }
            }
        } 

    }
}
