enum RouteModel {
  route1(
    title: "BUP-Uttara",
    image: "BUS_ROUTE_STD-0.png",
  ),
  route2(
    title: "BUP-JFP-Kakrail",
    image: "BUS_ROUTE_STD-1.png",
  ),
  route3(
    title: "BUP-Maghbazar-Kakrail",
    image: "BUS_ROUTE_STD-2.png",
  ),
  route4(
    title: "BUP-Shahbagh",
    image: "BUS_ROUTE_STD-3.png",
  ),
  route5(
    title: "BUP-Khamar Bari Mor",
    image: "BUS_ROUTE_STD-4.png",
  ),
  route6(
    title: "BUP-Asad Gate",
    image: "BUS_ROUTE_STD-5.png",
  ),
  route7(
    title: "BUP-City College",
    image: "BUS_ROUTE_STD-6.png",
  );

  const RouteModel({
    required this.title,
    required this.image,
  });

  final String title;
  final String image;
}
