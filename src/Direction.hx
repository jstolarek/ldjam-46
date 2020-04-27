@:enum
abstract Direction(Int) {
    var UP         = 0;
    var UP_RIGHT   = 1;
    var RIGHT      = 2;
    var DOWN_RIGHT = 3;
    var DOWN       = 4;
    var DOWN_LEFT  = 5;
    var LEFT       = 6;
    var UP_LEFT    = 7;

    public inline function new( v : Int ){
        this = v;
    }

    public inline function getIndex() : Int {
        return this;
    }

    inline public static var LENGTH = 8;
}
