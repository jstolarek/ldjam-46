package en;

class Stone extends Entity {
  static var STONES : Array<Stone> = new Array<Stone>();
  var useless = false;

  public function new(cx, cy, tx, ty) {
    super(cx,cy);
    frict=Const.STONE_FRICT;
    yr=0.8;
    var fx = (cx+0.5)*Const.GRID;
    var fy = (cy+0.5)*Const.GRID;
    var norm = M.dist(fx, fy, tx, ty);
    dx = (tx-fx)/norm * Const.STONE_SPEED;
    dy = (ty-fy)/norm * Const.STONE_SPEED;

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
        useless = true;
    }

    override function hasCircCollWith(e:Entity) {
        if (dx == 0 && dy == 0 || useless) return false;
        if (e.is(Pigeon)) return true;
        return false;
    }
}
