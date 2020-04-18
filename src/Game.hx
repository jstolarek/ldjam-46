import dn.Process;
import hxd.Key;

class Game extends Process {
    public static var ME : Game;

    public var ca : dn.heaps.Controller.ControllerAccess;
    public var fx : Fx;
    public var camera : Camera;
    public var scroller : h2d.Layers;
    public var level : Level;
    public var hud : ui.Hud;

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
        fx = new Fx();
        hud = new ui.Hud();
        // JSTOLAREK: 
        //Assets.sfx.music().play(true, 0.5);

        // JSTOLAREK: wczytywać pozycję bohatera na podstawie pliku ogmo?
        new en.Hero(0,0);
        trace(Lang.t._("Game is ready."));
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

        fx.destroy();
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

            // Restart
            if( ca.selectPressed() )
                Main.ME.startGame();
        }
    }
}

