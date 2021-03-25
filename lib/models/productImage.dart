class ProductImage{
  int productImagesID;
  String imageURL;
  String uploadedAt;
  String productERPNumber;
  ProductImage({this.productImagesID,this.imageURL,this.uploadedAt,this.productERPNumber});
  factory ProductImage.fromJSON(dynamic json){
    return ProductImage(
      productImagesID: json['productImagesID'] == null ? 0 : json['productImagesID'],
      imageURL: json['imageURL'] == null ? "" : json['imageURL'],
      uploadedAt: json['uploadedAt'] == null ? "" : json['uploadedAt'],
      productERPNumber: json['productERPNumber'] == null ? "" : json['productERPNumber']
    );
  }
}