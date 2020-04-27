package ui;

class Hud extends dn.Process {
    public var game(get,never) : Game; inline function get_game() return Game.ME;
    public var level(get,never) : Level; inline function get_level() return Game.ME.level;

    var tf : h2d.Text;
    var full_bar : h2d.Bitmap;
    var breads : Array<h2d.Bitmap>;

    public function new() {
        super(Game.ME);

        createRootInLayers(game.root, Const.DP_UI);

        full_bar  = new h2d.Bitmap(Assets.tiles.getTile("hud-full"), root);
        full_bar.x = 3;
        full_bar.y = 3;

        breads = new Array<h2d.Bitmap>();

        for (i in 0...3) {
            breads[i] = new h2d.Bitmap(Assets.tiles.getTile("bread_icon"), root);
            breads[i].x = 85 + 18*i;
            breads[i].y = 3;
        }

        tf = new h2d.Text(Assets.fontSmall,root);
        tf.x = 5;
        tf.y = 20;
    }

    override function onDispose() {
        super.onDispose();
    }

    override function update() {
        var life = Std.int(Math.ceil((100 - Game.ME.hero.health) * 72 / 100));
        var empty_bar = new h2d.Bitmap(h2d.Tile.fromColor(0x49475B, life, 6), root);
        empty_bar.x = 7+72-life;
        empty_bar.y = 8;

        for (i in en.Breadcrumbs.limit...Const.BREAD_LIMIT) {
            breads[i].visible = false;
        }

        #if (!debug)
        tf.text = "Score: " + Game.ME.score;
        #else
        tf.text = "Score: " + Game.ME.score+ "\nFPS: " + Std.string(pretty(hxd.Timer.fps()));
        #end
    }
}
