import dn.heaps.slib.*;

class Assets {
    public static var sfx = dn.heaps.assets.SfxDirectory.load("sfx");
    public static var fontPixel : h2d.Font;
    public static var fontTiny : h2d.Font;
    public static var fontSmall : h2d.Font;
    public static var fontMedium : h2d.Font;
    public static var fontLarge : h2d.Font;
    public static var tiles : SpriteLib;

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
        tiles.defineAnim("hero-idle", "0-9");
        tiles.defineAnim("hero-walk-diagonal-down-right", "0-6");
        tiles.defineAnim("hero-walk-diagonal-top-right", "0-6");
        tiles.defineAnim("hero-walk-down", "0-6");
        tiles.defineAnim("hero-walk-right", "0-6");
        tiles.defineAnim("hero-walk-up", "0-6");
        tiles.defineAnim("skull", "0-59");
        tiles.defineAnim("slighshot", "0-59");
        tiles.defineAnim("golab-down", "0-5");
        tiles.defineAnim("golab-side", "0-8");
        tiles.defineAnim("golab-up", "0-5");
        tiles.defineAnim("title", "0(120), 1-16(5)");
        tiles.defineAnim("stone", "0");
        tiles.defineAnim("cursor", "0");
    }
}
