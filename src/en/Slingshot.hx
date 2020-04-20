package en;

class Slingshot extends Entity {
    var realPos : { x : Int, y : Int };
    var OFFSET = { x : 0, y : 0 };
    var followedHero : en.Hero;
    // moze potem dodaj direct

    public function new(x, y){
        realPos = {x : x + OFFSET.x, y : x + OFFSET.y};
        super(realPos.x, realPos.y);

        //setPosCase(realPos.x, y + realPos.y);

        // najpierw pokaz jedna klatke i jak masz "czy strzela" to dawaj
        spr.anim.registerStateAnim("slighshot", 1, 0.1, function() return true );
    }

    public function setHero(h){
        followedHero = h;
    }

    public function updatePosition(){
        dx = followedHero.dx * 1.7;
        dy = followedHero.dy * 1.7;
    }

    public override function update() {
        super.update();
        updatePosition();
        //setPosCase(Std.int(followedHero.xr) + OFFSET.x, Std.int(followedHero.yr) + OFFSET.y);

    }
}