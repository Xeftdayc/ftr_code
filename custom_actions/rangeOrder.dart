import 'package:flutter/material.dart';

Future<List<OrderRecord>?> rangeOrder(
  List<OrderRecord> itemList,
  DateTime startDate,
  DateTime endDate,
) async {
  // Create a List to store the filtered items
  List<OrderRecord> filteredList = [];

  // Iterate through orderList
  for (OrderRecord item in itemList) {
    // Assuming 'refBusiness' is a field in the 'OrderRecord' object
    //DocumentReference<Object?>? itemRefBusiness = item.refBusiness;

    // Check if the 'refBusiness' of the item matches the provided 'refBusiness',
    // 'isDisabled' is equal to the 'disabled' parameter,
    DateTime? itemCreatedAt = item.created.createdAt;
    //bool isDisabled = item.isDisabled;

    // Check if the 'createdAt' of the item is within the specified range
    if (itemCreatedAt != null &&
        itemCreatedAt.isAfter(startDate) &&
        itemCreatedAt.isBefore(endDate)) {
      // Add the item to the filteredList
      filteredList.add(item);
    }
  }

  return filteredList;
}
