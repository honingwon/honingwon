//--------------------------------------------------------------------------
// Build an auto tree
//--------------------------------------------------------------------------
// Create an auto tree
// Parameters: nodes, father container
function AutoTree(root, container, id, icons) {
    var self = this;
    this.Id = id;
    this.RootNode = root;                                   // Type of TreeNode
    this.DivContainer = document.getElementById(container); // father container  
    this.currentSpan = null;                                // Selected span
    this.currentNode = null;                                // Selected node
    var imgPath = "../images/AutoTree/";                  // The folder of images
    var ImgAuto = new Array();                          // Images                          
    for (var i = 0; i < 12; i++)
        ImgAuto[i] = new Image();
    ImgAuto[0].src = imgPath + (icons == null ? "Root.gif" : icons[0]);
    ImgAuto[1].src = imgPath + (icons == null ? "RamusOpen.gif" : icons[1]);
    ImgAuto[2].src = imgPath + (icons == null ? "RamusClose.gif" : icons[2]);
    ImgAuto[3].src = imgPath + (icons == null ? "Leaf.gif" : icons[3]);
    ImgAuto[4].src = imgPath + "Join.gif"; ImgAuto[5].src = imgPath + "JoinBottom.gif";
    ImgAuto[6].src = imgPath + "Line.gif"; ImgAuto[7].src = imgPath + "Empty.gif";
    ImgAuto[8].src = imgPath + "Minus.gif"; ImgAuto[9].src = imgPath + "MinusBottom.gif";
    ImgAuto[10].src = imgPath + "Plus.gif"; ImgAuto[11].src = imgPath + "PlusBottom.gif";

    // Create the tree
    this.CreateTree = function() {
        self.DivContainer.innerHTML = "";
        BuildTree(self.RootNode, self.DivContainer);
        self.currentNode = root;
        self.currentSpan = self.DivContainer.firstChild.lastChild;
        self.currentSpan.className = "captionActive";
    }

    this.SetSelectedToFirstChild = function() {
        if (self.RootNode.ChildNodes == null) { return; }
        self.currentNode = self.RootNode.ChildNodes[0];
        self.currentSpan.className = "caption";
        self.currentSpan = self.DivContainer.lastChild.firstChild.lastChild;
        self.currentSpan.className = "captionActive";
    }

    this.SetSelectedToRootNode = function() {
        if (self.RootNode == null) { return; }
        self.currentNode = self.RootNode;
        self.currentSpan.className = "caption";
        self.currentSpan = self.DivContainer.firstChild.lastChild;
        self.currentSpan.className = "captionActive";
    }

    // Insert a current selected node's child node(just single node)
    // Parameters: node item(just new data)
    this.InsertNode = function(node) {
        var needChange = (self.currentNode.ChildNodes == null); // Is need to change father node      
        self.currentNode.AppendChildNode(node);
        var insertNode = CreateNode(node);                      // The node which need insert
        var thisIcon = self.currentSpan.previousSibling;        // This node's icon
        var thisJoin = thisIcon.previousSibling;                // This node's join icon
        if (needChange) {
            var parentDiv = document.createElement("div");      // Need container
            parentDiv.appendChild(insertNode);
            var brothers;
            if (self.currentNode.Level == 1) { brothers = new Array(1); brothers[0] = self.currentNode; }
            else { brothers = self.currentNode.ParentNode.ChildNodes; } // Current node' brothers(include himself)          
            var hasNext = brothers[brothers.length - 1] != self.currentNode;    // Does this node have next sibling                  
            if (hasNext) {
                var sibling = self.currentSpan.parentNode.nextSibling;
                sibling.parentNode.insertBefore(parentDiv, sibling);            // Insert container into next sibling and self
                thisJoin.src = ImgAuto[8].src;
            }
            else {
                self.currentSpan.parentNode.parentNode.appendChild(parentDiv);  // Append container to last
                if (self.currentNode.Level != 1) { thisJoin.src = ImgAuto[9].src; }
            }
            if (self.currentNode.Level != 1) {
                thisIcon.src = ImgAuto[1].src;                      // Set icon
                thisJoin.onclick = function() { RamusFlex(thisJoin); }  // Bind events
            }
        }
        else {
            var brothers = self.currentNode.ChildNodes;  // Current node' brothers(include himself)
            var newIsUncle = brothers[brothers.length - 2].ChildNodes != null;  //Is previous brother a father
            if (newIsUncle) {
                SwapImageJoinBottom(self.currentSpan.parentNode.nextSibling.lastChild.previousSibling.lastChild.previousSibling.previousSibling);
                var changeCollection = brothers[brothers.length - 2].ChildNodes;
                var divContainer = self.currentSpan.parentNode.nextSibling.lastChild;   // The node's container
                var offset = 0;         // The position of div with span's offset
                for (var i = 0; i < changeCollection.length; i++) {
                    SwapImageLineEmpty(changeCollection[i], divContainer.childNodes[i + offset], node.Level - 2);
                    if (changeCollection[i].ChildNodes != null)
                        offset++;
                }
            }
            else
                SwapImageJoinBottom(self.currentSpan.parentNode.nextSibling.lastChild.lastChild.previousSibling.previousSibling);
            self.currentSpan.parentNode.nextSibling.appendChild(insertNode);
        }
    }

    // Remove current selected node(just single node)
    this.RemoveNode = function() {
        if (self.currentNode.ChildNodes != null)
            return;
        var needChange = self.currentNode.ParentNode.ChildNodes.length == 1;
        var fatherSpan = self.currentSpan.parentNode.parentNode.previousSibling.lastChild;
        if (needChange) {
            var fatherNode = self.currentNode.ParentNode;
            var fatherContainer = self.currentSpan.parentNode.parentNode;    // The node which need move's container
            if (self.currentNode.Level == 2) {   // Is reach root node
                fatherContainer.parentNode.removeChild(fatherContainer);
                return;
            }
            var isLastChild = fatherNode == fatherNode.ParentNode.ChildNodes[fatherNode.ParentNode.ChildNodes.length - 1];   // Is the node a only child 
            var fatherIcon = fatherContainer.previousSibling.lastChild.previousSibling;     // Father node's icon
            var fatherJoin = fatherIcon.previousSibling;                // Father node's join image   
            fatherJoin.src = ImgAuto[isLastChild ? 5 : 4].src;
            fatherContainer.parentNode.removeChild(fatherContainer);
            fatherIcon.src = ImgAuto[3].src;
            fatherIcon.onclick = null;
        }
        else {
            var brothers = self.currentNode.ParentNode.ChildNodes;  // Current node' brothers(include himself)
            var isLastChild = self.currentNode == brothers[brothers.length - 1]; // Is this node a last child
            if (isLastChild) {
                var nowIsUncle = brothers[brothers.length - 2].ChildNodes != null;  // Is previous brother a father
                if (nowIsUncle) {
                    var changeCollection = brothers[brothers.length - 2].ChildNodes;
                    var divContainer = self.currentSpan.parentNode.previousSibling; // This node's container
                    var offset = 0;         // The position of div with span's offset
                    for (var i = 0; i < changeCollection.length; i++) {
                        SwapImageLineEmpty(changeCollection[i], divContainer.childNodes[i + offset], self.currentNode.Level - 2);
                        if (changeCollection[i].ChildNodes != null)
                            offset++;
                    }
                    SwapImageJoinBottom(self.currentSpan.parentNode.previousSibling.previousSibling.lastChild.previousSibling.previousSibling);
                }
                else
                    SwapImageJoinBottom(self.currentSpan.parentNode.previousSibling.lastChild.previousSibling.previousSibling);
            }
            var selfNode = self.currentSpan.parentNode;
            selfNode.parentNode.removeChild(selfNode);
        }
        var selectedNode = self.currentNode;
        self.currentNode = self.currentNode.ParentNode;
        self.currentSpan = fatherSpan;
        self.currentSpan.className = "captionActive";
        selectedNode.RemoveNodeSelf();
    }

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
        for (var i = 0; i < images.length; i++)
            divChild.appendChild(CreateImage(images[i]));
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

    // Event of show or hide children
    // Parameters: target image
    var RamusFlex = function(target) {
        if (target.nextSibling.src == ImgAuto[3].src)
            return;
        var display = target.parentNode.nextSibling.style.display;
        var isBottom = !(target.src.indexOf("ottom.gif") == -1);        // Is this icon a bottom icon
        if (display == null || display == "") {
            target.parentNode.nextSibling.style.display = "none";       // Change display state to hide
            target.src = ImgAuto[isBottom ? 11 : 10].src;           // Change join icon
            target.nextSibling.src = ImgAuto[2].src;                // Change folder icon to close
        }
        else {
            target.parentNode.nextSibling.style.display = "";           // Change display state to show
            target.src = ImgAuto[isBottom ? 9 : 8].src;             // Change join icon
            target.nextSibling.src = ImgAuto[1].src;                // Change folder icon to open
        }
    }

    var CaptionOnClick = function(span, node) {
        if (self.currentSpan == span)
            return;
        self.currentSpan.className = "caption";
        self.currentSpan = span;
        self.currentNode = node;
        self.currentSpan.className = "captionActive";
        LoadNodeInformation(node, self.Id);
    }

    // Swap image between bottom and unbottom
    var SwapImageJoinBottom = function(target) {
        if (target.src == null)
            return;
        var strSrcLower = target.src.toLowerCase();
        var isBottom = !(strSrcLower.indexOf("bottom.gif") == -1);
        target.src = isBottom ? strSrcLower.replace("bottom.gif", ".gif") :
                                strSrcLower.replace(".gif", "bottom.gif");
    }

    // Swap image between line and empty
    // Parameters: node item, div item, change position(level - 1)
    var SwapImageLineEmpty = function(node, div, position) {
        var isEmpty = div.childNodes[position].src.toLowerCase().indexOf("empty.gif") != -1;
        div.childNodes[position].src = isEmpty ? ImgAuto[6].src : ImgAuto[7].src;
        if (node.ChildNodes == null)
            return;
        var offset = 0;         // The position of div with span's offset
        for (var i = 0; i < node.ChildNodes.length; i++) {
            SwapImageLineEmpty(node.ChildNodes[i], div.nextSibling.childNodes[i + offset], position);
            if (node.ChildNodes[i].ChildNodes != null)
                offset++;
        }
    }
}

// Build a tree node
// Parameters: value, text, level, children nodes, parent node
function TreeNode(value, text, level, children, parent) {
    this.Value = value;             // Value of this node
    this.Text = text;               // Text of this node
    this.Level = level;             // The node's level, the root node's level is 1
    this.ChildNodes = children;     // Array of TreeNode
    this.ParentNode = parent;       // Parent node
    this.Tag = null;                // Tag Data
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