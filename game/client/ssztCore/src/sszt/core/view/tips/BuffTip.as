package sszt.core.view.tips
{
	import flash.text.TextFormat;
	
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.manager.LanguageManager;

	public class BuffTip extends BaseDynamicTip
	{
		private var _info:BuffItemInfo;
		
		
		public function BuffTip()
		{
			super();
		}
		
		public function setBuff(buff:BuffItemInfo):void
		{
			clear();
			_info = buff;
			_text.width = 150;
			addStringToField(_info.getTemplate().name,getTextFormat(0xeddb60));
			addStringToField(_info.getTemplate().descript,getTextFormat(0x41d913),true,true,"#41d913");
//			addStringToField("",getTextFormat(0xffffff));
			if(_info.getTemplate().getIsTime())
			{
//				if(!_info.isPause)
//				{
					var t:String = _info.remainTimeString();
					addStringToField(LanguageManager.getWord("ssztl.scene.leftTime") + t,getTextFormat(0x35c3f7));
//				}
			}
			else
			{
				addStringToField(LanguageManager.getWord("ssztl.store.leftNum") + _info.remain + "/" + _info.totalValue,getTextFormat(0x35c3f7));
//				addStringToField(_info.remain + "/" + _info.getTemplate().valieTime,getTextFormat(0xffffff));
			}
		}
		
		protected function getTextFormat(color:uint):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color,null,null,null,null,null,null,null,null,null,4);
		}
	}
}