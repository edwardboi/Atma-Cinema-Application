class Makanan{
  final String name;
  final String harga;
  final String picture;
  final String category;
  const Makanan(this.name, this.harga, this.category, this.picture);
}


final List<Makanan> foodie =
  _food.map((e) => Makanan(e['name'] as String,e['harga'] as String,e['category'] as String,e['picture'] as String)).toList(growable: false);

final List<Map<String,Object>> _food =
  [
  {
    "picture": "images/foto1.png",
    "name": "Popcorn",
    "harga": "\Rp 39.000" ,
    "category": "food"
  },
  {
    "picture": "images/foto2.jpg",
    "name": "Iced Java Tea",
    "harga": "\Rp 25.000",
    "category": "beverage"
  },
  {
    "picture": "images/foto3.jpg",
    "name": "French Fries",
    "harga": "\Rp 35.000",
    "category": "food"
  },
  {
    "picture": "images/menu/ramen.jpg",
    "name": "Beef Ramen",
    "harga": "\Rp 75.000",
    "category": "food"
  },
  {
    "picture": "images/menu/limeMojito.jpg",
    "name": "Lime Mojito",
    "harga": "\Rp 59.000",
    "category": "beverage"
  },
  {
    "picture": "images/menu/hotdog.jpg",
    "name": "Spicy Hotdog",
    "harga": "\Rp 42.000",
    "category": "food"
  },
  {
    "picture": "images/menu/dumpling.jpg",
    "name": "Chinese Dumpling",
    "harga": "\Rp 999.000",
    "category": "food"
  },
  {
    "picture": "images/menu/baconSausage.jpg",
    "name": "Sausage & Bacon",
    "harga": "\Rp 55.000",
    "category": "food"
  },
    
];