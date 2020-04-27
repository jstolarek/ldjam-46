package en;

class Stone extends Entity {
  static var STONES : Array<Stone> = new Array<Stone>();

  public function new(cx:Int, cy:Int, xr:Float, yr:Float, tx:Float, ty:Float) {
    super(cx,cy);
    this.xr = xr;
    this.yr = yr;
    // HACK: Adjust pivot
    spr.setPivotCoord(3 * 0.5, 3 * 0.5);

    frict = Const.STONE_FRICT;

    var norm = M.dist(xx, yy, tx, ty);
    dx = (tx-xx)/norm * Const.STONE_SPEED;
    dy = (ty-yy)/norm * Const.STONE_SPEED;

    spr.anim.registerStateAnim("stone", 1, 0.1, function() return true );

    STONES.push(this);
    if (STONES.length > Const.MAX_STONES ) {
      var old_stone = STONES.shift();
      old_stone.destroy();
    }
  }

  override function fixedUpdate() {
    super.postUpdate();

    if ( centerX < -Const.GRID / 2 || centerX > (level.wid + 0.5) * Const.GRID
         || centerY < -Const.GRID / 2 || centerY > (level.hei + 0.5) * Const.GRID ) {
      destroy();
    }
  }

    override function onTouch(e:Entity) {
        super.onTouch(e);
        destroy();
    }

    override function hasCircCollWith(e:Entity) {
        if (dx == 0 && dy == 0) return false;
        if (e.is(Pigeon)) return true;
        return false;
    }
}
