package scene.events
{
    import flash.events.*;

    public class MapEvent extends Event
    {
        public var col:int;
        public var row:int;
        public static const NEED_DATA:String = "needData";

        public function MapEvent(type:String, row:int, col:int, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            this.row = row;
            this.col = col;
            super(type, bubbles, cancelable);
            return;
        }// end function

    }
}
