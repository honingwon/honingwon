/*
格式化普通树
*/

//节点入口
NodesEnty = BMClass.create();

NodesEnty.prototype = {
    initialize : function() {
        this.aValue = null;
        this.aFValue = null;
        this.aName = null;
    }
};

Tree = BMClass.create();
Tree.prototype ={
    initialize : function() {
        this.NodesArray = new Array();
        this.divautotreecontainer = "divAutoTree";
        this.divaranktreecontainer = "divRankTree";
        this.autoTree = null;
    },
    GetNodes :function(sKey, sFkey, sName) {
        var Obj = new NodesEnty();
        Obj.aValue = sKey;
        Obj.aFValue = sFkey;
        Obj.aName = sName;
        this.NodesArray.push(Obj);
    },
    hasChildNodes : function(parentNode) {
        for (i = 0; i < this.NodesArray.length; i++) {
            var nodeValues = this.NodesArray[i];
            if (nodeValues.aFValue == parentNode) return true;
        }
        return false;
    },
    CreatTreeNode : function(rootName) {
        if (this.NodesArray.length == 0) {
            alert("没有数据，请先维护好基础数据！");
            return;
        }
        var _rootName = rootName ? rootName : "公司";
        var treeNodes = new TreeNode("1", _rootName, 1, null, null); //treeNodes.currentSpan.innerHTML="dasdasd";

        this.AddNodes("null", treeNodes, 2);
        this.autoTree = new AutoTree(treeNodes, this.divautotreecontainer, this.divautotreecontainer, null);
        this.autoTree.CreateTree();
    },
    AddNodes : function(sParent, Node, level) {
        var nextLevel = level + 1;
        for (var i = 0; i < this.NodesArray.length; i++) {
            if (this.NodesArray[i].aFValue == sParent) {
                var Nodes = new TreeNode(this.NodesArray[i].aValue, this.NodesArray[i].aName, level, null, Node);
                Node.AppendChildNode(Nodes);
                var ls = this.hasChildNodes(this.NodesArray[i].aValue); //alert(ls);
                if (ls){
                    this.AddNodes(this.NodesArray[i].aValue, Nodes, nextLevel);
                }
            }
        }
    }
};

var tree = new Tree();
