function ArrayList(){
 private:
 this.buffer=new Array();
 var args=ArrayList.arguments;
 if(args.length>0) this.buffer=args[0];
 this.length=this.buffer.length;


 function ListIterator(table,len){

        this.table=table;
  this.len=len;                          
        this.index=0;
  
  this.hasNext=hasNext;
  function hasNext() {
   return this.index< this.len;
        }

        this.next=next;
  function next() { 
   if(!this.hasNext())
    throw "No such Element!";
      return this.table[this.index++];
        }
    }
 
 public:
 this.hashCode=hashCode;
 function hashCode(){
  var h=0;
  for(var i=0;i<this.lengh;i++)
   h+=this.buffer[i].hashCode();
  return h;
 }
 
 this.size=size;
 function size(){
  return this.length;
 }

 
 this.clear=clear;
 function clear(){
  this.length=0;
 }

 
 this.isEmpty=isEmpty;
 function isEmpty(){
  return this.length==0;
 }
 
 
 this.toArray=toArray;
 function toArray(){
  var copy=new Array();
  for(var i=0;i<this.length;i++){
   copy[i]=this.buffer[i];
  }
  return copy;
 }

 this.get=get;
 function get(index){
  if(index>=0 && index<this.length)
   return this.buffer[index];
  return null;
 }

 
 this.remove=remove;
 function remove(param){
  var index=0;
  
  if(isNaN(param)){
   index=this.indexOf(param);
  }
  else index=param;
  
  
  if(index>=0 && index<this.length){
   for(var i=index;i<this.length-1;i++)
    this.buffer[i]=this.buffer[i+1];
   this.length-=1;
   return true;
  }
  else return false;
 }
 
 this.add=add;
 function add(){
  var args=add.arguments;
  if(args.length==1){
   this.buffer[this.length++]=args[0];
   return true;
  }
  else if(args.length==2){
   var index=args[0];
   var obj=args[1];
   if(index>=0 && index<=this.length){
    for(var i=this.length;i>index;i--)
     this.buffer[i]=this.buffer[i-1];
     this.buffer[i]=obj;
    this.length+=1;
    return true;
   }
  }
  return false;
 }

 this.indexOf=indexOf;
 function indexOf(obj){
  for(var i=0;i<this.length;i++){
   if(this.buffer[i].equals(obj)) return i;
  }
  return -1;
 }

 
 this.lastIndexOf=lastIndexOf;
 function lastIndexOf(obj){
  for(var i=this.length-1;i>=0;i--){
   if(this.buffer[i].equals(obj)) return i;
  }
  return -1;
 }

 this.contains=contains;
 function contains(obj){
  return this.indexOf(obj)!=-1;
 }

 this.equals=equals;
 function equals(obj){
  if(this.size()!=obj.size()) return false;
  for(var i=0;i<this.length;i++){
   if(!obj.contains(this.buffer[i])) return false;
  }
  return true;
 }


 this.addAll=addAll;
 function addAll(list){
  var mod=false;
  for(var it=list.iterator();it.hasNext();){
   var v=it.next();
   if(this.add(v)) mod=true;
  }
  return mod;  
 }
 
 this.containsAll=containsAll;
 function containsAll(list){
  for(var i=0;i<list.size();i++){
   if(!this.contains(list.get(i))) return false;
  }
  return true;
 }

 this.removeAll=removeAll;
 function removeAll(list){
  for(var i=0;i<list.size();i++){
   this.remove(this.indexOf(list.get(i)));
  }
 }
 
 
 this.retainAll=retainAll;
 function retainAll(list){
  for(var i=this.length-1;i>=0;i--){
   if(!list.contains(this.buffer[i])){
    this.remove(i);
   }
  }
 }

 this.subList=subList;
 function subList(begin,end){
  if(begin<0) begin=0;
  if(end>this.length) end=this.length;
  var newsize=end-begin;
  var newbuffer=new Array();
  for(var i=0;i<newsize;i++){
   newbuffer[i]=this.buffer[begin+i];
  }
  return new ArrayList(newbuffer);
 }
 
 this.set=set;
 function set(index,obj){
  if(index>=0 && index<this.length){
   temp=this.buffer[index];
   this.buffer[index]=obj;
   return temp;
  }
 }

 this.iterator=iterator;
 function iterator(){
  return new ListIterator(this.buffer,this.length);
 }
 
}
