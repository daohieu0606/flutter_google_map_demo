import 'package:map_demo/data/store.dart';

class StoreUtils {
  static List<Store> getCafeShops() {
    List<Store> res = List.empty(growable: true);

    res.add(Store(
      name: 'February Cafe & Cake',
      address: '125 Đ. Nguyễn Hồng Đào, Phường 14, Tân Bình',
      image:
          'https://lh5.googleusercontent.com/p/AF1QipNHvihWoW3Wyu6lw649b8QTD5_CVzjVPPHKuKNP=w408-h306-k-no',
      openHours: 'Open 24 hours',
      lat: 10.795533183387677,
      lng: 106.64297811216431,
    ));

    res.add(Store(
      name: 'The Simple Café',
      address: '26-28 Bàu Cát, Dist, Tân Bình',
      image:
          'https://lh5.googleusercontent.com/p/AF1QipPW4T9SbClMPOfj9zMAl9AlQwzG7MkaYMeu8Jfn=w408-h306-k-no',
      openHours: 'Open 24 hours',
      lat: 10.793377959243852,
      lng: 106.64328567210407,
    ));

    res.add(Store(
      name: 'Café de Nam - Café 135',
      address: '135 Bàu Cát 3, Phường 12, Tân Bình',
      image:
          'https://lh5.googleusercontent.com/p/AF1QipMAquyQDrQnrurnQ_FOGFU2ovjtZX-qyYHJ92fN=w408-h544-k-no',
      openHours: 'Open 24 hours',
      lat: 10.794702361214458,
      lng: 106.64275995913715,
    ));

    res.add(Store(
      name: 'Gia Cafe',
      address: '89 Đ. Nguyễn Hồng Đào, Phường 14, Tân Bình',
      image:
          'https://lh5.googleusercontent.com/p/AF1QipPL785Rj6yVH_oZbyX4J84EKf5Lf65Gp78WwvY=w408-h544-k-no',
      openHours: 'Open 24 hours',
      lat: 10.797717423745983,
      lng: 106.64434113249474,
    ));

    res.add(Store(
      name: 'INDIGO CAFÉ',
      address: '51 Bàu Cát 1, Phường 14, Tân Bình',
      image:
          'https://lh5.googleusercontent.com/p/AF1QipN7I-RkLU4E2g52BQ3s6EEsarNUiFPifov2fxc0=w408-h306-k-no',
      openHours: 'Open 24 hours',
      lat: 10.792875798050465,
      lng: 106.64178643239627,
    ));

    res.add(Store(
      name: 'Cafe Không Gian Xanh',
      address: '111 Bàu Cát 3, Phường 12, Tân Bình',
      image:
          'https://lh5.googleusercontent.com/p/AF1QipOtp8yvVQPn19iQb2a1C49ZwcMSJQTB5zuw-3bz=w408-h544-k-no',
      openHours: 'Open 24 hours',
      lat: 10.802268939348329,
      lng: 106.64332193898429,
    ));

    return res;
  }
}
