import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_shopping/shopping_item.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem shoppingItem;
  final Animation<double> animation;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final GestureLongPressStartCallback onLongPressStart;

  const ShoppingItemTile({
    super.key,
    required this.shoppingItem,
    required this.animation,
    required this.onTap,
    required this.onLongPress,
    required this.onLongPressStart,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.MMMEd().format(shoppingItem.addedAt);

    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: FadeTransition(
        opacity: animation,
        child: Listener(
          onPointerDown: (_) {},
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            onLongPressStart: onLongPressStart,
            child: Center(
              child: Container(
                width: 500,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.fromLTRB(10, 15 / 2, 10, 15 / 2),
                decoration: ShapeDecoration(
                  color: shoppingItem.isChecked
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context).colorScheme.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Transform.translate(
                        offset: const Offset(0, 4),
                        child: Center(
                          child: Text(
                            shoppingItem.emoji,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: 'Segoe UI',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shoppingItem.itemName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                decoration: shoppingItem.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontFamily: "Manrope",
                                fontSize: 15,
                                fontWeight: shoppingItem.isChecked
                                    ? FontWeight.w200
                                    : FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Added: $formattedDate",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 12,
                                  decoration: shoppingItem.isChecked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontFamily: 'Manrope',
                                  fontWeight: shoppingItem.isChecked
                                      ? FontWeight.w200
                                      : FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                shoppingItem.quantity == null
                                    ? ''
                                    : '${shoppingItem.quantity}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 12,
                                  decoration: shoppingItem.isChecked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontFamily: 'Manrope',
                                  fontWeight: shoppingItem.isChecked
                                      ? FontWeight.w200
                                      : FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.3,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.50, color: Color(0xFF1E1E1E)),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        side: WidgetStateBorderSide.resolveWith(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.secondary);
                            }
                            return const BorderSide(
                                width: 1, color: Colors.black);
                          },
                        ),
                        value: shoppingItem.isChecked,
                        onChanged: (value) => onTap(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
