class Product {
  final String title;
  final double price;

  Product(this.title, this.price);

}
productList(){
  return [
    Product('Basic', 144),
    Product('Premium', 199),
    Product('One Time', 49),
  ];
}