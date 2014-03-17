package sszt.core.view.cell
{
	import sszt.interfaces.character.ILayerInfo;
	
	public class BaseCompareItemInfoCell extends BaseItemInfoCell
	{
		public function BaseCompareItemInfoCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
	}
}