package sszt.core.data.module.changeInfos
{
	import sszt.core.data.marriage.MarryRequestInfo;
	import sszt.core.data.marriage.WeddingInvitationInfo;

	public class ToMarriageData
	{
		public var type:int;
		public var marryRequestInfo:MarryRequestInfo;
		public var weddingInvitationInfo:WeddingInvitationInfo;
		
		public function ToMarriageData(type:int, marryRequestInfo:MarryRequestInfo=null, weddingInvitationInfo:WeddingInvitationInfo=null)
		{
			this.type = type;
			this.marryRequestInfo = marryRequestInfo;
			this.weddingInvitationInfo = weddingInvitationInfo;
		}
	}
}