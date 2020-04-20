package en;

class Blood extends Entity {
    static var POOL : Array<Blood> = [];

    public function new(cx,cy,xr,yr) {
        super(cx,cy);
        this.xr = xr;
        this.yr = yr;

        Game.ME.scroller.removeChild(spr);
        Game.ME.scroller.add(spr, Const.DP_FX_BG);

        POOL.push(this);
        if (POOL.length > Const.MAX_BLOOD ) {
            POOL.shift().destroy();
        }
        // HACK: Adjust pivot
        spr.setPivotCoord(32 * 0.5, 32 * 0.75);
        var idx = irnd(1,2);
        spr.anim.play("blood-"+idx+"-anim").chainLoop("blood-"+idx+"-final");
        dir = irnd(0,1) * 2 - 1;
    }

    override public function dispose() {
        super.dispose();
        POOL.remove(this);
    }
}
