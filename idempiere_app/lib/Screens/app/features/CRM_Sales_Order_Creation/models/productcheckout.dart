import 'package:idempiere_app/Screens/app/features/CRM_Product_List/models/product_list_json.dart';

class ProductCheckout {
  final int id;
  final String name;
  int qty;
  final num cost;
  String? description;
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
      this.description,
      this.imageData,
      this.imageUrl,
      this.adPrintColorID,
      this.litProductSizeID,
      this.datePromised});
}

class ProductCheckout2 {
  final int id;
  final String name;
  num? lITDefaultQty;
  num? qtyBatchSize;
  double qty;
  num cost;
  num? discountedCost;
  num? tot;
  num? discount;
  String? description;
  String? imageData;
  String? imageUrl;
  ADPrintColorID? adPrintColorID;
  LitProductSizeID? litProductSizeID;
  String? datePromised;
  String? uom;
  int? orderLineID;

  ProductCheckout2(
      {required this.id,
      required this.name,
      required this.qty,
      required this.cost,
      this.discountedCost,
      this.lITDefaultQty,
      this.qtyBatchSize,
      this.tot,
      this.discount,
      this.description,
      this.imageData,
      this.imageUrl,
      this.adPrintColorID,
      this.litProductSizeID,
      this.datePromised,
      this.uom,
      this.orderLineID});
}
