import 'package:flutter/material.dart';
import 'package:targowisko/models/rating_model.dart';
import 'package:targowisko/utils/style_provider.dart';
import 'package:targowisko/widgets/list_item/list_item.dart';
import 'package:targowisko/widgets/list_scaffold.dart';

class RatingsScreen extends StatefulWidget {
  final List<RatingModel> ratings;

  RatingsScreen({@required this.ratings});

  @override
  RatingsScreenState createState() => RatingsScreenState();
}

class RatingsScreenState extends State<RatingsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.ratings.length);
    return ListScaffold(
      title: "Oceny",
      child: widget.ratings.isEmpty
          ? Center(
              child: Text(
                "Brak ocen",
                style: StyleProvider.of(context)
                    .font
                    .pacifico
                    .copyWith(fontSize: 20, color: Colors.black38),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              itemCount: widget.ratings.length,
              itemBuilder: (BuildContext context, int index) {
                final rating = widget.ratings[index];
                return Container(
                  child: ListItem(
                    withDescription: false,
                    title: rating.comment,
                    averageRating: rating.rating.toDouble(),
                    child: Container(),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 1,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    gradient: StyleProvider.of(context).gradient.cardGradient2,
                  ),
                );
              },
            ),
    );
  }
}
