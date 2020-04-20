package en;

enum Job {
    Idle;
    Follow(e:Entity);
    Die;
}

class Pigeon extends Entity {
    public static var ALL : Array<Pigeon> = [];

    var job : Job;
    var jobDurationS = .0;
    var target : Null<CPoint>;


    public function new(x,y,xr,yr) {
        super(x,y);
        this.xr = xr;
        this.yr = yr;

        var angWithinDeviation = function(cang:Float, tang:Float, deviation:Float) {
            return cang >= (tang - deviation)
                && cang <= (tang + deviation);
        }

        spr.anim.registerStateAnim("golab-side", 1, 0.4, function() return true );
        spr.anim.registerStateAnim("golab-up", 2, 0.4, function() return angWithinDeviation(M.angTo(0,0,dx,dy), -M.PIHALF, M.PI2 * 0.1));
        spr.anim.registerStateAnim("golab-down", 2, 0.4, function() return angWithinDeviation(M.angTo(0,0,dx,dy), M.PIHALF, M.PI2 * 0.1));
        spr.anim.registerStateAnim("pioorka", 3, 0.4, function() return isOnJob(Die) );
        spr.colorMatrix = dn.Color.getColorizeMatrixH2d( dn.Color.makeColorHsl(rnd(0,1), 0.5, 1), rnd(0,0.3));

        startJob( Follow(hero), 999 );
    }

    public override function update() {
        super.update();

        // if( Game.ME.ca.isKeyboardPressed(hxd.Key.C) ) {
        //     hit();
        // }


        switch (job) {
            case Follow(e):
                if (e.is(Hero)) {
                    if (e.destroyed) {
                        startJob(Idle, 999);
                    } else {
                        setTarget(e.cx,e.cy);
                        if (Breadcrumbs.ME != null) {
                            startJob(Follow(Breadcrumbs.ME), 999);
                        }
                    }
                } else {
                    if (e.destroyed) {
                        startJob(Follow(hero), 999);
                    } else {
                        setTarget(e.cx,e.cy);
                    }
                }
            default:
        }

        var spd = 0.01;
        // Track target
        if( !atTarget() && target!=null ) {
            var a = Math.atan2((target.cy+0.5)-(cy+yr), (target.cx+0.5)-(cx+xr));
            dx += Math.cos(a)*spd;
            dy += Math.sin(a)*spd;
            if (!cd.hasSetS("flipX", 0.5)) {
              dir = Math.cos(a)>=0.2 ? 1 : Math.cos(a)<=-0.2 ? -1 : dir;
              dir *= -1;
            }
        }

        var doingIt = switch( job ) {
            case Idle: true;
            case Follow(e) : true;
            case Die: true;
        }
        if( doingIt ) {
            jobDurationS-=1/Const.FPS;

            if( jobDurationS<=0 )
                onJobComplete();
        }
        #if debug
        if( ui.Console.ME.hasFlag("job") )
            debug(job+"("+doingIt+") "+pretty(jobDurationS)+"s");
        #end
    }

    override function onTouch(e:Entity) {
        super.onTouch(e);

        if (e.is(Hero)) {
            switch (job) {
                case Follow(e):
                    if (e.is(Hero)) {
                        var h = cast(e, Hero);
                        h.hit(Const.PIGEON_STRENGTH);
                        startJob(Idle, rnd(1.2, 2));
                        Assets.sfx.peck().play(false, 0.4);
                    }
                default:
            }
        } else if (e.is(Stone)) {
            Game.ME.addScore();
            startJob(Die, 1);
            // HACK: Adjust for "pioorka" animation, which has bad pivot.
            spr.setPivotCoord(35 * 0.5, 77 * (0.5 + 0.1));
            if (!Game.ME.level.hasWallCollision(cx, cy) && !Game.ME.level.hasRockCollision(cx, cy)) {
                new Blood(cx, cy, xr, yr);
            }
            Assets.sfx.hit().play(false, 0.4);
        }
    }

    override public function dispose() {
        super.dispose();
        ALL.remove(this);
    }

    override function hasCircCollWith(e:Entity) {
        if( isOnJob(Die) ) return false;
        if( e.destroyed ) return false;
        if( e.is(Hero) ) return true;
        if( e.is(Stone) ) return true;
        return false;
    }

    function startJob(j:Job, d:Float) {
        stop();
        job = j;
        jobDurationS = d;
    }

    public inline function isOnJob(k:Job) {
        return job != null && job.getIndex() == k.getIndex();
    }

    function stop() {
        target = null;
    }

    function onJobComplete() {
        switch (job) {
            case Idle:
                if (hero != null && !hero.destroyed) {
                    startJob(Follow(hero), 999);
                } else {
                    startJob(Idle, 999);
                }
            case Follow(e):
                startJob(Idle, 999);
            case Die:
                destroy();
        }
    }

    function setTarget(x, y) {
        if( target == null )
            target = new CPoint(x, y);
        else
            target.set(x, y);
    }

    inline function atTarget() {
        return target==null || cx==target.cx && cy==target.cy;
    }
}
