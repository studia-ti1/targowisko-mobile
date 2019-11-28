import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:targowisko/models/product_model.dart';
import 'package:targowisko/utils/style_provider.dart';

class SelectCateogryWidget extends StatefulWidget {
  final ValueChanged<ProductCategory> onChange;
  final VoidCallback onRemove;
  final ProductCategory selected;

  SelectCateogryWidget({
    @required this.onChange,
    @required this.onRemove,
    @required this.selected,
  });

  @override
  _SelectCateogryWidgetState createState() => _SelectCateogryWidgetState();
}

class _SelectCateogryWidgetState extends State<SelectCateogryWidget>
    with SingleTickerProviderStateMixin {
  bool get _hasCategory => widget.selected != null;

  final GlobalKey _keyRed = GlobalKey();

  Size get animatedSizeSize {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    return sizeRed;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: AnimatedSize(
        key: _keyRed,
        alignment: Alignment.center,
        vsync: this,
        duration: const Duration(milliseconds: 200),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 0),
          child: _hasCategory
              ? _AnimatedCategory(
                  delay: const Duration(milliseconds: 0),
                  initialHeight: animatedSizeSize.height,
                  onRemove: widget.onRemove,
                  selected: widget.selected,
                )
              : GridView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final category = ProductCategory.allCategories[index];
                    return _CategoryCard(
                      category: category,
                      onTap: () => widget.onChange(category),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: ProductCategory.allCategories.length,
                ),
        ),
      ),
    );
  }
}

class _AnimatedCategory extends StatefulWidget {
  const _AnimatedCategory({
    Key key,
    @required this.onRemove,
    @required this.selected,
    @required this.initialHeight,
    @required this.delay,
  }) : super(key: key);

  final VoidCallback onRemove;
  final ProductCategory selected;
  final double initialHeight;
  final Duration delay;

  @override
  __AnimatedCategoryState createState() => __AnimatedCategoryState();
}

class __AnimatedCategoryState extends State<_AnimatedCategory>
    with SingleTickerProviderStateMixin {
  double initialHeight;
  AnimationController _controller;

  @override
  void initState() {
    initialHeight = widget.initialHeight;
    _controller = AnimationController(vsync: this, value: 1);

    super.initState();
    _beginAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _beginAnimation() async {
    await Future<void>.delayed(widget.delay);

    if (!mounted) return;

    return await _controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: _CategoryCard(
        gradient: false,
        alignment: Alignment.center,
        category: widget.selected,
        onTap: widget.onRemove,
      ),
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: _controller
              .drive(CurveTween(curve: Curves.easeOut))
              .drive(Tween(begin: 50.0, end: initialHeight))
              .value,
          child: child,
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    Key key,
    @required this.category,
    @required this.onTap,
    this.alignment,
    this.gradient = true,
  }) : super(key: key);

  final ProductCategory category;
  final VoidCallback onTap;
  final Alignment alignment;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: [StyleProvider.of(context).shadow.mainShadow],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                constraints: BoxConstraints.expand(),
                padding: const EdgeInsets.all(5),
                alignment: alignment ?? Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: StyleProvider.of(context).colors.secondaryAccent,
                  image: category != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(category.assetName),
                        )
                      : null,
                ),
              ),
            ),
            if (category != null)
              Container(
                padding: const EdgeInsets.all(5),
                alignment: alignment ?? Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: gradient
                      ? const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.black12],
                        )
                      : null,
                  color: Colors.black45,
                ),
                child: AutoSizeText(
                  category.name,
                  style: StyleProvider.of(context)
                      .font
                      .pacificoPrimary
                      .copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
