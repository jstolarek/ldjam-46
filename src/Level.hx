@:enum
abstract Collision(Int) {
  var NONE  = 0;
  var WALL  = 1;
  var ROCKS = 2;

  public inline function new( v : Int ){
    this = v;
  }

  public inline function getIndex() : Int {
    return this;
  }

  inline public static var LENGTH = 3;
}


class Level extends dn.Process {
    public var game(get,never) : Game; inline function get_game() return Game.ME;

    public var wid(get,never) : Int; inline function get_wid() return Const.LEVEL_WID;
    public var hei(get,never) : Int; inline function get_hei() return Const.LEVEL_HEI;

	var project : ogmo.Project;
	var data : ogmo.Level;

    var collMap : Map<Int,Collision> = new Map();

    public function new() {
        super(Game.ME);
        createRootInLayers(Game.ME.scroller, Const.DP_BG);
		project = new ogmo.Project(hxd.Res.load("map/park.ogmo"), false);
		data = project.getLevelByName("park_level");

        delayer.addF( function() { game.camera.s = 0.006; }, 120);

        // Init collisions
        var l = data.getLayerByName("collisions");
        for(cy in 0...l.cHei)
          for(cx in 0...l.cWid)
            if( l.getIntGrid(cx,cy)>0 )
              setCollision(cx,cy,new Collision(l.getIntGrid(cx,cy)));

        // Render
        for (l in data.layersReversed) {
            switch l.name {
                case "collisions","entities": // nope
                case "front":
                    var e = l.render(root);
                    e.filter = new h2d.filter.Glow(0x0, 0.4, 32, 2, 2, true);
                    case _: l.render(root);
                }
        }
    }

    public inline function isValid(cx,cy) return cx>=0 && cx<wid && cy>=0 && cy<hei;
    public inline function coordId(cx,cy) return cx + cy*wid;


    public inline function setCollision(cx,cy,v) {
      if( isValid(cx,cy) )
        if( v != NONE )
          collMap.set( coordId(cx,cy), v );
        else
          collMap.remove( coordId(cx,cy) );
    }

    public inline function hasWallCollision(cx,cy) {
      return isValid(cx,cy) ? collMap.get(coordId(cx,cy))==WALL : true;
    }

    public inline function hasRockCollision(cx,cy) {
      return isValid(cx,cy) ? collMap.get(coordId(cx,cy))==ROCKS : true;
    }

	public inline function getEntities(id:String) {
		return data.getLayerByName("entities").getEntities(id);
	}
}

