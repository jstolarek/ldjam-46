class Level extends dn.Process {
    public var game(get,never) : Game; inline function get_game() return Game.ME;
    public var fx(get,never) : Fx; inline function get_fx() return Game.ME.fx;

    public var wid(get,never) : Int; inline function get_wid() return 16;
    public var hei(get,never) : Int; inline function get_hei() return 16;

	var project : ogmo.Project;
	var data : ogmo.Level;

    var invalidated = true;

    public function new() {
        super(Game.ME);
        createRootInLayers(Game.ME.scroller, Const.DP_BG);
		project = new ogmo.Project(hxd.Res.load("map/park.ogmo"), false);
		data = project.getLevelByName("park");

        //JSTOLAREK: load collision map here if we want to support collisions
    }

    public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
    public inline function coordId(cx,cy) return cx + cy*wid;


    public function render() {
        // Debug level render

      for(l in data.layersReversed)
        switch l.name {
            case "collisions","entities": // nope
            case "front":
              var e = l.render(root);
              e.filter = new h2d.filter.Glow(0x0, 0.4, 32, 2, 2, true);
              case _: l.render(root);
          }
    }

    override function postUpdate() {
        super.postUpdate();

        if( invalidated ) {
            invalidated = false;
            render();
        }
    }
}