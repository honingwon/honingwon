/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:01:42 
 * 
 */ 
package sszt.chat.components.clubChat
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.PlayerIconCaches;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.ColorUtils;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.label.MAssetLabel;
	
	public class ClubPlayerView extends Sprite {
		
		private var _icon:Bitmap;
		private var _nameLabel:MAssetLabel;
		private var _serverLabel:MAssetLabel;
		private var _info:ClubMemberItemInfo;
		private var _selectBorder:SelectedBorder;
		private var _selected:Boolean;
		
		public function ClubPlayerView(info:ClubMemberItemInfo){
			this._info = info;
			super();
			this.init();
		}
		
		private function init():void{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 172, 22);
			graphics.endFill();
			buttonMode = true;
			tabEnabled = false;
			var index:int = ((this._info.sex) ? (this._info.career * 2) : ((this._info.career * 2) + 1));
			this._icon = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.SMALL, index));
			
			this._icon.x = 3;
			this._icon.y = 7;
			this._icon.width = (this._icon.height = 20);
//			addChild(this._icon);
			if (!this._info.isOnline){
//				ColorUtils.setGray(this);
				this._nameLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE_YAHEI1, TextFormatAlign.LEFT);
			}
			else
			{
				this._nameLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE_YAHEI, TextFormatAlign.LEFT);
			}
			var sex:String = this._info.sex?"<font color='#00baff'>♂</font> ":"<font color='#ff66ff'>♀</font> ";
			this._nameLabel.move(2, 1);
			addChild(this._nameLabel);
			this._nameLabel.htmlText = sex + this._info.name + LanguageManager.getWord("ssztl.common.levelValue2",this._info.level) + getDuty(_info.duty);
			
			this._serverLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE1, TextFormatAlign.RIGHT);
			this._serverLabel.move(160, 10);
//			addChild(this._serverLabel);
			this._serverLabel.setValue((this._info.level + LanguageManager.getWord("ssztl.common.levelLabel")));
		}
		
		public function get info():ClubMemberItemInfo{
			return (this._info);
		}
		
		public function set selected(value:Boolean):void{
			if (this._selected == value){
				return;
			}
			this._selected = value;
			if (this._selected){
				if (this._selectBorder == null){
					_selectBorder = new SelectedBorder();
					_selectBorder.mouseEnabled = false;
					_selectBorder.setSize(172,22);
				}
				if (!(this._selectBorder.parent)){
					addChild(this._selectBorder);
				}
				setChildIndex(this._selectBorder, 0);
			}
			else {
				if (((this._selectBorder) && (this._selectBorder.parent))){
					this._selectBorder.parent.removeChild(this._selectBorder);
				}
			}
		}
		private function getDuty(id:int):String
		{
			var str:String = "";
			switch(id)
			{
				case 1:
					str = "<font color='#ff9900'>[" + LanguageManager.getWord("ssztl.common.clubLeader") + "]</font>"
					break;
				case 2:
					str = "<font color='#ffcc00'>[" + LanguageManager.getWord("ssztl.common.subClubLeader") + "]</font>"
					break;
				case 3:
					str = "<font color='#ffee00'>[" + LanguageManager.getWord("ssztl.common.zhanglao") + "]</font>"
					break;
			}
			return str;
		}
		
		public function dispose():void{
			this._selectBorder = null;
			this._icon = null;
			this._nameLabel = null;
			this._serverLabel = null;
			this._info = null;
			if (parent){
				parent.removeChild(this);
			};
		}
		
	}
}