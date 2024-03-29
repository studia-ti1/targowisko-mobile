import 'package:flutter/material.dart';

class StyleProvider extends InheritedWidget {
  final AppColors colors;
  final _AppAssets asset;
  final _AppGradients gradient;
  final shadow = const _AppShadows();
  final _AppBorders border;
  final _AppFonts font;

  StyleProvider({
    Widget child,
    @required this.colors,
  })  : gradient = _AppGradients(colors),
        border = _AppBorders(colors),
        asset = _AppAssets(),
        font = _AppFonts(colors),
        super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static StyleProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(StyleProvider) as StyleProvider;
  }
}

class AppColors {
  const AppColors({
    @required this.primaryAccent,
    @required this.primaryContent,
    @required this.secondaryAccent,
    @required this.secondaryContent,
    @required this.primaryBackground,
    @required this.secondaryBackground,
    @required this.content,
  });

  final Color primaryAccent;
  final Color secondaryAccent;

  final Color primaryContent;
  final Color secondaryContent;
  final Color content;

  final Color primaryBackground;
  final Color secondaryBackground;

  final Color coin = const Color(0xFFEF8C17);
  final facebook = const Color(0xFF1B76F3);
  final searchBackground = const Color(0xFFEEEEEE);
}

class _AppShadows {
  const _AppShadows();

  final mainShadow = const BoxShadow(
    color: const Color.fromRGBO(0, 0, 0, 0.25),
    offset: const Offset(1, 1),
    blurRadius: 10,
  );

  final lightShadow = const BoxShadow(
    color: const Color.fromRGBO(0, 0, 0, 0.05),
    offset: const Offset(0, 0),
    blurRadius: 5,
  );
}

class _AppBorders {
  final _AppInputBorders input;
  final _AppBoxBorders box;
  _AppBorders(AppColors colors)
      : input = _AppInputBorders(colors),
        box = _AppBoxBorders(colors);
}

class _AppInputBorders {
  final InputBorder primary;
  final InputBorder noBorder;
  _AppInputBorders(AppColors colors)
      : primary = OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.content,
            width: 1,
          ),
        ),
        noBorder = OutlineInputBorder(borderSide: BorderSide.none);
}

class _AppBoxBorders {
  final BoxBorder primary;
  _AppBoxBorders(AppColors colors)
      : primary = Border.all(
          color: colors.content,
          width: 1,
        );
}

class _AppFonts {
  final TextStyle primaryNormal;
  final TextStyle secondaryNormal;
  final TextStyle normal;
  final TextStyle primaryBold;
  final TextStyle secondaryBold;
  final TextStyle bold;

  final TextStyle pacificoPrimary;
  final TextStyle pacificoSecondary;
  final TextStyle pacifico;

  _AppFonts(AppColors colors)
      : primaryNormal = TextStyle(
          color: colors.primaryContent,
          fontSize: 14,
        ),
        secondaryNormal = TextStyle(
          color: colors.secondaryContent,
          fontSize: 14,
        ),
        normal = TextStyle(
          color: colors.content,
          fontSize: 14,
        ),
        primaryBold = TextStyle(
          color: colors.primaryContent,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        secondaryBold = TextStyle(
          color: colors.secondaryContent,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        bold = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        pacificoPrimary = TextStyle(
          color: colors.primaryContent,
          fontFamily: 'pacifico',
          fontSize: 14,
        ),
        pacificoSecondary = TextStyle(
          color: colors.secondaryContent,
          fontFamily: 'pacifico',
          fontSize: 14,
        ),
        pacifico = TextStyle(
          color: colors.content,
          fontFamily: 'pacifico',
          fontSize: 14,
        );
}

class _AppGradients {
  LinearGradient primary;
  LinearGradient cardGradient2;
  LinearGradient cardGradient3;

  _AppGradients(AppColors colors)
      : primary = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primaryAccent,
            colors.secondaryBackground,
          ],
        ),
        cardGradient2 = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primaryAccent, colors.secondaryAccent],
        ),
        cardGradient3 = const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFF82A5D5),
            Color(0xFF6AC0D3),
          ],
        );
}

class _AppAssets {
  final facebookLogo = 'assets/svg/facebook.svg';
  final appLogo = 'assets/logo.png';
  final marketDefaultBackground = 'assets/market_placeholder.jpg';
  final marketIcon = 'assets/market_icon.png';
  final productIcon = 'assets/product_icon.png';
  final sellerIcon = 'assets/seller_icon.png';
  final user = 'assets/user.png';
  final coin = 'assets/coin.png';
  final spinner = 'assets/food_spinner.gif';
}

class CategoriesAssets {
  CategoriesAssets._();

  static const animals = 'assets/animals.jpg';
  static const antiques = 'assets/antiques.jpg';
  static const automotive = 'assets/automotive.jpg';
  static const food = 'assets/food.jpg';
  static const fruits = 'assets/fruits.jpg';
  static const realEstate = 'assets/real_estate.jpg';
  static const vegetables = 'assets/vegetables.jpg';
  static const electronics = 'assets/electronics.jpg';
  static const clothing = 'assets/clothing.jpg';
  static const cosmetics = 'assets/cosmetics.jpg';
  static const other = 'assets/other.jpg';
}
