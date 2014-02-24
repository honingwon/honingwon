//--------------------------------------------------------------------------
// Build an auto tree
// Create by jpshen
//--------------------------------------------------------------------------
// Create an auto tree
// Parameters: nodes, father container
function AutoCheckTree(root, container, id, icons) {
    var self = this;
    this.Id = id;
    this.RootNode = root;                                   // Type of TreeNode
    this.DivContainer = document.getElementById(container); // father container  
    this.currentSpan = null;                                // Selected span
    this.currentNode = null;                                // Selected node
    var imgPath = "../images/AutoTree/";                    // The folder of images
    var ImgAuto = new Array();                              // Images                          
    for (var i = 0; i < 15; i++)
        ImgAuto[i] = new Image(18, 18);
    ImgAuto[0].src = imgPath + (icons == null ? "Root.gif" : icons[0]);
    ImgAuto[1].src = imgPath + (icons == null ? "RamusOpen.gif" : icons[1]);
    ImgAuto[2].src = imgPath + (icons == null ? "RamusClose.gif" : icons[2]);
    ImgAuto[3].src = imgPath + (icons == null ? "Leaf.gif" : icons[3]);
    ImgAuto[4].src = imgPath + "Join.gif"; ImgAuto[5].src = imgPath + "JoinBottom.gif";
    ImgAuto[6].src = imgPath + "Line.gif"; ImgAuto[7].src = imgPath + "Empty.gif";
    ImgAuto[8].src = imgPath + "Minus.gif"; ImgAuto[9].src = imgPath + "MinusBottom.gif";
    ImgAuto[10].src = imgPath + "Plus.gif"; ImgAuto[11].src = imgPath + "PlusBottom.gif";
    ImgAuto[12].src = imgPath + "UnCheck.gif"; ImgAuto[13].src = imgPath + "Check.gif";
    ImgAuto[14].src = imgPath + "CheckPart.gif";

    // Create the tree
    this.CreateTree = function() {
        self.DivContainer.innerHTML = "";
        BuildTree(self.RootNode, self.DivContainer);
        self.currentNode = root;
        self.currentSpan = self.DivContainer.firstChild.lastChild;
    }

    // Initialize check state
    // Parameters: the checked nodes' values
    this.InitializeCheck = function(checkArray) {
        if (checkArray == null) { return; }
        ChangeChilidrenStates(self.DivContainer.firstChild.lastChild.previousSibling.previousSibling, self.RootNode, false);
        SetNodesCheckStates(self.DivContainer.firstChild.lastChild.previousSibling.previousSibling, self.RootNode, checkArray);
    }

    this.GetRightChangeArray = function() {
        var addRight = [];
        var subRight = [];
        if (self.RootNode.ChildNodes != null) {
            for (var i = 0; i < self.RootNode.ChildNodes.length; i++) {
                GetNodeRightDetail(self.RootNode.ChildNodes[i], addRight, subRight);
            }
        }
        var right = new Array(2);
        right[0] = addRight;
        right[1] = subRight;
        
        return right;       


    }

    var GetNodeRightDetail = function(node, addRight, subRight) {
        var sum = node.CurrentCheck + node.LastCheck;   // 9 circumstance, do it your self 
        if (node.CurrentCheck != node.LastCheck && sum != 3) {
            var changeType = node.CurrentCheck > 0 ? 1 : 0;
            if (changeType) { addRight.push(node.Value); }
            else { subRight.push(node.Value); }
        }
        if (node.ChildNodes != null) {
            for (var i = 0; i < node.ChildNodes.length; i++) {
                GetNodeRightDetail(node.ChildNodes[i], addRight, subRight);
            }
        }
    }

    ///////////////////////////-----ycchen08-5-13 IP right
    this.GetIpRightChangeArrayNew = function() {
        var sFFaRight = []; //class
        if (self.RootNode.ChildNodes != null) {
            for (var i = 0; i < self.RootNode.ChildNodes.length; i++) {
                GetNodeIpRightDetailNew(self.RootNode.ChildNodes[i], sFFaRight);
            }
        }
        var right = new Array();
        right[0] = sFFaRight;
        return right;


    }

    var GetNodeIpRightDetailNew = function(node, sFFaRight) {
        if (node.Level == 2 && node.CurrentCheck == 1) {
            sFFaRight.push(node.Value);
        }
    }
    ///////////////////////////-----ycchen08-5-13 IP right

    ///////////////////////////-----ycchen08-5-13 server right
    this.GetRightChangeArrayNew = function() {
        var addRight = []; //server
        var sFaRight = []; //area
        var sFFaRight = []; //class
        if (self.RootNode.ChildNodes != null) {
            for (var i = 0; i < self.RootNode.ChildNodes.length; i++) {
                GetNodeRightDetailNew(self.RootNode.ChildNodes[i], addRight, sFaRight, sFFaRight);
            }
        }
        var right = new Array(3);
        right[0] = addRight;
        right[1] = sFaRight;
        right[2] = sFFaRight;
        return right;


    }

    var GetNodeRightDetailNew = function(node, addRight, sFaRight, sFFaRight) {
        var sum = node.CurrentCheck + node.LastCheck;   // 9 circumstance, do it your self 
        if (node.CurrentCheck != node.LastCheck && sum != 3) {
            if (node.Level == 4) {
                var currentchangeType = node.CurrentCheck > 0 ? 1 : 0;
                if (currentchangeType) {
                    addRight.push(node.Value); _nodearea = node.ParentNode;
                    sFaRight.push(_nodearea.Value); _nodeclass = _nodearea.ParentNode;
                    sFFaRight.push(_nodeclass.Value);
                }
            }
        }
        if (node.CurrentCheck == 1 && node.LastCheck == 1 && node.Level == 4) {
            addRight.push(node.Value); _nodearea = node.ParentNode;
            sFaRight.push(_nodearea.Value); _nodeclass = _nodearea.ParentNode;
            sFFaRight.push(_nodeclass.Value);
        }
        if (node.ChildNodes != null) {
            for (var i = 0; i < node.ChildNodes.length; i++) {
                GetNodeRightDetailNew(node.ChildNodes[i], addRight, sFaRight, sFFaRight);
            }
        }
    }
    ///////////////////////////-----ycchen08-5-13

    // Draw the node item on father container(using recursion)
    // Parameters: node item, father container
    var BuildTree = function(node, parent) {
        parent.appendChild(CreateNode(node));
        if (node.ChildNodes == null || node.ChildNodes.length <= 0)
            return;
        var divChild = document.createElement("div");
        parent.appendChild(divChild);
        for (var i = 0; i < node.ChildNodes.length; i++)
            BuildTree(node.ChildNodes[i], divChild);
    }

    // Get one node's images
    // Parameters: node item
    // Return: the node's images
    var CreateNode = function(node) {
        var images = new Array(node.Level);
        if (node.Level == 1)                            // Is root node
            images[node.Level - 1] = ImgAuto[0];
        else
            images[node.Level - 1] = node.ChildNodes == null ? ImgAuto[3] : ImgAuto[1];
        if (node.ParentNode != null) {                    // Has children nodes
            var tempBool = node.ParentNode.ChildNodes[node.ParentNode.ChildNodes.length - 1] == node;
            if (node.ChildNodes == null)
                images[node.Level - 2] = tempBool ? ImgAuto[5] : ImgAuto[4];
            else
                images[node.Level - 2] = tempBool ? ImgAuto[9] : ImgAuto[8];
            var tempParent = node.ParentNode;
            for (var i = node.Level - 3; i >= 0; i--) {
                tempBool = tempParent.ParentNode.ChildNodes[tempParent.ParentNode.ChildNodes.length - 1] == tempParent;
                images[i] = tempBool ? ImgAuto[7] : ImgAuto[6];
                tempParent = tempParent.ParentNode;
            }
        }
        var divChild = document.createElement("div");
        for (var i = 0; i < images.length - 1; i++)
            divChild.appendChild(CreateImage(images[i]));
        divChild.appendChild(CreateCheck(node));
        divChild.appendChild(CreateImage(images[images.length - 1]));
        divChild.appendChild(CreateSpan(node));
        return divChild;
    }

    // Create an image element
    // Parameters: image
    // Return: image element
    var CreateImage = function(img) {   // Create document object   
        var image = document.createElement("img");
        image.src = img.src;
        image.align = "absmiddle";
        if (img.src == ImgAuto[8].src || img.src == ImgAuto[9].src)
            image.onclick = function() { RamusFlex(image); }
        return image;
    }

    // Create a span element
    // Parameters: node item
    // Return: span element
    var CreateSpan = function(node) {
        var span = document.createElement("span");
        span.className = "caption";
        span.setAttribute("value", node.Value);
        span.innerHTML = node.Text;
        span.onclick = function() { CaptionOnClick(span, node); }
        return span;
    }

    // Create a check box element
    // Parameters: node item
    // Return: check box element
    var CreateCheck = function(node) {
        var image = document.createElement("img");
        image.src = ImgAuto[12].src;
        image.setAttribute("value", "0");
        image.align = "absmiddle";
        image.onclick = function() { CheckOnClick(image, node); }
        return image;
    }

    // Event of show or hide children
    // Parameters: target image
    var RamusFlex = function(target) {
        if (target.nextSibling.src == ImgAuto[3].src)
            return;
        var display = target.parentNode.nextSibling.style.display;
        var isBottom = !(target.src.indexOf("ottom.gif") == -1);    // Is this icon a bottom icon
        if (display == null || display == "") {
            target.parentNode.nextSibling.style.display = "none";   // Change display state to hide
            target.src = ImgAuto[isBottom ? 11 : 10].src;           // Change join icon
            target.nextSibling.nextSibling.src = ImgAuto[2].src;    // Change folder icon to close
        }
        else {
            target.parentNode.nextSibling.style.display = "";       // Change display state to show
            target.src = ImgAuto[isBottom ? 9 : 8].src;             // Change join icon
            target.nextSibling.nextSibling.src = ImgAuto[1].src;    // Change folder icon to open
        }
    }

    var CaptionOnClick = function(span, node) {
        if (self.currentSpan == span)
            return;
        self.currentSpan = span;
        self.currentNode = node;
    }

    var CheckOnClick = function(image, node) {
        var checkState = image.value == "0" ? true : false;
        ChangeChilidrenStates(image, node, checkState);
        if (node.ParentNode != null) {
            ChangeEldershipStates(image.parentNode.parentNode.previousSibling.lastChild.previousSibling.previousSibling, node.ParentNode);
        }
    }

    var ChangeChilidrenStates = function(image, node, checked) {
        image.src = ImgAuto[checked ? 13 : 12].src;
        image.value = checked ? 1 : 0;
        node.CurrentCheck = checked ? 1 : 0;
        if (node.ChildNodes == null)
            return;
        var offset = 0;
        for (var i = 0; i < node.ChildNodes.length; i++) {
            var imgChild = image.parentNode.nextSibling.childNodes[i + offset].lastChild.previousSibling.previousSibling;
            ChangeChilidrenStates(imgChild, node.ChildNodes[i], checked);
            if (node.ChildNodes[i].ChildNodes != null) { offset++; }
        }
    }

    var ChangeEldershipStates = function(image, node) {
        var hasPart = false;
        var tmpState = 0;
        for (var i = 0; i < node.ChildNodes.length; i++) {
            var state = node.ChildNodes[i].CurrentCheck;
            if (state == 2) { hasPart = true; break; }
            tmpState += state;
        }
        var selfState;
        if (hasPart) { selfState = 2; }
        else if (tmpState == 0) { selfState = 0; }
        else if (tmpState == node.ChildNodes.length) { selfState = 1; }
        else { selfState = 2; }
        if (node.CurrentCheck != selfState) {
            image.src = ImgAuto[12 + selfState].src;
            image.value = selfState;
            node.CurrentCheck = selfState;
            if (node.ParentNode != null) {
                ChangeEldershipStates(image.parentNode.parentNode.previousSibling.lastChild.previousSibling.previousSibling, node.ParentNode);
            }
        }
    }

    var SetNodesCheckStates = function(image, node, array) {
        var checked = CheckValueFromArray(node.Value, array);
        node.LastCheck = checked ? 1 : 0;
        if (node.ChildNodes == null) {
            if (checked) {
                image.src = ImgAuto[13].src;
                image.value = "1";
                node.CurrentCheck = 1;
                ChangeEldershipStates(image.parentNode.parentNode.previousSibling.lastChild.previousSibling.previousSibling, node.ParentNode);
            }
        }
        else {
            var offset = 0;
            for (var i = 0; i < node.ChildNodes.length; i++) {
                var imgChild = image.parentNode.nextSibling.childNodes[i + offset].lastChild.previousSibling.previousSibling;
                SetNodesCheckStates(imgChild, node.ChildNodes[i], array);
                if (node.ChildNodes[i].ChildNodes != null) { offset++; }
            }
        }
    }

    var CheckValueFromArray = function(value, array) {
        for (var i = 0; i < array.length; i++) {
            if (array[i] == value) { return true; }
        }
        return false;
    }
}

// Build a tree node
// Parameters: value, text, level, children nodes, parent node
function TreeCheckNode(value, text, level, children, parent) {
    this.Value = value;             // Value of this node
    this.Text = text;               // Text of this node
    this.Level = level;             // The node's level, the root node's level is 1
    this.ChildNodes = children;     // Array of TreeNode
    this.ParentNode = parent;       // Parent node
    this.Tag = null;                // Tag Data
    this.LastCheck = 0;             // Last check state(0: unchecked, 1: checked, 2: part checked)
    this.CurrentCheck = 0;          // Current check state
    var self = this;                // Pointer of this

    // Append a node as a child of self
    // Parameters: node item
    this.AppendChildNode = function(node) {
        var position;
        if (self.ChildNodes == null) {   // Get append position
            position = 0;
            self.ChildNodes = new Array();
        }
        else
            position = self.ChildNodes.length;
        if (node.ParentNode != self)// set parent node 
            node.ParentNode = self;
        self.ChildNodes[position] = node;
    }

    // Remove self from tree
    this.RemoveNodeSelf = function() {
        var parentOfSelf = self.ParentNode;
        if (parentOfSelf == null)
            return;
        for (var i = 0; i < parentOfSelf.ChildNodes.length; i++) {
            if (self == parentOfSelf.ChildNodes[i]) {
                parentOfSelf.ChildNodes.splice(i, 1);   // Delete self
                if (parentOfSelf.ChildNodes.length == 0)// Set default of ChildNodes
                    parentOfSelf.ChildNodes = null;
                break;
            }
        }
    }
}
