//合成一个函数由函数名,参数值组成
Pagination = BMClass.create();
Pagination.prototype = {
    /*
    构造一个分页类
    UniqueID: 控件的客户端ID
    pageCount:页总数
    pageNum:当前页

    rowsSumNum:记录总数
    currentRowNum:当前页记录数
    FunctionStr:分页执行的函数

    divID:呈现分页的DIV
    style: 样式
    */
    initialize : function(UniqueID,pageCount,pageNum,rowsSumNum,currentRowNum,FunctionStr,divID,style){
        //this.UniqueID = UniqueID.replace(/$/g,"_");
        this.PageCount = pageCount;
        this.PageNum = pageNum;
        this.RowsSumNum = rowsSumNum;
        this.CurrentRowNum = currentRowNum;
        this.FunctionStr = FunctionStr;
        //this.DivID = divID; 
		this.DivID = document.getElementById(divID); 
        switch(style){
            case 1:
            this.initPagingation();
            break; 
            default:
            this.initPagingation();
        }
    },    
    initPagingation :function (){  
        if(this.DivID!=null){
            if( this.PageCount > 1){
                var shtm = "<span>共"+this.PageCount+"页/"+this.RowsSumNum+"条</span>" ;
                shtm += "&nbsp;<a href=\"javascript:" + MergFunctionName(this.FunctionStr,'1') + "\" class=\"prev\">首页</a>";  
                var i= (this.PageCount-this.PageNum)> 4 ? this.PageNum - 4: this.PageNum -(8-(this.PageCount-this.PageNum));
                var j=0;                
                if(i > 1){
                    var temp = i-6 >0 ? i-6: 1;
                    shtm += "<a href=\"javascript:" + MergFunctionName(this.FunctionStr,temp) + "\">...</a>";
                }
                while( i< this.PageNum ){                    
                    if(i > 0){
                        shtm += "<a href=\"javascript:" + MergFunctionName(this.FunctionStr,i) + "\">" + i + "</a>";
                        j++;
                    }
                    i++;
                }
                if(i==this.PageNum){					
                    shtm += "<strong>" + i + "</strong>";
                    i++;
                    j++;
                }   
                while(i> 0 && i<= this.PageCount && j < 5 )
                {
                    shtm += "<a href=\"javascript:" + MergFunctionName(this.FunctionStr,i) + "\">" + i + "</a>";
                    i++;
                    j++;
                }
                if(i<=this.PageCount){
                    var temp = i+4 < this.PageCount ? i+4 : this.PageCount;
                    shtm += "<a href=\"javascript:" + MergFunctionName(this.FunctionStr,temp) + "\">...</a>";
                }
                shtm +="&nbsp;<a href=\"javascript:" + MergFunctionName(this.FunctionStr,this.PageCount) + "\" class=\"next\">末页</a>";
                this.DivID.innerHTML = shtm;                
                this.DivID.style.display="block";                
            }
            else if( this.CurrentRowNum > 0){
            	this.DivID.innerHTML="<span>共1页/"+this.RowsSumNum+"条</span> ";
            	this.DivID.style.display="block";
            }
            else
            {
            	this.DivID.innerHTML="";
            	this.DivID.style.display="none";
            }
        }       
    }

};

//构造一个函数

function MergFunctionName() {
    var result = arguments[0] + "(", a = arguments;
    if (a.length > 1) {
        for (i = 1; i < a.length; i++) {
            result += "\'" + arguments[i] + "\'";
            if (i != (a.length - 1))
                result += ",";
        }
    }
    result += ")";
    return result;
}



 