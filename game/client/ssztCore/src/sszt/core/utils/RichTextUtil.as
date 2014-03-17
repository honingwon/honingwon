package sszt.core.utils
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.box.BoxType;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.data.chat.club.ClubChatItemInfo;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.PopUpDeployType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.core.data.player.SelfPlayerInfo;
	import sszt.core.data.richTextField.RichTextBuildInfo;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.richTextField.RichTextField;
	
	public class RichTextUtil
	{
		private static var _textField:TextField = new TextField();
		private static var _pattern:RegExp = /\{[a-zA-Z][^\}]*\}/g;
		
		public static function getChatRichText(info:ChatItemInfo,width:int=260):RichTextField
		{
			_textField.text = "";
//			var deployList:Vector.<DeployItemInfo> = new Vector.<DeployItemInfo>();
			var deployList:Array = [];
			var deployInfo:DeployItemInfo;
//			var formatList:Vector.<RichTextFormatInfo> = new Vector.<RichTextFormatInfo>();
			var formatList:Array = [];
			var formatInfo:RichTextFormatInfo;
			var formatInfo1:RichTextFormatInfo;
			var message:String = "";
			var list:Array = [];
			var index:int = 0;
			var parms:Array = [];
			
			if(MessageType.getShowNick(info.type))
			{
				formatInfo = new RichTextFormatInfo();
				formatInfo.index = message.length;
				formatInfo.length = ("["+getChannelName(info.type)+"]").length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,getChannelColor(info.type));
				formatList.push(formatInfo);
				message += "["+getChannelName(info.type)+"]";
				
				if(info.type == MessageType.PRIVATE)
				{
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = message.length;
					formatInfo.length = -1;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFF6599);
					formatList.push(formatInfo);
					if(info.fromId == GlobalData.selfPlayer.userId)
					{
						deployInfo = new DeployItemInfo();
						deployInfo.type = DeployEventType.PLAYER_MENU;
//						deployInfo.param4 = message.length + String(info.serverId).length + 5;
						deployInfo.param4 = message.length + 5;
						deployInfo.param1 = info.toId;
						deployInfo.param2 = info.serverId;
						deployInfo.descript = info.toNick;
						deployList.push(deployInfo);
						formatInfo = new RichTextFormatInfo();
//						formatInfo.index = message.length + String(info.serverId).length + 4;
						formatInfo.index = message.length + 4;
						formatInfo.length = info.toNick.length + 2;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFCA79);
						formatList.push(formatInfo);
//						message += "您对[" + info.serverId + "][" + info.toNick + "]说：";
//						message += LanguageManager.getWord("ssztl.common.sayToSb","[" + info.serverId + "][" + info.toNick + "]");
						message += LanguageManager.getWord("ssztl.common.sayToSb", "[" + info.toNick + "]");
					}
					else if(info.toId == GlobalData.selfPlayer.userId)
					{
						deployInfo = new DeployItemInfo();
						deployInfo.type = DeployEventType.PLAYER_MENU;
//						deployInfo.param4 = message.length + String(info.serverId).length + 3;
						deployInfo.param4 = message.length + 3;
						deployInfo.param1 = info.fromId;
						deployInfo.param2 = info.serverId;
						deployInfo.descript = info.fromNick;
						deployList.push(deployInfo);
						formatInfo = new RichTextFormatInfo();
//						formatInfo.index = message.length + String(info.serverId).length + 2;
						formatInfo.index = message.length + 2;
						formatInfo.length = info.fromNick.length + 2;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFCA79);
						formatList.push(formatInfo);
//						message += "[" + info.serverId + "][" + info.fromNick + "]对您说：";
						message += LanguageManager.getWord("ssztl.common.sbSayToYou","[" + info.fromNick + "]");
					}
				}
				else
				{
					if(info.type == MessageType.SPEAKER)
					{
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = message.length;
						formatInfo.length = -1;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff8400);
						formatList.push(formatInfo);
					}
					
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = message.length;
					formatInfo.length = 1;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,info.fromSex == 1 ? 0x0099ff : 0xff33cc);
					formatList.push(formatInfo);
					message += info.fromSex == 1 ? "♂" : "♀";
					
					if(VipType.getIsGM(info.vipType))
					{
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = message.length;
						formatInfo.length = 6;
						var color:uint = 0xf12b6f;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color);
						formatList.push(formatInfo);
						message += LanguageManager.getWord("ssztl.core.GM");
					}
					else if(VipType.getIsNewlyGuide(info.vipType))
					{
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = message.length;
						formatInfo.length = 7;
						color = 0xf12b6f;
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color);
						formatList.push(formatInfo);
						message += LanguageManager.getWord("ssztl.core.newPlayerGuider");
						
					}
					else if(VipType.getVipType(info.vipType) != VipType.NORMAL)
					{
						formatInfo = new RichTextFormatInfo();
						formatInfo.index = message.length;
						formatInfo.length = 5;
						color = VipType.getColorByType(VipType.getVipType(info.vipType));
						formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color);
						formatList.push(formatInfo);
//						message += "[vip]";
						message += LanguageManager.getWord("ssztl.core.vipPlayer");
					}
					
					formatInfo = new RichTextFormatInfo();
//					formatInfo.index = message.length + String(info.serverId).length + 2;
					formatInfo.index = message.length;
					formatInfo.length = info.fromNick.length + 2;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc66);
					formatList.push(formatInfo);
					if(info.fromId == GlobalData.selfPlayer.userId)
					{
//						message += "[" + info.serverId + "][" + info.fromNick + "]：";
						message += "[" + info.fromNick + "]：";
					}
					else
					{
						deployInfo = new DeployItemInfo();
						deployInfo.type = DeployEventType.PLAYER_MENU;
//						deployInfo.param4 = message.length + String(info.serverId).length + 3;
						deployInfo.param4 = message.length+1;
						deployInfo.param1 = info.fromId;
						deployInfo.param2 = info.serverId;
						deployInfo.descript = info.fromNick;
						deployList.push(deployInfo);
//						message += "[" + info.serverId + "][" + info.fromNick + "]：";
						message += "[" + info.fromNick + "]：";
					}
				}
			}
			else
			{
				formatInfo = new RichTextFormatInfo();
				formatInfo.index = 0;
				formatInfo.length = -1;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFF99);
				formatList.push(formatInfo);
				
//				var ss:String = info.message;
//				list = ss.match(_pattern);
//				if(list != null && list.length > 0)
//				{
//					for(var j:int = 0; j < list.length; j++)
//					{
//						_textField.text = ss;
//						index = _textField.text.indexOf(list[j]);
//						parms = String(list[j]).slice(3,String(list[j]).length-1).split("-");
//						if(_textField.text.charAt(index+1) == "S")
//						{
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.index = index;
//							formatInfo.length = parms[1].length;
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,parms[0]);
//							formatList.push(formatInfo);
//							ss = ss.replace(list[j],parms[1]);
//						}
//					}
//					info.message = ss;
//				}
			}
			message += info.message;
			
			list = message.match(_pattern);
			index = 0;
			parms = [];
			var template:ItemTemplateInfo;
			var replaceText:String ="";
			if(list != null && list.length > 0)
			{
				for(var i:int = 0; i < list.length; i++)
				{
					_textField.text = message;
					index = _textField.text.indexOf(list[i]);
					parms = String(list[i]).slice(2,String(list[i]).length-1).split("-");
					switch(_textField.text.charAt(index+1))
					{
						case "N": //名字
							var nickName:String = "[" + parms[0] + "]";
							var selfNick:String = GlobalData.selfPlayer.nick;
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = nickName.length;
							if( parms[0] == selfNick)
							{
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x8fd947);
							}
							else
							{
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x35c3f7);
							}
							formatList.push(formatInfo);
							message = message.replace(list[i],nickName);
							break;
						
						case "A": //强化
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							
							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployInfo.formatIndex = formatList.length;
							deployList.push(deployInfo);
							
							template = ItemTemplateList.getTemplate(int(parms[2]));
							replaceText = "[" +  template.name + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							replaceText += "强化到完美";
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							if (int(parms[3]) > 0){
								replaceText += "[+" +  parms[3] + "]";
							}
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, 0xFF0000 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "B"://装备升级
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployInfo.formatIndex = formatList.length;
							deployList.push(deployInfo);
							template = ItemTemplateList.getTemplate(int(parms[2]));
							
							replaceText = "[" +  template.name + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							replaceText += "升级到";
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							if (int(parms[3]) > 0){
								replaceText += "[" +  parms[3] + "]级";
							}
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, 0xFF0000 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "C":
							parms = String(list[i]).slice(2,String(list[i]).length-1).split("-");
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = parms[1].length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,int(parms[0]));
							formatList.push(formatInfo);
							message = message.replace(list[i],parms[1]);
							break;						
						case "D": 	//挑战副本
							replaceText =  "[" +  parms[0] + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, 0x00FF00);
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							var templen1:int = replaceText.length;
							var templen:int = replaceText.length + index;
							
							if (int(parms[1]) > 0){
								replaceText += "[" +  parms[1] + "波]";
							}
							
							formatInfo1 = new RichTextFormatInfo();
							formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, 0xFF0000 );
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "E":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployInfo.formatIndex = formatList.length;
							deployList.push(deployInfo);
							template = ItemTemplateList.getTemplate(int(parms[2]));
							
							replaceText = "[" +  template.name + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							
							replaceText += "精炼到";
							templen1 = replaceText.length;
							templen = replaceText.length + index;
							if (int(parms[3]) > 4){
								replaceText += "[红色]品质";
								formatInfo1 = new RichTextFormatInfo();
								formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, 0xFF2200 );
							}
							else if (int(parms[3]) > 0){
								replaceText += "[橙色]品质";
								formatInfo1 = new RichTextFormatInfo();
								formatInfo1.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, 0xFF9900 );
							}
							formatInfo1.index = templen;
							formatInfo1.length = replaceText.length - templen1;
							formatList.push(formatInfo1);
							message = message.replace(list[i], replaceText);
							break;
						case "F":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.FACE;
							deployInfo.param4 = index;
							deployInfo.param1 = int(parms[0]);
							deployList.push(deployInfo);
							message = message.replace(list[i],"   ");
							break;
						case "G":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployInfo.formatIndex = formatList.length;
							deployList.push(deployInfo);
							template = ItemTemplateList.getTemplate(int(parms[2]));
							
							replaceText = "[" +  template.name + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, CategoryType.getQualityColor(template.quality));
							formatInfo.index = index;
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							message = message.replace(list[i], replaceText);
							break;
						case "T":
							var boxType:int = parseInt(parms[0]);
							var boxTypeName:String = BoxType.getBoxNameByType(boxType);
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = boxTypeName.length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,BoxType.getColorByType(boxType));
							formatList.push(formatInfo);
							message = message.replace(list[i],boxTypeName);
							break;
						
						case "S":
							replaceText =  "[" +  parms[2] + "]";
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, parms[1]);
							formatInfo.length = replaceText.length;
							formatList.push(formatInfo);
							message = message.replace(list[i], replaceText);
							break;
							
//							var colorValue:int = parseInt((list[i]).slice(2,String(list[i]).length-1));
//							formatInfo = new RichTextFormatInfo();
//							formatInfo.index = 0;
//							formatInfo.length = -1;
//							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,colorValue);
//							formatList.push(formatInfo);
//							message = message.replace(list[i],"");
//							break;
						case "I":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							if(int(parms[3]) > 0)
								deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name + " +" + parms[3];
							else
								deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployList.push(deployInfo);
							if(int(parms[3]) > 0)
								message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name + " +" + parms[3] + " "));
							else
								message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name + " "));
							break;
						case "M":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.SHOW_MOUNT;
							deployInfo.param4 = index;
							//用户ID
							deployInfo.param1 = Number(parms[0]);
							//坐骑ID
							deployInfo.param2 = Number(parms[1]);
							//坐骑物品模版ID
							deployInfo.param3 = int(parms[2]);
							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployList.push(deployInfo);
							message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name + " "));
							break;
						case "P":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.SHOW_PET;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = Number(parms[2]);
							deployInfo.param = parms[3];
							deployInfo.descript = LanguageManager.getWord("ssztl.common.pet") + "：" + parms[3];
							deployList.push(deployInfo);
							
							message = message.replace(list[i],(" " + LanguageManager.getWord("ssztl.common.pet") + "：" + parms[3] + " "));
							
							break;
						case "l":
							if(info.type == MessageType.NOTICE)
							{
								deployInfo = new DeployItemInfo();
								deployInfo.type = DeployEventType.LINK;
								deployInfo.param4 = index;
								deployInfo.descript = String(list[i]).slice(2,String(list[i]).length-1).split("$$")[0];
								deployInfo.param = String(list[i]).slice(2,String(list[i]).length-1).split("$$")[1];
								deployList.push(deployInfo);
								message = message.replace(list[i],deployInfo.descript);
							}
							break;
					}
				}
			}
			var richText:RichTextField = new RichTextField(width);
//			formatList.shift();
			richText.appendMessage(message,deployList,formatList);
			return richText;
		}
		
		//创建显示开箱子信息所需要的数据
		private static function getGainRichTextBuildInfo(message:String):RichTextBuildInfo
		{
			var deployList:Array = [];
			var formatList:Array = [];
			var deployInfo:DeployItemInfo;
			
			var formatInfo:RichTextFormatInfo;
			var list:Array = [];
			var index:int = 0;
			var parms:Array = [];
			
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = -1;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			formatList.push(formatInfo);
			
			var pt:RegExp = /\{[^\}]*\}/g;
			list = message.match(pt);
			if(list != null && list.length > 0)
			{
				for(var i:int=0;i<list.length;i++)
				{
					index = message.indexOf(list[i]);
					var str:String = list[i].slice(1,list[i].length-1);
					var deployStr:String = str.slice(1,str.length);
					switch(str.charAt(0))
					{
						case "N":
							var nickName:String = "[" + deployStr + "]";
							var selfNick:String = GlobalData.selfPlayer.nick;
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = nickName.length;
							if(deployStr == selfNick)
							{
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x8fd947);
							}
							else
							{
								formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x35c3f7);
							}
							formatList.push(formatInfo);
							message = message.replace(list[i],nickName);
							break;
						case "T":
							var boxType:int = parseInt(deployStr);
							var boxTypeName:String = BoxType.getBoxNameByType(boxType);
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = boxTypeName.length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,BoxType.getColorByType(boxType));
							formatList.push(formatInfo);
							message = message.replace(list[i],boxTypeName);
							break;
						case "I":
							parms = String(list[i]).slice(2,String(list[i]).length-1).split("-");
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							
//							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							var params2Name:String = "";
							var itemtemplateInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(int(parms[2]));
							if(itemtemplateInfo)
							{
								params2Name = itemtemplateInfo.name;
							}
							if(int(parms[3]) > 0)
								deployInfo.descript = params2Name + " +" + parms[3];
							else
								deployInfo.descript = params2Name;
							deployList.push(deployInfo);
							if(int(parms[3]) > 0)
								message = message.replace(list[i],(" " + params2Name + " +" + parms[3] + " "));
							else
								message = message.replace(list[i],(" " + params2Name + " "));
							
							deployList.push(deployInfo);
//							message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name) + " ");
							break;
						case "C":
							parms = String(list[i]).slice(2,String(list[i]).length-1).split("-");
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = index;
							formatInfo.length = parms[1].length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,int(parms[0]));
							formatList.push(formatInfo);
							message = message.replace(list[i],parms[1]);
							break;
						case "D":
							var color:int = parseInt((list[i]).slice(2,String(list[i]).length-1));
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = 0;
							formatInfo.length = -1;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color);
							formatList.push(formatInfo);
							message = message.replace(list[i],"");
							break;
					}
				}
			}
			
			
//			if(list != null && list.length > 0)
//			{
//				_textField.text = message;
//				index = message.indexOf(list[0]);
//				
//				var str:String = list[0].slice(1,String(list[0]).length-1);
//				
//				formatInfo = new RichTextFormatInfo();
//				formatInfo.index = index;
//				formatInfo.length = str.length+2;
//				var player:SelfPlayerInfo = GlobalData.selfPlayer;
//				var name:String = GlobalData.selfPlayer.userName;
//				if(GlobalData.selfPlayer.nick == str)
//				{
//					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x8fd947);
//				}
//				else
//				{
//					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x35c3f7);
//				}
//				formatList.push(formatInfo);
//				message = message.replace(list[0],"【"+str+"】");
//				
//				index = message.indexOf(list[1]);
//				str = list[1].slice(1,String(list[1]).length-1);
//				var type:int = parseInt(str);
//				var typeName:String = BoxType.getBoxNameByType(type);
//				formatInfo = new RichTextFormatInfo();
//				formatInfo.index = index;
//				formatInfo.length = typeName.length;
//				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,BoxType.getColorByType(type));
//				formatList.push(formatInfo);
//				message = message.replace(list[1],typeName);
//				
//				index = message.indexOf(list[2]);
//				parms = String(list[2]).slice(2,String(list[2]).length-1).split("-");
//				
//				deployInfo = new DeployItemInfo();
//				deployInfo.type = DeployEventType.ITEMTIP;
//				deployInfo.param4 = index;
//				deployInfo.param1 = Number(parms[0]);
//				deployInfo.param2 = Number(parms[1]);
//				deployInfo.param3 = int(parms[2]);
//				deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
//				
//				deployList.push(deployInfo);
//				
//				message = message.replace(list[2],(" " + ItemTemplateList.getTemplate(int(parms[2])).name));
//			}
			
			var rtbInfo:RichTextBuildInfo = new RichTextBuildInfo();
			rtbInfo.message = message;
			rtbInfo.deployList = deployList;
			rtbInfo.formatList = formatList;
			return rtbInfo;
		}
		
		
		public static function getOpenBoxRichText(message:String, width:int):RichTextField
		{
			var buildInfo:RichTextBuildInfo = getGainRichTextBuildInfo(message);
			var richText:RichTextField = new RichTextField(width);
			richText.appendMessage(buildInfo.message,buildInfo.deployList,buildInfo.formatList);
			return richText;
		}
		
		public static function getPetPVPRichText(info:PetPVPLogItemInfo):RichTextField
		{
			var i:int,index:int = 0;
			var deployList:Array = [];
			var formatList:Array = [];
			var deployInfo:DeployItemInfo;
			var formatInfo:RichTextFormatInfo;
			var t:String = '';
			
			//switch(info.state)//0 胜利 1 失败 2 连胜 3终结 4被终结
			if(info.state == 0)
			{
				t = LanguageManager.getWord('ssztl.petpvp.logType0',info.petNick,info.opponentNick,info.opponentPetNick,info.place);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.petNick);
				formatInfo.index = index;
				formatInfo.length = info.petNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffff99);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentNick,index + info.petNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc00);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentPetNick, index + info.opponentNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentPetNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x35ba38);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = index + info.opponentPetNick.length + 6;
				formatInfo.index = index;
				formatInfo.length = info.place.toString().length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xd69f69);
				formatList.push(formatInfo);
			}
			else if(info.state == 1)
			{
				t = LanguageManager.getWord('ssztl.petpvp.logType1',info.opponentNick,info.opponentPetNick,info.petNick,info.place);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentNick);
				formatInfo.index = index;
				formatInfo.length = info.opponentNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc00);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentPetNick,index + info.opponentNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentPetNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x35ba38);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.petNick, index + info.opponentPetNick.length);
				formatInfo.index = index;
				formatInfo.length = info.petNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffff99);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = index + info.petNick.length + 6;
				formatInfo.index = index;
				formatInfo.length = info.place.toString().length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xd69f69);
				formatList.push(formatInfo);
				
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.PET_PVP_CHALLENGE;
				deployInfo.param1 = Number(info.petId);
				deployInfo.param2 = Number(info.opponentPetId);
				deployInfo.param4 = t.indexOf(LanguageManager.getWord('ssztl.petpvp.logKeyWord'),index + info.place.toString().length);
				deployInfo.descript = LanguageManager.getWord('ssztl.petpvp.logKeyWord');
				deployList.push(deployInfo);
			}
			else if(info.state == 2)
			{
				if(info.opponentPetId == GlobalData.selfPlayer.userId)
				{
					t = LanguageManager.getWord('ssztl.petpvp.logType21',info.petNick,info.winning,info.place);					
					
					formatInfo = new RichTextFormatInfo();
					index = t.indexOf(info.petNick);
					formatInfo.index = index;
					formatInfo.length = info.petNick.length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
					
					formatInfo = new RichTextFormatInfo();
					index = index + info.petNick.length + 5;
					formatInfo.index = index;
					formatInfo.length = info.winning.toString().length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
					
					formatInfo = new RichTextFormatInfo();
					index = index + info.winning.toString().length + 7;
					formatInfo.index = index;
					formatInfo.length = info.place.toString().length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
				}
				else
				{	
					t = LanguageManager.getWord('ssztl.petpvp.logType2',info.nick,info.petNick,info.winning,info.place);
					
					formatInfo = new RichTextFormatInfo();
					index = t.indexOf(info.nick);
					formatInfo.index = index;
					formatInfo.length = info.nick.length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
					
					formatInfo = new RichTextFormatInfo();
					index = t.indexOf(info.petNick,index + info.nick.length);
					formatInfo.index = index;
					formatInfo.length = info.petNick.length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
					
					formatInfo = new RichTextFormatInfo();
					index = index + info.petNick.length + 5;
					formatInfo.index = index;
					formatInfo.length = info.winning.toString().length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
					
					formatInfo = new RichTextFormatInfo();
					index = index + info.winning.toString().length + 7;
					formatInfo.index = index;
					formatInfo.length = info.place.toString().length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
					formatList.push(formatInfo);
					
					deployInfo = new DeployItemInfo();
					deployInfo.type = DeployEventType.PET_PVP_CHALLENGE;
					deployInfo.param1 = 0;
					deployInfo.param2 = Number(info.petId);
					deployInfo.param4 = t.indexOf(LanguageManager.getWord('ssztl.petpvp.logKeyWord2'),index + info.place.toString().length);
					deployInfo.descript = LanguageManager.getWord('ssztl.petpvp.logKeyWord2');
					deployList.push(deployInfo);
				}
				
			}
			else if(info.state == 3)
			{
				t = LanguageManager.getWord('ssztl.petpvp.logType3',info.nick,info.petNick,info.opponentNick,info.opponentPetNick,info.place,info.winning);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.nick);
				formatInfo.index = index;
				formatInfo.length = info.nick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.petNick,index+info.nick.length);
				formatInfo.index = index;
				formatInfo.length = info.petNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);				
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentNick,index+info.petNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentPetNick,index+info.opponentNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentPetNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = index + info.opponentPetNick.length + 9;
				formatInfo.index = index;
				formatInfo.length = info.place.toString().length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = index + info.place.toString().length + 2;
				formatInfo.index = index;
				formatInfo.length = info.winning.toString().length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
			}
			else if(info.state == 4)
			{
				t = LanguageManager.getWord('ssztl.petpvp.logType4',info.nick,info.petNick,info.opponentNick,info.opponentPetNick);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.nick);
				formatInfo.index = index;
				formatInfo.length = info.nick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.petNick,index+info.nick.length);
				formatInfo.index = index;
				formatInfo.length = info.petNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentNick,index+info.petNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
				
				formatInfo = new RichTextFormatInfo();
				index = t.indexOf(info.opponentPetNick,index+info.opponentNick.length);
				formatInfo.index = index;
				formatInfo.length = info.opponentPetNick.length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff0000);
				formatList.push(formatInfo);
			}
			
//			ssztl.petpvp.logKeyWord:还击
//			ssztl.petpvp.logKeyWord2:挑战
			
			var richText:RichTextField = new RichTextField(520);
			richText.appendMessage(t,deployList,formatList);
			return richText;
		}
		
		public static function getTaskRichText(info:Object):RichTextField
		{
			var i:int,index:int = 0;
//			var deployList:Vector.<DeployItemInfo> = new Vector.<DeployItemInfo>();
			var deployList:Array = [];
			var formatList:Array = [];
			var deployInfo:DeployItemInfo;
			var formatInfo:RichTextFormatInfo;
			var title:String;
			var target:String;
			var type:int;
			var taskId:int;
			
			var ss:String = "";
			//获取title，target，type，taskId
			if(info is TaskItemInfo)
			{
				title = TaskItemInfo(info).getTemplate().title;
				if(GlobalData.taskInfo.taskStateChecker.checkStateComplete(TaskItemInfo(info).getCurrentState(),TaskItemInfo(info).requireCount))
//					ss += "(已完成)";
					ss += LanguageManager.getWord("ssztl.core.finished");
				target = TaskItemInfo(info).getCurrentState().target;
				type = TaskItemInfo(info).getTemplate().type;
				taskId = TaskItemInfo(info).getTemplate().taskId
			}
			else if(info is TaskTemplateInfo)
			{
				title = TaskTemplateInfo(info).title;
				taskId = TaskTemplateInfo(info).taskId;
				if(TaskTemplateInfo(info).minLevel > GlobalData.selfPlayer.level)
				{
					ss += LanguageManager.getWord("ssztl.common.canAcceptLevelValue",TaskTemplateInfo(info).minLevel);
					
					formatInfo = new RichTextFormatInfo();
					formatInfo.index = title.length;
					formatInfo.length = ss.length;
					formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFF0000);
					formatList.push(formatInfo);
				}
				else
				{
					ss += LanguageManager.getWord("ssztl.common.levelValue2",TaskTemplateInfo(info).minLevel);
				}
				target = TaskTemplateInfo(info).target;
				type = TaskTemplateInfo(info).type;
			}
//			var t:String = "[" + TaskType.getNameByType2(type) + "]";
			var t:String = "";
			//江湖令任务
			if(type == TaskType.TOKEN)
			{
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.POPUP;
				deployInfo.param1 = ModuleType.SWORDSMAN;
				deployInfo.descript = title;
				deployList.push(deployInfo);
			}
			else
			{
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.TASK_TIP;
				deployInfo.descript = title;
				deployInfo.param1 = info.taskId;
				deployInfo.param4 = t.length;
				deployList.push(deployInfo);
			}
			t += title + ss + "\n";
			
			//赠送紫色品质装备任务
			if(taskId == 551001)
			{
				formatInfo = new RichTextFormatInfo();
				formatInfo.index = t.indexOf(LanguageManager.getWord('ssztl.fuck'));
				formatInfo.length = LanguageManager.getWord('ssztl.fuck').length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xcc00ff);
				formatList.push(formatInfo);
			}
			
			//已接任务（师门、试炼、帮会）显示进度
			if((info is TaskItemInfo) && TaskType.showState(TaskItemInfo(info).template.type))
			{
//				var sss:String = "第(" + (TaskItemInfo(info).state + 1) + "/" + TaskItemInfo(info).template.states.length + ")环";
				var sss:String = LanguageManager.getWord("ssztl.common.circleValue",(TaskItemInfo(info).state + 1) + "/" + TaskItemInfo(info).template.states.length);
				t += sss + "\n";
			}
			
			if((info is TaskItemInfo) && GlobalData.taskInfo.taskStateChecker.checkStateComplete(TaskItemInfo(info).getCurrentState(),TaskItemInfo(info).requireCount))
			{
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.TASK_NPC;
				deployInfo.param1 = TaskItemInfo(info).getCurrentState().npc;
				deployInfo.param4 = t.length + 2;
				deployInfo.descript = MapTemplateList.getMapTemplate(NpcTemplateList.getNpc(TaskItemInfo(info).getCurrentState().npc).sceneId).name;
				deployList.push(deployInfo);
//				t += "前往" + deployInfo.descript;
				t += LanguageManager.getWord("ssztl.common.gotoPlace",deployInfo.descript);
				
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.TASK_NPC;
				deployInfo.param1 = TaskItemInfo(info).getCurrentState().npc;
				deployInfo.param4 = t.length + 1;
				deployInfo.descript = NpcTemplateList.getNpc(deployInfo.param1).name;
				deployList.push(deployInfo);
//				t += "与" + deployInfo.descript + "对话";
				t += LanguageManager.getWord("ssztl.common.talkSb",deployInfo.descript);
				
				if(TaskItemInfo(info).getCurrentState().canTransfer)
				{
					var npcInfo:NpcTemplateInfo = NpcTemplateList.getNpc(TaskItemInfo(info).getCurrentState().npc);
					deployInfo = new DeployItemInfo();
					deployInfo.type = DeployEventType.TASK_TRANSFER;
					deployInfo.param1 = npcInfo.sceneId;
					var p:Point = npcInfo.getAPoint();
					deployInfo.param2 = int(p.x) * 10000 + int(p.y);
					deployInfo.param3 = 1;
					deployInfo.param4 = t.length;
					deployInfo.param = TaskItemInfo(info).getCurrentState().npc;
					deployList.push(deployInfo);
					t += " ";
				}
				
//				if(TaskType.showState(TaskItemInfo(info).template.type))
//				{
//					deployInfo = new DeployItemInfo();
//					deployInfo.type = DeployEventType.QUICK_COMPLETE_TASK;
//					deployInfo.param1 = TaskItemInfo(info).template.taskId;
//					deployInfo.param2 = TaskItemInfo(info).template.states.length - TaskItemInfo(info).state;
//					deployInfo.param4 = t.length;
//					deployList.push(deployInfo);
//					t += "  \n  \n \n";
//				}
			}
			else if((info is TaskTemplateInfo) && TaskTemplateInfo(info).type == TaskType.MAINLINE &&  TaskTemplateInfo(info).minLevel > GlobalData.selfPlayer.level)
			{}
			else
			{
				var list:Array;
				while(target.indexOf("{") != -1 && target.indexOf("{") < target.indexOf("}"))
				{
					var mes:String = target.slice(target.indexOf("{"),target.indexOf("}")+1);
					var deploy:String = mes.slice(1,mes.length-1);
					list = deploy.split("#");
					index = t.length + target.indexOf("{");
					deployInfo = new DeployItemInfo();
					deployInfo.type = list[0];
					deployInfo.param4 = index;
					if(list[2])deployInfo.param1 = list[2];
					if(list[3])deployInfo.param2 = list[3];
					if(list[4])deployInfo.param3 = list[4];
					if(list[5])deployInfo.param4 = list[5];
					deployInfo.descript = list[1];
					deployList.push(deployInfo);
					target = target.replace(mes,deployInfo.descript);
				}
				t += target;
				
				if(info is TaskItemInfo)
				{
					var state:TaskStateTemplateInfo = TaskItemInfo(info).getCurrentState();
					var data:Array = state.data;
					if(TaskConditionType.getShowRequireCount(state.condition))
					{
						t += "(" + (data[i][1] - int(TaskItemInfo(info).requireCount[i])) + "/" + data[i][1] + ")";
					}
					
					if(state.canTransfer && list && list.length > 0)
					{
						deployInfo = new DeployItemInfo();
						deployInfo.type = DeployEventType.TASK_TRANSFER;
						var p2:Point;
						if(list[0] == DeployEventType.TASK_MONSTER)
						{
							deployInfo.param1 = MonsterTemplateList.getMonster(list[2]).sceneId;
							p2 = MonsterTemplateList.getMonster(list[2]).getAPoint();
							deployInfo.param2 = int(p2.x) * 10000 + int(p2.y);
							deployInfo.param3 = 2;
						}
						else if(list[0] == DeployEventType.TASK_NPC)
						{
							deployInfo.param1 = NpcTemplateList.getNpc(list[2]).sceneId;
							p2 = NpcTemplateList.getNpc(list[2]).getAPoint();
							deployInfo.param2 = int(p2.x) * 10000 + int(p2.y);
							deployInfo.param3 = 1;
//							deployInfo.param2 = NpcTemplateList.getNpc(list[2]).sceneX;
//							deployInfo.param3 = NpcTemplateList.getNpc(list[2]).sceneY;
						}
						else if(list[0] == DeployEventType.TASK_COLLECT)
						{
							deployInfo.param1 = CollectTemplateList.getCollect(list[2]).sceneId;
							p2 = CollectTemplateList.getCollect(list[2]).getAPoint();
							deployInfo.param2 = int(p2.x) * 10000 + int(p2.y);
							deployInfo.param3 = 3;
//							deployInfo.param2 = CollectTemplateList.getCollect(list[2]).centerX;
//							deployInfo.param3 = CollectTemplateList.getCollect(list[2]).centerY;
						}
						deployInfo.param = list[2];
						deployInfo.param4 = t.length;
						deployList.push(deployInfo);
						t += " ";
					}
					
					if(TaskType.showState(TaskItemInfo(info).template.type))
					{
						deployInfo = new DeployItemInfo();
						deployInfo.type = DeployEventType.QUICK_COMPLETE_TASK;
						deployInfo.param1 = TaskItemInfo(info).template.taskId;
						deployInfo.param2 = TaskItemInfo(info).template.states.length - TaskItemInfo(info).state;
						deployInfo.param4 = t.length;
						deployList.push(deployInfo);
						t += "  \n  \n \n";
					}
				}
				else
				{
					if(TaskTemplateInfo(info).canTransfer)
					{
						var npc:NpcTemplateInfo = NpcTemplateList.getNpc(list[2]);
						deployInfo = new DeployItemInfo();
						deployInfo.type = DeployEventType.TASK_TRANSFER;
						deployInfo.param1 = npc.sceneId;
//						deployInfo.param2 = npc.sceneX;
//						deployInfo.param3 = npc.sceneY;
						var p1:Point = npc.getAPoint();
						deployInfo.param2 = int(p1.x) * 10000 + int(p1.y);
						deployInfo.param3 = 1;
						deployInfo.param4 = t.length;
						deployInfo.param = list[2];
						deployList.push(deployInfo);
						t += " ";
					}
				}
			}
			
			if(info is TaskTemplateInfo && TaskTemplateInfo(info).type == TaskType.MAINLINE && TaskTemplateInfo(info).minLevel > GlobalData.selfPlayer.level )
			{
				t += LanguageManager.getWord('ssztl.common.whatCanIDoToday');
				
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.POPUP;
				deployInfo.param1 = ModuleType.ACTIVITY;
				deployInfo.param2 = 1;
				deployInfo.param4 = t.indexOf(LanguageManager.getWord('ssztl.common.whatCanIDoToday'));
				deployInfo.descript = LanguageManager.getWord('ssztl.common.whatCanIDoToday');
				deployList.push(deployInfo);
				
				formatInfo = new RichTextFormatInfo();
				formatInfo.index = t.indexOf(LanguageManager.getWord('ssztl.common.whatCanIDoToday'));
				formatInfo.length = LanguageManager.getWord('ssztl.common.whatCanIDoToday').length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00FF00);
				formatList.push(formatInfo);
			}
			//201 - 205
			if(
				(info is TaskTemplateInfo && TaskTemplateInfo(info).taskId ==555201) || (info is TaskItemInfo && TaskItemInfo(info).taskId ==555201) ||
				(info is TaskTemplateInfo && TaskTemplateInfo(info).taskId ==555202) || (info is TaskItemInfo && TaskItemInfo(info).taskId ==555202) ||
				(info is TaskTemplateInfo && TaskTemplateInfo(info).taskId ==555203) || (info is TaskItemInfo && TaskItemInfo(info).taskId ==555203) ||
				(info is TaskTemplateInfo && TaskTemplateInfo(info).taskId ==555204) || (info is TaskItemInfo && TaskItemInfo(info).taskId ==555204) ||
				(info is TaskTemplateInfo && TaskTemplateInfo(info).taskId ==555205) || (info is TaskItemInfo && TaskItemInfo(info).taskId ==555205)
			)
			{
				t += '\n' + LanguageManager.getWord('ssztl.common.transportTip');
				
				formatInfo = new RichTextFormatInfo();
				formatInfo.index = t.indexOf(LanguageManager.getWord('ssztl.common.transportTip'));
				formatInfo.length = LanguageManager.getWord('ssztl.common.transportTip').length;
				formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00FF00);
				formatList.push(formatInfo);
			}
			
			
			var richText:RichTextField = new RichTextField(250);
//			richText.appendMessage(t,deployList,new Vector.<RichTextFormatInfo>());
			richText.appendMessage(t,deployList,formatList);
			return richText;
		}
		
		
		
		public static function getClubChatRichText(info:ClubChatItemInfo, width:int=280, _arg3:int=0):RichTextField
		{
			var deployInfo:DeployItemInfo;
			var parms:Array;
			var clubMemberInfo:ClubMemberItemInfo;
			_textField.text = "";
			var deployList:Array = [];
			var message:String = "";
			var list:Array = [];
			var index:int;
			parms = [];
			message = (message + info.info.fromNick);
			deployInfo = new DeployItemInfo();
			deployInfo.type = DeployEventType.TEXT_COLOR;
			deployInfo.param4 = index;
			deployInfo.param1 = 0xFF00;
			deployInfo.param2 = info.info.fromNick.length;
			deployList.push(deployInfo);
			index = message.length;
			if (info.info.fromId != GlobalData.selfPlayer.userId && info.info.fromId != 0){
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.PLAYER_MENU;
				deployInfo.param4 = 0;
				deployInfo.param1 = info.info.fromId;
				deployInfo.param2 = info.info.serverId;
				deployInfo.param3 = 0xFF00;
				deployInfo.descript = info.info.fromNick;
				deployList.push(deployInfo);
			}
			clubMemberInfo = GlobalData.clubMemberInfo.getClubMember(info.info.fromId);
			
			if (clubMemberInfo){
				var dutyName:String = ClubDutyType.getDutyName(clubMemberInfo.duty);
				message = message + "[" + dutyName + "]";
				deployInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.TEXT_COLOR;
				deployInfo.param4 = index;
				if (ClubDutyType.getIsMaster(clubMemberInfo.duty)){
					deployInfo.param1 = 11033328;
				} 
				else {
					if (ClubDutyType.getIsOverViceMaster(clubMemberInfo.duty))
					{
						deployInfo.param1 = 3523575;
					} 
					else 
					{
						deployInfo.param1 = 0xFF00;
					}
				}
				deployInfo.param2 = (message.length - index);
				deployList.push(deployInfo);
				index = message.length;
			}
			message = message + " [" + info.time + "]";
			deployInfo = new DeployItemInfo();
			deployInfo.type = DeployEventType.TEXT_COLOR;
			deployInfo.param4 = index;
			deployInfo.param1 = 0xFF00;
			deployInfo.param2 = (message.length - index);
			deployList.push(deployInfo);
			message = (message + "\n");
			message = (message + info.info.message);
			list = message.match(_pattern);
			index = 0;
			parms = [];
			if (list != null && list.length > 0)
			{
				for(var i:int = 0; i < list.length; i++)
				{
					_textField.text = message;
					index = _textField.text.indexOf(list[i]);
					parms = String(list[i]).slice(2, (String(list[i]).length - 1)).split("-");
					switch (_textField.text.charAt(index + 1))
					{
						case "N":
							var nickName:String = "[" + parms[0] + "]";
							var selfNick:String = GlobalData.selfPlayer.nick;
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.TEXT_COLOR;
							deployInfo.param4 = index;
							if (parms[0] == selfNick)
							{
								deployInfo.param1 = 9427271;
							} 
							else 
							{
								deployInfo.param1 = 3523575;
							}
							deployInfo.param2 = nickName.length;
							deployList.push(deployInfo);
							message = message.replace(list[i], nickName);
							break;
//						case "T":
//							_local21 = parseInt(parms[0]);
//							_local22 = BoxType.getBoxNameByType(_local21);
//							deployInfo = new DeployItemInfo();
//							deployInfo.type = DeployEventType.TEXT_COLOR;
//							deployInfo.param4 = index;
//							deployInfo.param1 = BoxType.getColorByType(_local21);
//							deployInfo.param2 = _local22.length;
//							deployList.push(deployInfo);
//							message = message.replace(list[i], _local22);
//							break;
						case "F":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.FACE;
							deployInfo.param4 = index;
							deployInfo.param1 = int(parms[0]);
							deployList.push(deployInfo);
							message = message.replace(list[i],"   ");
							break;
						case "C":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.TEXT_COLOR;
							deployInfo.param4 = index;
							deployInfo.param1 = parms[0];
							deployInfo.descript = parms[1];
							deployInfo.param2 = parms[1].length;
							deployList.push(deployInfo);
							message = message.replace(list[i], parms[1]);
							break;
						case "D":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.TEXT_COLOR;
							deployInfo.param4 = 0;
							deployInfo.param1 = parseInt(list[i].slice(2, (String(list[i]).length - 1)));
							deployInfo.param2 = -1;
							deployList.push(deployInfo);
							message = message.replace(list[i], "");
							break;
						case "I":
							parms = String(list[i]).slice(2,String(list[i]).length-1).split("-");
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.ITEMTIP;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = int(parms[2]);
							
							//							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							var params2Name:String = "";
							var itemtemplateInfo:ItemTemplateInfo = ItemTemplateList.getTemplate(int(parms[2]));
							if(itemtemplateInfo)
							{
								params2Name = itemtemplateInfo.name;
							}
							if(int(parms[3]) > 0)
								deployInfo.descript = params2Name + " +" + parms[3];
							else
								deployInfo.descript = params2Name;
							deployList.push(deployInfo);
							if(int(parms[3]) > 0)
								message = message.replace(list[i],(" " + params2Name + " +" + parms[3] + " "));
							else
								message = message.replace(list[i],(" " + params2Name + " "));
							
							deployList.push(deployInfo);
							break;
						case "M":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.SHOW_MOUNT;
							deployInfo.param4 = index;
							//用户ID
							deployInfo.param1 = Number(parms[0]);
							//坐骑ID
							deployInfo.param2 = Number(parms[1]);
							//坐骑物品模版ID
							deployInfo.param3 = int(parms[2]);
							deployInfo.descript = ItemTemplateList.getTemplate(int(parms[2])).name;
							deployList.push(deployInfo);
							message = message.replace(list[i],(" " + ItemTemplateList.getTemplate(int(parms[2])).name + " "));
							break;
						case "P":
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.SHOW_PET;
							deployInfo.param4 = index;
							deployInfo.param1 = Number(parms[0]);
							deployInfo.param2 = Number(parms[1]);
							deployInfo.param3 = Number(parms[2]);
							deployInfo.param = parms[3];
							deployInfo.descript = LanguageManager.getWord("ssztl.common.pet") + "：" + parms[3];
							deployList.push(deployInfo);
							
							message = message.replace(list[i],(" " + LanguageManager.getWord("ssztl.common.pet") + "：" + parms[3] + " "));
							
							break;
//						case "U":
//							deployInfo = new DeployItemInfo();
//							deployInfo.type = DeployEventType.POPUP;
//							deployInfo.param4 = index;
//							deployInfo.param1 = parms[0];
//							deployInfo.descript = parms[1];
//							deployInfo.param2 = parms[2];
//							deployInfo.param3 = parms[3];
//							deployInfo.param = [];
//							_local26 = 4;
//							while (_local26 < parms.length) 
//							{
//								deployInfo.param.push(parms[_local26]);
//								_local26++;
//							}
//							deployInfo.param.push();
//							deployList.push(deployInfo);
//							message = message.replace(list[i], parms[1]);
//							break;
//						case "Y":
//							deployInfo = new DeployItemInfo();
//							deployInfo.type = DeployEventType.TASK_TRANSFER;
//							deployInfo.descript = " ";
//							deployInfo.param1 = parms[0];
//							deployInfo.param2 = (int((parms[1] * 10000)) + int(parms[2]));
//							deployInfo.param3 = parms[2];
//							deployInfo.param4 = index;
//							deployList.push(deployInfo);
//							message = message.replace(list[i], deployInfo.descript);
//							break;
					}
				}
			}
			var richText:RichTextField = new RichTextField(width);
			richText.appendMessage(message, deployList,[]);
			return (richText);
		
		}
	
		
		private static function getChannelName(type:int):String
		{
			switch(type)
			{
//				case MessageType.WORLD:return "【世界】";
//				case MessageType.CMP:return "【阵营】";
//				case MessageType.CLUB:return "【帮会】";
//				case MessageType.GROUP:return "【队伍】";
//				case MessageType.CURRENT:return "【附近】";
//				case MessageType.PRIVATE:return "【私聊】";
//				case MessageType.SPEAKER:return "【喇叭】";
				
				/* Aron 2012.3.1
				case MessageType.WORLD:return LanguageManager.getWord("ssztl.core.worldSign");
				case MessageType.CMP:return LanguageManager.getWord("ssztl.core.campSign");
				case MessageType.CLUB:return LanguageManager.getWord("ssztl.core.clubSign");
				case MessageType.GROUP:return LanguageManager.getWord("ssztl.core.teamSign");
				case MessageType.CURRENT:return LanguageManager.getWord("ssztl.core.nearSign");
				case MessageType.PRIVATE:return LanguageManager.getWord("ssztl.core.privateChatSign");
				case MessageType.SPEAKER:return LanguageManager.getWord("ssztl.core.sparkSign");
				*/
				case MessageType.WORLD:return LanguageManager.getWord("ssztl.common.world");
				case MessageType.CMP:return LanguageManager.getWord("ssztl.common.camp");
				case MessageType.CLUB:return LanguageManager.getWord("ssztl.common.club");
				case MessageType.GROUP:return LanguageManager.getWord("ssztl.common.team");
				case MessageType.CURRENT:return LanguageManager.getWord("ssztl.common.near");
				case MessageType.PRIVATE:return LanguageManager.getWord("ssztl.common.privateChat");
				case MessageType.SPEAKER:return LanguageManager.getWord("ssztl.common.spark");
			}
			return "";
		}
		
		private static function getChannelColor(type:int):uint
		{
			switch(type)
			{
				/* Aron 2012.3.1
				case MessageType.WORLD:return 0x00ff00;
				case MessageType.CMP:return 0xff6600;
				case MessageType.CLUB:return 0xf261a5;
				case MessageType.GROUP:return 0x3299ff;
				case MessageType.CURRENT:return 0xFFFFFF;
				case MessageType.PRIVATE:return 0xff6599;
				case MessageType.SPEAKER:return 0xff8400;
				*/
				case MessageType.WORLD:return 0x3399cc;
				case MessageType.CMP:return 0xff6600;
				case MessageType.CLUB:return 0xff9933;
				case MessageType.GROUP:return 0x33ff00;
				case MessageType.CURRENT:return 0xffff00;
				case MessageType.PRIVATE:return 0xff00ff;
				case MessageType.SPEAKER:return 0xff6600;
			}
			return 0;
		}
	}
}