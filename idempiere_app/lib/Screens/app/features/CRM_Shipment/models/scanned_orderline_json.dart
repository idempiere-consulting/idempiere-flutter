class ScannedOrderLineIDJson {
  final List<OrderLineIDList>? orderLineIDList;

  ScannedOrderLineIDJson({this.orderLineIDList});

  ScannedOrderLineIDJson.fromJson(Map<String, dynamic> json)
      : orderLineIDList = (json['orderLineIDList'] as List?)
            ?.map((dynamic e) =>
                OrderLineIDList.fromJson(e as Map<String, dynamic>))
            .toList();
}

class OrderLineIDList {
  final int? id;
  final int? productId;

  OrderLineIDList({this.id, this.productId});

  OrderLineIDList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        productId = json['productId'] as int?;
}
