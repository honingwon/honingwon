// JScript 文件
Tbody = BMClass.create()
Tbody.prototype = {
    /*
    columns:列数
    tbodyID:tbodyID
    */
    initialize: function(ColCount, tbodyID) {
        this.ColCount = ColCount;
        this.TbodyObj = document.getElementById(tbodyID);
    },
    DelAll: function() {
        if (this.TbodyObj != null) { while (this.TbodyObj.rows.length > 0) { this.TbodyObj.deleteRow(-1); } }
    },
    /*
    添加行

    项内容,项classname,项对齐方式

    */
    AddRow: function(Items, ItemCssNames, aligns, Widths, colspan, trid,rowCssName) {
        var tbRow = this.TbodyObj.insertRow(-1);
        tbRow.id = trid;
        tbRow.className = rowCssName;
        var curCount = Items.length;
        for (var i = 0; i < curCount; i++) {
            var Cell = tbRow.insertCell(-1);
            if (curCount < this.ColCount && i == curCount - 1) {
                Cell.colSpan = this.ColCount - curCount + 1;
            }
            if (Widths != null && Widths[i] != null) {
                Cell.width = Widths[i];
            }
            if (ItemCssNames != null && ItemCssNames[i] != null) {
                Cell.className = ItemCssNames[i];
            }
            if (aligns != null && aligns[i] != null) {
                Cell.align = aligns[i];
            }
            if (colspan != null && colspan[i] != null && parseInt(colspan[i]) != 1) {
                Cell.colSpan = colspan[i];
                Cell.innerHTML = Items[colspan[i] - 1];
                i = i + colspan[i] - 1;
            }
            else {
                Cell.innerHTML = Items[i];
            }
        }
    },
    /*
    更改
    rows:行

    cells:列

    body:内容
    */
    Change: function(rows, cells, body) {
        this.TbodyObj.rows[rows].cells[cells].innerHTML = body;
    },
    DelRow: function(index) {
        if (this.TbodyObj != null) { this.TbodyObj.deleteRow(index); }
    },
    RowCount: function() {
        if (this.TbodyObj != null) { return this.TbodyObj.rows.length; }
    }

};
///////////////////////////////////////////////  
//   功能：合并表格  
//   参数：tb－－需要合并的表格ID  
//   参数：colLength－－需要对前几列进行合并，比如，  
//   想合并前两列，后面的数据列忽略合并，colLength应为2  
//   缺省表示对全部列合并  
//   data:   2005.11.6  
///////////////////////////////////////////////
function uniteTable(tb, colLength) {
    //   检查表格是否规整  
    //if (!checkTable(tb)) return;
    var i = 0;
    var j = 0;
    var rowCount = tb.rows.length; //   行数  
    var colCount = tb.rows[0].cells.length; //   列数  
    var obj1 = null;
    var obj2 = null;
    //   为每个单元格命名  
    for (i = 0; i < rowCount; i++) {
        for (j = 0; j < tb.rows[i].cells.length; j++) {
            tb.rows[i].cells[j].id = "tb__" + i.toString() + "_" + j.toString();
        }
    }
    //   逐列检查合并  
    for (i = 0; i < colCount; i++) {
        if (i == colLength) return;
        obj1 = document.getElementById("tb__0_" + i.toString())
        for (j = 1; j < rowCount; j++) {
            obj2 = document.getElementById("tb__" + j.toString() + "_" + i.toString());
            if (obj1.innerHTML == obj2.innerHTML) {
                obj1.rowSpan++;
                obj2.parentNode.removeChild(obj2);
            } else {
                obj1 = document.getElementById("tb__" + j.toString() + "_" + i.toString());
            }
        }
    }
}
/////////////////////////////////////////  
//   功能：检查表格是否规整  
//   参数：tb－－需要检查的表格ID  
//   data:   2005.11.6  
/////////////////////////////////////////
function checkTable(tb) {
    if (tb.rows.length == 0) return false;
    if (tb.rows[0].cells.length == 0) return false;
    for (var i = 0; i < tb.rows.length; i++) {
        var cellsNum = tb.rows[i].cells.length;
        for (var j = 0; j < tb.rows[i].cells.length; j++) {
            if (tb.rows[i].cells[j].colSpan != null) {
                cellsNum += tb.rows[i].cells[j].colSpan - 1;
            }
        }
        if (tb.rows[0].cells.length != cellsNum) return false;
    }
    return true;
}

//基函数

function ge(z) { return typeof (z) == "object" ? z : document.getElementById(z); }
function gE(o, z) { return typeof (o) == "string" ? $e(o).getElementsByTagName(z) : o.getElementsByTagName(z); }
function ac(z) { var a = 0, b = 0; while (z) { a += z.offsetLeft; b += z.offsetTop; z = z.offsetParent } return [a, b] }

//匹配寻找父节点 o:Object z:Elemnt Style
function $match(o, z) { o = o.parentNode; while (o.nodeName != z.toUpperCase()) { o = o.parentNode; } return o; }
//tr鼠标事件		type: 0:鼠标效果 1:单行选择 2:多行选择
function addMouseEvent(obj, type) {
    var atr = gE(gE(obj, "tbody")[0], "tr");
    for (i = 0; i < atr.length; i++) {
        try {
            var atd = gE(atr[i], "td");
            if (atd[0].className == "hint" || atd[1].className == "hint") continue;
        } catch (e) { }
        if (type == 1) {
            atr[i].onclick = function() {
                if (!obj.selectTR) obj.selectTR = this;
                obj.selectTR.className = "";
                this.className = "currenttr";
                obj.selectTR = this;
            }
        } else if (type == 2) {
            var cb = gE(atr[i], "input")[0];
            cb = cb && cb.type == "checkbox" ? cb : false;
            cb.trselect = cb ? true : false;
            atr[i].onclick = function() {
                this.className = this.className != "currenttr" ? "currenttr" : "";
                var _cb = gE(this, "input")[0];
                if (_cb && _cb.type == "checkbox") _cb.checked = this.className == "currenttr" ? true : false;
            }
        }
        atr[i].onmouseover = function() { this.style.cursor = "pointer"; this.className = this.className == "currenttr" ? "currenttr" : "hover"; }
        atr[i].onmouseout = function() { this.className = this.className == "currenttr" ? "currenttr" : ""; }
    }
}