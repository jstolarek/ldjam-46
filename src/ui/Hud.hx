package ui;

class Hud extends dn.Process {
    public var game(get,never) : Game; inline function get_game() return Game.ME;
    public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;
    public var level(get,never) : Level; inline function get_level() return Game.ME.level;

    var flow : h2d.Flow;
    var invalidated = true;

    public function new() {
        super(Game.ME);

        createRootInLayers(game.root, Const.DP_UI);

        flow = new h2d.Flow(root);
		var tf = new h2d.Text(Assets.fontSmall,root);
		tf.x = 5;
		tf.y = 1;
		createChildProcess(function(_) {
			if( itime%5==0 )
              tf.text = "Health: "+ Game.ME.hero.health + " / FPS: " + Std.string(pretty(hxd.Timer.fps())) + "\n" +
                "Mouse X: " + Game.ME.mouse.x + ", mouse Y: " + Game.ME.mouse.y;
		});
    }

    override function onDispose() {
        super.onDispose();
    }

    public inline function invalidate() invalidated = true;

    function render() {}

    override function postUpdate() {
        super.postUpdate();

        if( invalidated ) {
            invalidated = false;
            render();
        }
    }
}
