import 'package:flutter/material.dart';

class StyleProvider extends InheritedWidget {
  final AppColors appColors;
  final _AppGradients gradient;
  final shadow = const _AppShadows();
  final _AppBorders border;
  final font = const _AppFonts();

  StyleProvider({
    Widget child,
    @required this.appColors,
  })  : gradient = _AppGradients(appColors),
        border = _AppBorders(appColors),
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
}

class _AppShadows {
  const _AppShadows();

  final mainShadow = const BoxShadow(
    color: const Color.fromRGBO(0, 0, 0, 0.5),
    offset: const Offset(1, 1),
    blurRadius: 10,
  );
}

class _AppBorders {
  final _AppInputBorders input;
  _AppBorders(AppColors colors) : input = _AppInputBorders(colors);
}

class _AppInputBorders {
  final InputBorder primary;
  _AppInputBorders(AppColors colors)
      : primary = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.content,
            width: 1,
          ),
        );
}

class _AppFonts {
  const _AppFonts();

  final primaryNormal = const TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
  final primaryBold = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  final pacificoWhite = const TextStyle(
    color: Colors.white,
    fontFamily: 'pacifico',
    fontSize: 14,
  );
  final pacificoBlack = const TextStyle(
    color: Colors.black,
    fontFamily: 'pacifico',
    fontSize: 14,
  );
}

class _AppGradients {
  LinearGradient primary;

  _AppGradients(AppColors colors)
      : primary = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primaryAccent,
            colors.secondaryBackground,
          ],
        );
}
