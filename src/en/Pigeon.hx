package en;

enum Job {
    Idle;
    Follow(e:Hero);
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
        spr.colorMatrix = dn.Color.getColorizeMatrixH2d( dn.Color.makeColorHsl(rnd(0,1), 0.5, 1), rnd(0,0.3));

        startJob( Follow(hero), 999 );
    }

    public function hit() {
        destroy();
    }

    public override function update() {
        super.update();

        switch (job) {
            case Idle:
            case Follow(e):
                if (e.destroyed) {
                    startJob(Idle, 999);
                } else {
                    setTarget(e.cx,e.cy);
                }
        }

        var spd = 0.01;
        // Track target
        if( !atTarget() && target!=null ) {
            var a = Math.atan2((target.cy+0.5)-(cy+yr), (target.cx+0.5)-(cx+xr));
            dx += Math.cos(a)*spd;
            dy += Math.sin(a)*spd;
            dir = Math.cos(a)>=0.1 ? 1 : Math.cos(a)<=-0.1 ? -1 : dir;
            dir *= -1;
        }

        var doingIt = switch( job ) {
            case Idle: true;
            case Follow(e) : true;
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

        switch (job) {
            case Follow(e):
                e.hit(10);
                startJob(Idle, rnd(1.2, 2));
            default:
        }
    }

    override public function dispose() {
        super.dispose();
        ALL.remove(this);
    }

    override function hasCircCollWith(e:Entity) {
        if( e.destroyed ) return false;
        if( e.is(Hero) ) return true;
        return false;
    }

    function startJob(j:Job, d:Float) {
        stop();
        job = j;
        jobDurationS = d;
    }

    function stop() {
        target = null;
    }

    function onJobComplete() {
        if (hero != null && !hero.destroyed) {
            startJob(Follow(hero), 999);
        } else {
            startJob(Idle, 999);
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
