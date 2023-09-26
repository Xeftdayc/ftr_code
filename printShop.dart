import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchCartItems(
    List<DocumentReference> refItems) async {
  final List<Map<String, dynamic>> docItems = [];

  for (final docID in refItems) {
    final snapshot = await docID.get();
    if (snapshot.exists) {
      final itemData = snapshot.data() as Map<String, dynamic>;
      docItems.add(itemData);
    }
  }

  return docItems;
}

Future printShop(
  String? ticket,
  String? user,
  DateTime? date,
  List<DocumentReference> refItems,
  String? texto,
) async {
  // Add your function code here!

  //Margin pdf print
  // Definir el tamaño de página en pulgadas (8.5 x 11 pulgadas para Letter)
  final pageWidthInches = 11;
  final pageHeightInches = 44;

  // Convertir las dimensiones de pulgadas a milímetros (1 pulgada = 25.4 mm)
  final pageWidthMillimeters = pageWidthInches * 25.4;
  final pageHeightMillimeters = pageHeightInches * 25.4;

  // Crear el formato de página personalizado
  final pageFormat = PdfPageFormat(pageWidthMillimeters, pageHeightMillimeters);

  // create a format for printing tickets
  final doc = pw.Document();

  // Fetch cart items
  final cartItems = await fetchCartItems(refItems);

  //final image = await imageFromAssetBundle('assets/images/MaftCore_Final.png');

  doc.addPage(pw.Page(
      pageFormat: pageFormat.copyWith(
          marginTop: 20, marginBottom: 0, marginLeft: 20, marginRight: 20),
      build: (pw.Context context) {
        return pw.Column(
            mainAxisSize: pw.MainAxisSize.max,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                  padding:
                      pw.EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
                  child: pw.Text("TICKET #$ticket",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("$date",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    pw.Text("$user",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 10))
                  ]),
              pw.Divider(thickness: 1),
              pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: pw.Text("Cant.",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 10))),
                    pw.Expanded(
                        flex: 4,
                        child: pw.Text("DESCRIPCION.",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  ]),
              pw.Divider(thickness: 2),
              // list
              for (final item in cartItems)
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text('${item['quantity']}',
                          style: pw.TextStyle(fontSize: 10)),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(item['name'],
                          style: pw.TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
              pw.Divider(thickness: 1),
              pw.Text("$texto", style: pw.TextStyle(fontSize: 10)),
            ]);
      }));

// Print the document
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => doc.save(),
  );
}
