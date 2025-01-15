class GAN {
  final String ganId;
  final String staffId;
  final DateTime date;
  final int increasedQuantity;
  final int descreaedQuantity;
  final String note;

  GAN({
    required this.ganId,
    required this.staffId,
    required this.date,
    required this.increasedQuantity,
    required this.descreaedQuantity,
    required this.note,
  });

  factory GAN.fromMap(Map<String, dynamic> data) {
    return GAN(
      ganId: data['ganId'] ?? '',
      staffId: data['sId'] ?? '',
      date: (data['date']).toDate(),
      increasedQuantity: data['increasedQuantity'] ?? 0,
      descreaedQuantity: data['iecreasedQuantity'] ?? 0,
      note: data['note'] ?? '',
    );
  }

}

class GANDetail {
  final String ganId;
  final String productId;
  final List<String> size;
  final int oldQuantity;
  final int newQuantity;

  GANDetail({
    required this.ganId,
    required this.productId,
    required this.size,
    required this.oldQuantity,
    required this.newQuantity,
  });

  factory GANDetail.fromMap(Map<String, dynamic> data) {
    return GANDetail(
      ganId: data['ganId'] ?? '',
      productId: data['pid'] ?? '',
      size: data['sizes'] ?? '',
      oldQuantity: data['oldQuantity'] ?? 0,
      newQuantity: data['newQuantity'] ?? 0,
    );
  }

}
