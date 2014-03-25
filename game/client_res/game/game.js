
var qq_game = {
		gamehost : window.location.host,
	    appid : typeof(appid) != 'undefined' ? appid : '100666449',
	    zone_id : typeof(zone_id) !='undefined' ? zone_id : '0',
	    isSandbox : typeof(isSandbox) !='undefined' ? isSandbox : true,
	    openid : typeof(openid) !='undefined' ? openid : true,
	    pf : typeof(pf) !='undefined' ? pf : 'qzone',
	    initialize: function(appid, zone_id, isSandbox, openid,openkey, pf,pfkey) {
	        this.appid = appid;
	        this.zone_id = zone_id;
	        this.isSandbox = isSandbox;
	        this.openid = openid;
	        this.pf = pf;
	    },
	    isIE : function(){
	        if (window.ActiveXObject) {
	            return (navigator.userAgent.toLowerCase().indexOf("msie") >= 0);
	        }else {
	            return false;
	        }
	    },
	    inviteFriend : function ()
        {
	    	fusion2.dialog.invite({
                msg : "页游巨作《盛世遮天》史上最炫武侠游戏！江湖儿女，侠骨柔情，让你兽血沸腾的武侠游戏！",
                img : "",
                context : "invite",
                onSuccess : function (ret) {
                        alert('邀请好友成功');
//                        var iopenids = "";
//                        var openid = ret.inviter;
//                        var iopenidsArr = ret.invitees;
//                        for(var key in iopenidsArr){
//                                iopenids += iopenidsArr[key]+",";
//                        }
//                        iopenids = iopenids.substr(0,iopenids.length-1);
//                        $.post("/game/api/invite_friend.php",{"openid":openid,"iopenids":iopenids});
    
                },
                onCancel : function() {
                },
                onClose : function() {
                }
	    	});
	    },
	    dialogBuy : function (obj) {
	    	if(obj.ret == 0){
		    	fusion2.dialog.buy ({
		    		disturb	  : false,
		    		param     : obj.url_params, 
		    	    sandbox   : this.isSandbox,//
		    	    onSend    : function(opt) {
		    		},
		    	    onCancel : function() {
		    			onBodyLoad();
		    		},
		    		onClose : function() {
		    			onBodyLoad();
		    		},
		    		onSuccess : function (opt) {  
		    			onBodyLoad(); 
		    		}
		         });
	    	}
	    	else if(obj.ret == 1002){
		    	fusion2.dialog.relogin();
		    }
		    else{
		    	alert(obj.msg);
		    }
        },
	    dialogPay : function () {
			fusion2.dialog.pay({
				sandbox : this.isSandbox,
				zoneid : this.zone_id,
				onClose : function () {}
            });
	    },
	    
	    shareInside : function (type)
	    {
	        pics = 'http://app100722626.imgcache.qzoneapp.com/app100722626/1000/start/sszt.png';
	        buttondesc = '进入应用';
	        openid=this.openid;
	        if(!type){
	            //title = '';
	            //desc = '';
	            //summary = '';
	        }
	        else{
	            switch(type){
	                case 1:
	                	return;
	                    title = '全新历史武侠大作';
	                    summary = '发现一款不错的游戏盛世遮天，想体验酣畅淋漓新武侠游戏吗？快来试试吧！';
	                    desc = '我在盛世遮天免费获得一件紫色兵器，小伙伴们快来围观吧！';
	                    //pics = 'http://' + this.gamehost + '/game/static/images/fight.jpg';
	                    break;
	                case 2:
	                	return;
	                    title = '全新历史武侠大作';
	                    summary = '发现一款不错的游戏盛世遮天，想体验酣畅淋漓新武侠游戏吗？快来试试吧！';
	                    desc = '我在“盛世遮天”获得酷炫飞剑坐骑，小伙伴们快来围观吧！！';
	                   // pics = 'http://' + this.gamehost + '/game/static/images/fish.jpg';
	                    break;
	                case 3:
	                    title = '全新历史武侠大作';
	                    summary = '发现一款不错的游戏盛世遮天，想体验酣畅淋漓新武侠游戏吗？快来试试吧！';
	                    desc = '我在“盛世遮天”获得一只小野猪，小伙伴们快来围观吧！';
	                    //pics = 'http://' + this.gamehost + '/game/static/images/level.jpg';
	                    break;
	                default:
	                    return;
	                    break;
	            }
	        }
			console.log(title);
			console.log(desc);
			console.log(summary);
            fusion2.dialog.sendStory({
              title : title,
              img : pics,
              summary : summary,
              msg : desc,
              button : buttondesc,
              source :"ref=story&act=default&openid="+this.openid,
              context:"send-story-12345",
              onShown : function ()
              { },
              onSuccess : function (opt)
              {},
              onCancel : function (opt)
              {},

              onClose : function ()
              {}
            });
	    },
	    
	    qqPayFusion : function (){
	    	fusion2.dialog.recharge({
	    		onClose : function () { }
	    	});  
	    }	    
	    
};


