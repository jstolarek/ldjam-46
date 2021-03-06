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
        engine.backgroundColor = 0xff<<24|0x120A11;
        #if (hl)
        Lib.enableFullscreen(s, this, false);
        #if (!debug)
        Lib.toggleFullscreen();
        #end
        #end

        // Resources
        #if (hl && debug)
        hxd.Res.initLocal();
        #else
        hxd.Res.initEmbed();
        #end

        // Deallocate sound when closing the application
        hxd.Window.getInstance().onClose = function () {
          Assets.music.sound.dispose(); return true;
        };

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

        delayer.addF( function() {
            #if !debug
            new Intro();
            #else
            new Game();
            #end
          }, 1);
    }

  public function transition( p:dn.Process, cb:Void->Void, ?color=0x86BB77 ) {
    if( p!=null )
      p.pause();

    var mask = new h2d.Bitmap( h2d.Tile.fromColor(addAlpha(color)), Boot.ME.s2d);
    mask.scaleX = w()/mask.tile.width;
    mask.scaleY = h()/mask.tile.height;

    tw.createMs(mask.alpha, 0>1, 500).end( function() {
        if( p!=null )
          p.destroy();

        delayer.addMs( function() {
            cb();
            tw.createMs(mask.alpha, 0, 1000).end( mask.remove );
            },100);
        });
    }

    override function update() {
        dn.heaps.slib.SpriteLib.TMOD = tmod;
        super.update();
    }
}
