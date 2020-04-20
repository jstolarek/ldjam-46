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
    public var crosshair : en.Crosshair;
    public var spawner : en.Spawner;
    #if (slingshot)
    public var slingshot : en.Slingshot;
    #end
    var mouseTrap : h2d.Interactive;
    public var mouse : { x:Int, y:Int }
    public var score : Int;

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
        Assets.music.play(true, 0.5);
        #end

		var oe = level.getEntities("hero")[0];
        hero = new en.Hero(oe.cx, oe.cy);
        #if (slingshot)
        slingshot = new en.Slingshot(Std.int(hero.xr), Std.int(hero.yr));
        slingshot.setHero(hero);
        #end
        score = 0;
        spawner = new en.Spawner();

        hero.setPosCase(oe.cx, oe.cy);

        #if (slingshot)
        slingshot.setPosCase(oe.cx, oe.cy);
        #end
		for(oe in level.getEntities("camFocus")) {
			camFocuses.set(oe.getStr("id"), new CPoint(oe.cx,oe.cy));
        }
		setCameraFocus("main");

        mouseTrap = new h2d.Interactive(w(),h(),Main.ME.root);
        mouseTrap.onMove  = onMouseMove;
        mouseTrap.onClick = onMouseClick;
        var m = getMouse();
        mouse = {x : m.x, y : m.y};
        mouseTrap.cursor = Custom(new hxd.Cursor.CustomCursor([Assets.cursorBitmap],10,0,0));

        //JSTOLAREK: FIXME
        //crosshair = new en.Crosshair(hero,mouse.x, mouse.y);
    }

	override public function onResize() {
        super.onResize();
		mouseTrap.width = w();
		mouseTrap.height = h();
	}

    public function addScore() {
      score += Const.PIGEON_SCORE;
    }

	function onMouseMove(ev:hxd.Event) {
		var m = getMouse();
        mouse.x = m.x;
        mouse.y = m.y;
	}

    function onMouseClick(ev:hxd.Event) {
      var m = getMouse();
      //TODO(JSTOLAREK): ustawić lewy i prawy przycisk poprawnie
      if (ev.button == 1) {
        if (!cd.hasSetMs("stone", Const.STONE_COOLDOWN)) {
          new en.Stone(hero.cx, hero.cy, mouse.x, mouse.y);
        }
      } else if (ev.button == 0) {
        en.Breadcrumbs.throwBread(hero.cx, hero.cy, mouse.x, mouse.y);
      }
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
        Assets.music.stop();

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
        // JSTOLAREK: fixme
        // crosshair.setCords(hero,mouse.x,mouse.y);

        for(e in Entity.ALL) if( !e.destroyed ) e.update();
        if( !ui.Console.ME.isActive() && !ui.Modal.hasAny() ) {
            #if hl
            // Exit
            if( ca.isKeyboardPressed(Key.ESCAPE) )
                if( !cd.hasSetS("exitWarn",1.5) ) {
                  var tf = new h2d.Text(Assets.fontTiny, root);
                  tf.text = "Press ESCAPE again to quit";
                  tf.x = Const.AUTO_SCALE_TARGET_WID*0.475 - tf.textWidth*tf.scaleX*0.5;
                  tf.y = Const.AUTO_SCALE_TARGET_HEI*0.4;
                  tw.createMs(tf.alpha, 50|0>1, 50);
                  delayer.addF( function() { tw.createMs(tf.alpha, 50|1>0, 50);}, 90 );
                } else {
                    hxd.System.exit();
                }
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
