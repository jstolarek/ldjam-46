package en;

class Breadcrumbs extends Entity {
  public static var ME : Null<Breadcrumbs> = null;
  public static var limit = Const.BREAD_LIMIT;

  static public function throwBread(cx, cy, tx, ty) {
    if ( ME == null && limit > 0 ) {
      ME = new Breadcrumbs(cx,cy, tx, ty);
      limit--;
      Game.ME.delayer.addS( function() {
        ME.destroy();
        ME = null;
        } , 3);
    }
  }

  function new(cx, cy, tx, ty) {
    super(cx,cy);

    Game.ME.scroller.removeChild(spr);
    Game.ME.scroller.add(spr, Const.DP_FX_BG);

    frict=Const.BREAD_FRICT;
    yr=0.8;
    var fx = (cx+0.5)*Const.GRID;
    var fy = (cy+0.5)*Const.GRID;
    var norm = M.dist(fx, fy, tx, ty);
    dx = (tx-fx)/norm * Const.BREAD_SPEED;
    dy = (ty-fy)/norm * Const.BREAD_SPEED;

    spr.anim.playAndLoop("bread-flying");
  }

    override function fixedUpdate() {
        super.fixedUpdate();

        if (dx == 0 && dy == 0) {
            spr.anim.play("bread-spilling").chainLoop("bread-spilled");
        }
    }
}
