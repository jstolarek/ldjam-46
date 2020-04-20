package en;

enum Job {
    Idle;
    Follow(e:Hero);
    Die;
}

class Pigeon extends Entity {
    public static var ALL : Array<Pigeon> = [];

    var job : Job;
    var jobDurationS = .0;
    var target : Null<CPoint>;


    public function new(x,y) {
        super(x,y);
        ALL.push(this);

        spr.anim.registerStateAnim("golab-side", 1, 0.4, function() return true );
        spr.anim.registerStateAnim("hit", 2, 0.4, function() return isOnJob(Die) );
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
                if (e.destroyed) {
                    startJob(Idle, 999);
                } else {
                    setTarget(e.cx,e.cy);
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
                    e.hit(Const.PIGEON_STRENGTH);
                    startJob(Idle, rnd(1.2, 2));
                    Assets.sfx.peck().play(false, 0.4);
                default:
            }
        } else if (e.is(Stone)) {
            Game.ME.addScore();
            startJob(Die, 1);
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
