class Const {
    public static var FPS = 60;
    public static var FIXED_FPS = 30;
    public static var AUTO_SCALE_TARGET_WID = 512; // -1 to disable auto-scaling on width
    public static var AUTO_SCALE_TARGET_HEI = 288; // -1 to disable auto-scaling on height
    public static var SCALE = 3.75; // ignored if auto-scaling
    public static var UI_SCALE = 1.0;
    public static var GRID = 16;

    static var _uniq = 0;
    public static var NEXT_UNIQ(get,never) : Int; static inline function get_NEXT_UNIQ() return _uniq++;
    public static var INFINITE = 999999;

    static var _inc = 0;
    public static var DP_BG = _inc++;
    public static var DP_FX_BG = _inc++;
    public static var DP_MAIN = _inc++;
    public static var DP_FRONT = _inc++;
    public static var DP_FX_FRONT = _inc++;
    public static var DP_TOP = _inc++;
    public static var DP_UI = _inc++;

    public static var HEALTH = 100;
    public static var SPEED = 0.035;
    public static var STONE_SPEED = 0.8;
    public static var STONE_FRICT = 0.92;
    public static var MAX_STONES = 100;
    public static var STONE_COOLDOWN = 250; //ms
    public static var PIGEON_STRENGTH = 10;
    public static var PIGEON_SCORE = 10;
}
