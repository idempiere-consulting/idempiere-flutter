class PriceListTableRowJSON {
  int? number;
  String? productName;
  int? productId;
  int? qty;
  double? price;
  double? tot;

  PriceListTableRowJSON({
    this.number,
    this.productName,
    this.productId,
    this.qty,
    this.price,
    this.tot,
  });

  PriceListTableRowJSON.fromJson(Map<String, dynamic> json)
      : number = json['number'] as int?,
        productName = json['productName'] as String?,
        productId = json['productId'] as int?,
        qty = json['qty'] as int?,
        price = json['price'] as double?,
        tot = json['tot'] as double?;

  Map<String, dynamic> toJson() => {
        'number': number,
        'productName': productName,
        'productId': productId,
        'qty': qty,
        'price': price,
        'tot': tot,
      };
}
