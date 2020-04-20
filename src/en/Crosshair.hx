package en;

class Crosshair extends Entity {

    public function new(hero : Hero, tx : Int, ty :  Int){
      super(hero.cx, hero.cy);
      setCords(hero,tx,ty);
      spr.anim.registerStateAnim("cursor", 1, 0.1, function() return true );
    }

    public function setCords( hero : Hero, tx : Int, ty : Int) {
      var norm = M.dist(hero.centerX, hero.centerY, tx, ty);
      var x = ((tx-hero.centerX)/norm * Const.AIM_RADIUS);
      var y = ((ty-hero.centerY)/norm * Const.AIM_RADIUS);
      setPosPixel(hero.centerX+x,hero.centerY+y+Const.GRID/2);
    }
}