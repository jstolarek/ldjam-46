package en;

class Blood extends Entity {
    static var POOL : Array<Blood> = [];

    public function new(x,y) {
        super(x,y);

        Game.ME.scroller.removeChild(spr);
        Game.ME.scroller.add(spr, Const.DP_FX_BG);

        POOL.push(this);
        if (POOL.length > Const.MAX_BLOOD ) {
            POOL.shift().destroy();
        }
        spr.anim.play("blood-1-anim").chainLoop("blood-1-final");
    }

    override public function dispose() {
        super.dispose();
        POOL.remove(this);
    }
}
