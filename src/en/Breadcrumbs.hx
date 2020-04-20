package en;

class Breadcrumbs extends Entity {
  public static var ME : Null<Breadcrumbs> = null;
  static var limit = Const.BREAD_LIMIT;

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

    frict=Const.BREAD_FRICT;
    yr=0.8;
    var fx = (cx+0.5)*Const.GRID;
    var fy = (cy+0.5)*Const.GRID;
    var norm = M.dist(fx, fy, tx, ty);
    dx = (tx-fx)/norm * Const.BREAD_SPEED;
    dy = (ty-fy)/norm * Const.BREAD_SPEED;

    //JSTOLAREK: ustawić właściwą animację
    spr.anim.registerStateAnim("hit", 1, 1, function() { return true; } );
    spr.colorize(0xB00000);
  }
}
