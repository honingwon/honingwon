package sszt.core.data.furnace
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;

	public class FormulaInfo
	{
		public var typeId:int;
		public var formulaDataId:int;
		public var outputId:int;
		public var outputName:String;
		public var sortId:int;
		
		public function parseData(argData:ByteArray):void
		{
			typeId = argData.readInt();
			formulaDataId = argData.readInt();
			outputId = argData.readInt();
			outputName = argData.readUTF();
			sortId = argData.readInt();
		}
		
		public function getTempalteInfo():ItemTemplateInfo
		{
			return ItemTemplateList.getTemplate(outputId);
		}
	}
}