package sszt.core.view.cell
{
	import sszt.interfaces.character.ILayerInfo;
	
	public class BaseCompareCell extends BaseCell
	{
		public function BaseCompareCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
	}
}