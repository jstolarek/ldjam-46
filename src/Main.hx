import Data;
import hxd.Key;

class Main extends dn.Process {
    public static var ME : Main;
    public var controller : dn.heaps.Controller;
    public var ca : dn.heaps.Controller.ControllerAccess;

    public function new(s:h2d.Scene) {
        super();
        ME = this;

        createRoot(s);
        root.filter = new h2d.filter.ColorMatrix(); // force rendering for pixel perfect

        // Engine settings
        hxd.Timer.wantedFPS = Const.FPS;
        engine.backgroundColor = 0xff<<24|0x111133;
        Lib.enableFullscreen(s, this, false);
        Lib.toggleFullscreen();

        // Resources
        #if(hl && debug)
        hxd.Res.initLocal();
        #else
        hxd.Res.initEmbed();
        #end

        // Hot reloading
        #if debug
        hxd.res.Resource.LIVE_UPDATE = true;
        hxd.Res.data.watch(function() {
            delayer.cancelById("cdb");

            delayer.addS("cdb", function() {
                Data.load( hxd.Res.data.entry.getBytes().toString() );
                if( Game.ME!=null )
                    Game.ME.onCdbReload();
            }, 0.2);
        });
        #end

        // Assets & data init
        Lang.init("en");
        Assets.init();
        Data.load( hxd.Res.data.entry.getText() );

        // Console
        new ui.Console(Assets.fontTiny, s);

        // Game controller
        controller = new dn.heaps.Controller(s);
        controller.bind(DPAD_LEFT, Key.LEFT, Key.A);
        controller.bind(DPAD_RIGHT, Key.RIGHT, Key.D);
        controller.bind(DPAD_UP, Key.UP, Key.W);
        controller.bind(DPAD_DOWN, Key.DOWN, Key.S);
        controller.bind(A, Key.Z);
        controller.bind(B, Key.X);
        controller.bind(SELECT, Key.R);
        controller.bind(START, Key.N);
        ca = controller.createAccess("main");

        // Start
        new dn.heaps.GameFocusHelper(Boot.ME.s2d, Assets.fontMedium);
        delayer.addF( startGame, 1 );
    }

    public function startGame() {
        if( Game.ME!=null ) {
            Game.ME.destroy();
            delayer.addF(function() {
                new Game();
            }, 1);
        }
        else
            new Game();
    }

    override public function onResize() {
        super.onResize();

        // Auto scaling
        if( Const.AUTO_SCALE_TARGET_WID>0 )
            Const.SCALE = M.ceil( h()/Const.AUTO_SCALE_TARGET_WID );
        else if( Const.AUTO_SCALE_TARGET_HEI>0 )
            Const.SCALE = M.ceil( h()/Const.AUTO_SCALE_TARGET_HEI );
        root.setScale(Const.SCALE);
    }

    override function update() {
        dn.heaps.slib.SpriteLib.TMOD = tmod;
        super.update();
    }
}