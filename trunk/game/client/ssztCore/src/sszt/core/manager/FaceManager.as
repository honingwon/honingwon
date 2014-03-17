package sszt.core.manager
{
	import flash.display.Bitmap;
	
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.view.effects.BaseEffect;
	import sszt.interfaces.loader.IDataFileInfo;

	public class FaceManager
	{
		public static const FACE1:MovieTemplateInfo = new MovieTemplateInfo(987001,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],10000000000);
		public static const FACE2:MovieTemplateInfo = new MovieTemplateInfo(987002,[2,2,2,2,3,3,3,3,4,4,4,4],10000000000);
		public static const FACE3:MovieTemplateInfo = new MovieTemplateInfo(987003,[5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8],10000000000);
		public static const FACE4:MovieTemplateInfo = new MovieTemplateInfo(987004,[9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,12,12,12,12,12,12,13,13,13,13,13,13,14,14],10000000000);
		public static const FACE5:MovieTemplateInfo = new MovieTemplateInfo(987005,[15,15,15,15,16,16,16,16],10000000000);
		public static const FACE6:MovieTemplateInfo = new MovieTemplateInfo(987006,[17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26],10000000000);
		public static const FACE7:MovieTemplateInfo = new MovieTemplateInfo(987007,[27,27,28,28],10000000000);
		public static const FACE8:MovieTemplateInfo = new MovieTemplateInfo(987008,[29,29,29,29,29,29,30,30,30,30,30,30],10000000000);
		public static const FACE9:MovieTemplateInfo = new MovieTemplateInfo(987009,[31,31,32,32,33,33,34,34,35,35,36,36,37,37],10000000000);
		public static const FACE10:MovieTemplateInfo = new MovieTemplateInfo(987010,[38,38,38,38,38,38,39,39,39,39,39,39],10000000000);
		public static const FACE11:MovieTemplateInfo = new MovieTemplateInfo(987011,[40,40,40,40,41,41,41,41],10000000000);
		public static const FACE12:MovieTemplateInfo = new MovieTemplateInfo(987012,[42,42,43,43,44,44,45,45],10000000000);
		public static const FACE13:MovieTemplateInfo = new MovieTemplateInfo(987013,[46,46,47,47,48,48,49,49],10000000000);
		public static const FACE14:MovieTemplateInfo = new MovieTemplateInfo(987014,[50,50,51,51],10000000000);
		public static const FACE15:MovieTemplateInfo = new MovieTemplateInfo(987015,[52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63,64,64,65,65,66,66,67,67,68,68,69,69,70,70],10000000000);
		public static const FACE16:MovieTemplateInfo = new MovieTemplateInfo(987016,[71,71,72,72],10000000000);
		public static const FACE17:MovieTemplateInfo = new MovieTemplateInfo(987017,[73,73,74,74],10000000000);
		public static const FACE18:MovieTemplateInfo = new MovieTemplateInfo(987018,[75,75,75,75,75,75,76,76,76,76,76,76,77,77,77,77,77,77,78,78,78,78,78,78],10000000000);
		public static const FACE19:MovieTemplateInfo = new MovieTemplateInfo(987019,[79,79,80,80,81,81,82,82],10000000000);
		public static const FACE20:MovieTemplateInfo = new MovieTemplateInfo(987020,[83,83,83,83,83,83,84,84,84,84,84,84,85,85,85,85,85,85,86,86,86,86,86,86,87,87,87,87,87,87,88,88,88,88,88,88,89,89,89,89,89,89,89,89,89,89,89,89,90,90,91,91,92,92,93,93,97,97,95,95,96,96,97,97,98,98,99,99],10000000000);
		public static const FACE21:MovieTemplateInfo = new MovieTemplateInfo(987021,[100,100,101,101,102,102,103,103,104,104,105,105,105,105,105,105,105,105],10000000000);
		public static const FACE22:MovieTemplateInfo = new MovieTemplateInfo(987022,[106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,106,107,107,108,108,109,109,110,110,111,111,112,112,112,112,112,112,112,112,112,112],10000000000);
		public static const FACE23:MovieTemplateInfo = new MovieTemplateInfo(987023,[113,113,114,114,115,115,116,116,117,117,118,118,119,119,120,120],10000000000);
		public static const FACE24:MovieTemplateInfo = new MovieTemplateInfo(987024,[121,121,121,121,121,121,122,122,122,122,122,122,123,123,123,123,123,123,124,124,124,124,124,124,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125,125],10000000000);
		public static const FACE25:MovieTemplateInfo = new MovieTemplateInfo(987025,[126,126,127,127,128,128,129,129,130,130,131,131,132,132,133,133,134,134,135,135,136,136],10000000000);
		public static const FACE26:MovieTemplateInfo = new MovieTemplateInfo(987026,[137,137,138,138,137,137,138,138,137,137,138,138,137,137,138,138,137,137,138,138,139,139,140,140,141,141,143,143,142,142,143,143,142,142,143,143,142,142,143,143,142,142,143,143,144,144,145,145,146,146,138,138],10000000000);
		public static const FACE27:MovieTemplateInfo = new MovieTemplateInfo(987027,[147,147,147,147,147,147,147,147,147,147,147,147,148,148,149,149,149,149,149,149,149,149,149,149,149,149,147,147,149,149,148,148,149,149,147,147,149,149,147,147,147,147,147,147,147,147,147,147,147,147,148,148,148,148,148,148,150,150,150,150,150,150,151,151,151,151,151,151,152,152,152,152,152,152,153,153,153,153,153,153,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154,154],10000000000);
		public static const FACE28:MovieTemplateInfo = new MovieTemplateInfo(987028,[155,155,156,156,156,156,156,156,156,156,155,155,155,155,155,155,155,155,156,156,157,157,158,158,157,157,158,158],10000000000);
		public static const FACE29:MovieTemplateInfo = new MovieTemplateInfo(987029,[159,159,160,160,161,161,162,162,163,163,164,164,165,165,166,166,167,167,168,168,169,169,170,170,171,171,172,172,172,172,172,172],10000000000);
		public static const FACE30:MovieTemplateInfo = new MovieTemplateInfo(987030,[173,173,173,173,173,173,174,174,174,174,174,174,175,175,176,176,175,175,176,176,175,175,176,176,177,177,177,177,178,178,178,178,179,179,179,179,177,177,177,177,178,178,178,178,179,179,179,179,177,177,177,177,178,178,178,178,179,179,179,179],10000000000);
		public static const FACE31:MovieTemplateInfo = new MovieTemplateInfo(987031,[180,180,180,180,180,180,181,182,181,182,183,183,184,184,185,185,186,186,187,187,188,188,189,189,190,190,191,191,192,192,193,193,194,194,195,195,196,196,197,197,198,198,199,199,200,200,201,201,202,202,203,203,204,204,205,205,206,206,207,207,208,208,209,209,209,209,209,209,209,209],10000000000);
		public static const FACE32:MovieTemplateInfo = new MovieTemplateInfo(987032,[210,210,210,210,211,211,211,211,212,212,212,212,213,213,214,214,215,215,214,214,215,215,214,214,214,214],10000000000);
		public static const FACE33:MovieTemplateInfo = new MovieTemplateInfo(987033,[216,216,216,216,216,216,216,216,216,216,216,216,217,217,218,218,219,219,220,220,221,221,222,222,223,223,224,224,225,225,225,225,225,225,225,225,225,225,225,225,225,225,225,225,225,225,225,225,224,224,223,223,222,222,221,221,220,220,219,219,218,218,217,217,216,216,216,216,216,216,216,216],10000000000);
		public static const FACE34:MovieTemplateInfo = new MovieTemplateInfo(987034,[226,226,226,226,226,226,227,227,227,227,227,227,228,228,228,228,228,228,226,226,226,226,226,226,228,228,228,228,228,228,227,227,227,227,227,227,228,228,228,228,228,228,226,226,226,226,226,226,228,228,228,228,228,228,226,226,226,226,226,226,227,227,227,227,227,227,229,229,229,229,229,229,230,230,230,230,230,230,231,231,232,232],10000000000);
		public static const FACE35:MovieTemplateInfo = new MovieTemplateInfo(987035,[234,234,234,234,235,235,235,235],10000000000);
		public static const FACE36:MovieTemplateInfo = new MovieTemplateInfo(987036,[236,236,237,237,236,236,237,237,236,236,237,237],10000000000);
		
//		public static const FACES:Vector.<MovieTemplateInfo> = Vector.<MovieTemplateInfo>([
//			FACE1,FACE2,FACE3,FACE4,FACE5,FACE6,FACE7,FACE8,FACE9,FACE10,FACE11,FACE12,
//			FACE13,FACE14,FACE15,FACE16,FACE17,FACE18,FACE19,FACE20,FACE21,FACE22,FACE23,FACE24,
//			FACE25,FACE26,FACE27,FACE28,FACE29,FACE30,FACE31,FACE32,FACE33,FACE34,FACE35,FACE36
//		]);
		public static const FACES:Array = [
			FACE1,FACE2,FACE3,FACE4,FACE5,FACE6,FACE7,FACE8,FACE9,FACE10,FACE11,FACE12,
			FACE13,FACE14,FACE15,FACE16,FACE17,FACE18,FACE19,FACE20,FACE21,FACE22,FACE23,FACE24,
			FACE25,FACE26,FACE27,FACE28,FACE29,FACE30,FACE31,FACE32,FACE33,FACE34,FACE35,FACE36
		];
		
		private static var _data:Object;
		
		public static function setup():void
		{
			GlobalAPI.loaderAPI.getPackageFile(GlobalAPI.pathManager.getFacePath(),loadComplete,SourceClearType.NEVER);
		}
		
		private static function loadComplete(data:Object):void
		{
			_data = data;
		}
		
		public static function getFace(movie:MovieTemplateInfo):BaseEffect
		{
			if(_data == null)return null;
			var result:BaseEffect = new BaseEffect(movie);
			result.setData(_data);
			result.play(SourceClearType.NEVER);
			return result;
		}
	}
}