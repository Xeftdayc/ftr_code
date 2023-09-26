// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateQtyItems(List<DocumentReference> refItems) async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  for (final refItem in refItems) {
    final cartItemSnapshot = await refItem.get();

    if (cartItemSnapshot.exists) {
      final cartItemData = cartItemSnapshot.data() as Map<String, dynamic>;
      final refItem = cartItemData['refItem'] as DocumentReference;
      final quantity = cartItemData['quantity'] as int;

      final itemSnapshot = await refItem.get();

      if (itemSnapshot.exists) {
        final itemData = itemSnapshot.data() as Map<String, dynamic>;
        final currentQuantity = itemData['quantity'] as int;
        final newQuantity = currentQuantity - quantity;

        batch.update(refItem, {'quantity': newQuantity});
      }
    }
  }

  await batch.commit();
}
