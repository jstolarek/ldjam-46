import dn.Process;
import hxd.Key;

class Game extends Process {
    public static var ME : Game;

    public var ca : dn.heaps.Controller.ControllerAccess;
    public var camera : Camera;
    public var scroller : h2d.Layers;
    public var level : Level;
    public var hud : ui.Hud;
	var camFocuses : Map<String,CPoint> = new Map();
	public var hero : en.Hero;
    public var pigeon : en.Pigeon;
    var mouseTrap : h2d.Interactive;
    public var mouse : { x:Int, y:Int }

    public function new() {
        super(Main.ME);
        ME = this;
        ca = Main.ME.controller.createAccess("game");
        ca.setLeftDeadZone(0.2);
        ca.setRightDeadZone(0.2);
        createRootInLayers(Main.ME.root, Const.DP_BG);

        scroller = new h2d.Layers();
        root.add(scroller, Const.DP_BG);

        camera = new Camera();
        level = new Level();
        hud = new ui.Hud();
        #if (!debug)
        Assets.sfx.music().play(true, 0.5);
        #end

		var oe = level.getEntities("hero")[0];
        hero = new en.Hero(oe.cx, oe.cy);
        pigeon = new en.Pigeon(5,5);

        hero.setPosCase(oe.cx, oe.cy);
		for(oe in level.getEntities("camFocus")) {
			camFocuses.set(oe.getStr("id"), new CPoint(oe.cx,oe.cy));
        }
		setCameraFocus("main");

        mouseTrap = new h2d.Interactive(w(),h(),Main.ME.root);
        mouseTrap.onMove  = onMouseMove;
        mouseTrap.onClick = onMouseClick;
        mouse = {x : 0, y : 0};
        mouseTrap.cursor = Custom(new hxd.Cursor.CustomCursor([Assets.cursorBitmap],10,0,0));
    }

	override public function onResize() {
        super.onResize();
		mouseTrap.width = w();
		mouseTrap.height = h();
	}

	function onMouseMove(ev:hxd.Event) {
		var m = getMouse();
        mouse.x = m.x;
        mouse.y = m.y;
	}

    function onMouseClick(ev:hxd.Event) {
		var m = getMouse();
        new en.Stone(hero.cx, hero.cy, mouse.x, mouse.y);
    }

	function setCameraFocus(id:String) {
		var pt = camFocuses.get(id);
		if( pt==null ) {
			if( id=="main" ) {
				camera.target = hero;
			} else
				setCameraFocus("main");
		}
		else {
			camera.setPosition(pt.footX, pt.footY);
		}

	}


    public function onCdbReload() {
    }


    function gc() {
        if( Entity.GC==null || Entity.GC.length==0 )
            return;

        for(e in Entity.GC)
            e.dispose();
        Entity.GC = [];
    }

    override function onDispose() {
        super.onDispose();
        Assets.sfx.music().stop();

        mouseTrap.remove();
        for(e in Entity.ALL)
            e.destroy();
        gc();
    }

    override function preUpdate() {
        super.preUpdate();

        for(e in Entity.ALL) if( !e.destroyed ) e.preUpdate();
    }

    override function postUpdate() {
        super.postUpdate();

        for(e in Entity.ALL) if( !e.destroyed ) e.postUpdate();
        gc();
    }

    override function fixedUpdate() {
        super.fixedUpdate();

        for(e in Entity.ALL) if( !e.destroyed ) e.fixedUpdate();
    }

    override function update() {
        super.update();

        for(e in Entity.ALL) if( !e.destroyed ) e.update();

        if( !ui.Console.ME.isActive() && !ui.Modal.hasAny() ) {
            #if hl
            // Exit
            if( ca.isKeyboardPressed(Key.ESCAPE) )
                if( !cd.hasSetS("exitWarn",3) )
                    trace(Lang.t._("Press ESCAPE again to exit."));
                else
                    hxd.System.exit();
            #end
        }
    }

	public function getMouse() {
		var gx = hxd.Window.getInstance().mouseX;
		var gy = hxd.Window.getInstance().mouseY;
		var x = Std.int( gx/Const.SCALE-scroller.x );
		var y = Std.int( gy/Const.SCALE-scroller.y );
		return {
			x : x,
			y : y,
			cx : Std.int(x/Const.GRID),
			cy : Std.int(y/Const.GRID),
		}
	}
}

