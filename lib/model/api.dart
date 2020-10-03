class BaseUrl {
  //static String ipAdress = "https://www.zakuuza.com/"; //192.168.43.196:81
  static String ipAdress =
      "http://192.168.43.141/Projects/"; //192.168.43.196:81
  // static String ipAdress = "http://192.168.8.100/"; //192.168.43.196:81
  // static String ipAdress = "http://172.20.10.2//"; //192.168.43.196:81
  static String login = ipAdress + "API/api/login.php";
  static String signin = ipAdress + "API/api/signin.php";
  static String selectProduct =
      ipAdress + "API/api/get_data.php/?value=product";
  static String selectCategory =
      ipAdress + "API/api/get_data.php/?value=category";
  static String uploadUrl =
      ipAdress + "zakuuzaAdmin/zakuuzaAdmin/imgtout/"; //online images
  // static String uploadUrl = ipAdress+"API/api/imgload/"; //local images
  static String panierUrl = ipAdress + "API/api/update_panier.php";
  static String panierdetailsUrl = ipAdress + "API/api/detail_panier.php";
  static String searchData = ipAdress + "API/api/search.php?value=product";
  static String addLike = ipAdress + "API/api/add_likes.php";
  static String orderedList = ipAdress + "API/api/orderedProducts.php";
}
