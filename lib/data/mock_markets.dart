import '../models/market.dart';

const mockMarkets = [
  Market(
    id: '1',
    name: '建國花市',
    location: '台北市大安區建國南路',
    hours: '週六、日 09:00–18:00',
    image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    description: '建國假日花市是台北最大的假日花卉市集，除了鮮花盆栽外，也有有機蔬果與小農農產品攤位。',
    products: [
      Product(
        id: 'p1',
        name: '有機草莓',
        description: '苗栗大湖有機草莓，無農藥栽培',
        price: 180,
        image: 'https://images.unsplash.com/photo-1543158181-e6f9f6712055?w=300',
      ),
      Product(
        id: 'p2',
        name: '手工果醬',
        description: '百香果手工果醬，無添加防腐劑',
        price: 220,
        image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=300',
      ),
      Product(
        id: 'p3',
        name: '新鮮薑黃',
        description: '南投有機薑黃，現採新鮮',
        price: 120,
        image: 'https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=300',
      ),
    ],
  ),
  Market(
    id: '2',
    name: '永康街農夫市集',
    location: '台北市大安區永康街',
    hours: '週日 10:00–17:00',
    image: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=400',
    description: '位於永康街巷弄間的小型農夫市集，聚集多位小農直售，主打無毒蔬果與手工食品。',
    products: [
      Product(
        id: 'p4',
        name: '有機小番茄',
        description: '宜蘭有機小番茄，酸甜多汁',
        price: 90,
        image: 'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300',
      ),
      Product(
        id: 'p5',
        name: '天然蜂蜜',
        description: '花蓮龍眼蜜，純天然無摻糖',
        price: 350,
        image: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=300',
      ),
    ],
  ),
  Market(
    id: '3',
    name: '光復南路有機市集',
    location: '台北市信義區光復南路',
    hours: '週六 08:00–14:00',
    image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400',
    description: '信義區在地農夫市集，每週六早市，主打台灣在地有機農產品與原住民特色食材。',
    products: [
      Product(
        id: 'p6',
        name: '原住民小米',
        description: '花蓮阿美族有機小米',
        price: 150,
        image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300',
      ),
      Product(
        id: 'p7',
        name: '有機地瓜',
        description: '雲林有機黃金地瓜',
        price: 80,
        image: 'https://images.unsplash.com/photo-1596097635121-14b63b7a0c19?w=300',
      ),
    ],
  ),
];
