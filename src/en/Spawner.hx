package en;

class Spawner extends Entity {

    var interv = 5.0;
    var intervMult = 0.95;

    public function new() {
        super(0, 0);
        spr.tile.setSize(0, 0);
    }

    public override function update() {
        if (!cd.hasSetS("spawn", interv)) {
            spawn(5);
            interv *= intervMult;
        }
    }

    function spawn(t : Int) {
      for (i in 1...t) {
        var cx = 0;
        var cy = 0;

        // spawn anywhere on the level
        // do {
        //     cx = Lib.irnd(0, Game.ME.level.wid);
        //     cy = Lib.irnd(0, Game.ME.level.hei);
        // } while (!Game.ME.level.hasCollision(cx, cy));

        // spawn at edges
        var n = Lib.irnd(0, Game.ME.level.wid * 2 + Game.ME.level.hei * 2 + 4);
        if (n < Game.ME.level.wid * 2) {
            var nn = n;
            cx = nn % Game.ME.level.wid;
            cy = nn < Game.ME.level.wid ? -1 : Game.ME.level.hei + 1;
        } else if (n < Game.ME.level.wid * 2 + Game.ME.level.hei * 2) {
            var nn = n - Game.ME.level.wid * 2 + Game.ME.level.hei * 2;
            cx = nn < Game.ME.level.hei ? -1 : Game.ME.level.wid + 1;
            cy = nn % Game.ME.level.hei;
        } else {
            var nn = n - (Game.ME.level.wid * 2 + Game.ME.level.hei * 2);
            switch (nn) {
                case 0: cx = -1;                    cy = -1;
                case 1: cx = Game.ME.level.wid + 1; cy = -1;
                case 2: cx = -1;                    cy = Game.ME.level.hei + 1;
                case 3: cx = Game.ME.level.wid + 1; cy = Game.ME.level.hei + 1;
            }
        }

        // trace("cx: " + cx + ", cy: " + cy);
        new en.Pigeon(cx, cy, Lib.rnd(0,1), Lib.rnd(0,1));
      }
    }

}
