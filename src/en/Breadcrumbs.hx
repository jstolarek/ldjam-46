package en;

class Breadcrumbs extends Entity {
  public static var ME : Null<Breadcrumbs> = null;
  public static var limit = Const.BREAD_LIMIT;

  static public function throwBread(cx, cy, xr, yr, tx, ty) {
    if ( ME == null && limit > 0 ) {
      ME = new Breadcrumbs(cx,cy, xr, yr, tx, ty);
      limit--;
      Game.ME.delayer.addS( function() {
        ME.destroy();
        ME = null;
        } , 3);
    }
  }

  function new(cx, cy, xr, yr, tx, ty) {
    super(cx,cy);
    this.xr = xr;
    this.yr = yr;
    // HACK: Adjust pivot
    spr.setPivotCoord(32 * 0.5, 32 * 0.5);

    Game.ME.scroller.removeChild(spr);
    Game.ME.scroller.add(spr, Const.DP_FX_BG);

    frict = Const.BREAD_FRICT;

    var norm = M.dist(xx, yy, tx, ty);
    dx = (tx-xx)/norm * Const.BREAD_SPEED;
    dy = (ty-yy)/norm * Const.BREAD_SPEED;

    spr.anim.playAndLoop("bread-flying");
  }

    override function fixedUpdate() {
        super.fixedUpdate();

        if (dx == 0 && dy == 0) {
            spr.anim.play("bread-spilling").chainLoop("bread-spilled");
        }
    }
}
