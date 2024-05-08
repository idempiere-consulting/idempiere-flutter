class POSTableRowJSON {
  String? rowType;
  int? number;
  String? productCode;
  String? productName;
  int? productId;
  int? qty;
  double? price;
  double? discount;
  double? discountedPrice;
  double? tot;

  POSTableRowJSON({
    this.rowType,
    this.number,
    this.productCode,
    this.productName,
    this.productId,
    this.qty,
    this.price,
    this.discount,
    this.discountedPrice,
    this.tot,
  });

  POSTableRowJSON.fromJson(Map<String, dynamic> json)
      : number = json['number'] as int?,
        rowType = json['rowType'] as String?,
        productCode = json['productCode'] as String?,
        productName = json['productName'] as String?,
        productId = json['productId'] as int?,
        qty = json['qty'] as int?,
        price = json['price'] as double?,
        discount = json['discount'] as double?,
        discountedPrice = json['discountedPrice'] as double?,
        tot = json['tot'] as double?;

  Map<String, dynamic> toJson() => {
        'number': number,
        'rowType': rowType,
        'productCode': productCode,
        'productName': productName,
        'productId': productId,
        'qty': qty,
        'price': price,
        'discount': discount,
        'discountedPrice': discountedPrice,
        'tot': tot,
      };
}
