import dn.heaps.slib.*;

class Assets {
    public static var sfx = dn.heaps.assets.SfxDirectory.load("sfx");
    public static var fontPixel : h2d.Font;
    public static var fontTiny : h2d.Font;
    public static var fontSmall : h2d.Font;
    public static var fontMedium : h2d.Font;
    public static var fontLarge : h2d.Font;
    public static var tiles : SpriteLib;
    public static var game : SpriteLib;

    static var initDone = false;
    public static function init() {
        if( initDone )
            return;
        initDone = true;

        fontPixel = hxd.Res.fonts.minecraftiaOutline.toFont();
        fontTiny = hxd.Res.fonts.barlow_condensed_medium_regular_9.toFont();
        fontSmall = hxd.Res.fonts.barlow_condensed_medium_regular_11.toFont();
        fontMedium = hxd.Res.fonts.barlow_condensed_medium_regular_17.toFont();
        fontLarge = hxd.Res.fonts.barlow_condensed_medium_regular_32.toFont();
        tiles = dn.heaps.assets.Atlas.load("atlas/tiles.atlas");
        game = dn.heaps.assets.Atlas.load("atlas/game.atlas");
        game.defineAnim("hero-idle", "0-9");
        game.defineAnim("hero-walk-diagonal-down-right", "0-6");
        game.defineAnim("hero-walk-diagonal-top-right", "0-6");
        game.defineAnim("hero-walk-down", "0-6");
        game.defineAnim("hero-walk-right", "0-6");
        game.defineAnim("hero-walk-up", "0-6");
        game.defineAnim("skull", "0-59");

    }
}
