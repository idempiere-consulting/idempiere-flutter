import 'package:idempiere_app/Screens/app/features/CRM_Product_List/models/product_list_json.dart';

class ProductCheckout {
  final int id;
  final String name;
  int qty;
  final num cost;
  String? imageData;
  String? imageUrl;
  ADPrintColorID? adPrintColorID;
  LitProductSizeID? litProductSizeID;
  String? datePromised;

  ProductCheckout(
      {required this.id,
      required this.name,
      required this.qty,
      required this.cost,
      this.imageData,
      this.imageUrl,
      this.adPrintColorID,
      this.litProductSizeID,
      this.datePromised});
}

/* class ADPrintColorID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADPrintColorID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });
} */


