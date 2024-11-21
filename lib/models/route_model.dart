enum RouteModel {
  route1(
    title: "BUP-Uttara",
    image: "BUS_ROUTE_STD-0.png",
    start: "BUP",
    stops_in_order: [
      "Kalshi",
      "ECB",
      "Shewra",
      "Khilkhet",
      "Kawla",
      "Airport",
      "Jashimuddin",
      "Rajlakkhi",
      "Ajamper"
    ],
    end: "House Building",
  ),
  route2(
    title: "BUP-JFP-Kakrail",
    image: "BUS_ROUTE_STD-1.png",
    start: "BUP",
    stops_in_order: ["JFP", "Kakrail"],
    end: "Kakrail",
  ),
  route3(
    title: "BUP-Maghbazar-Kakrail",
    image: "BUS_ROUTE_STD-2.png",
    start: "BUP",
    stops_in_order: ["Maghbazar", "Kakrail"],
    end: "Kakrail",
  ),
  route4(
    title: "BUP-Shahbagh",
    image: "BUS_ROUTE_STD-3.png",
    start: "BUP",
    stops_in_order: ["Shahbagh"],
    end: "Shahbagh",
  ),
  route5(
    title: "BUP-Khamar Bari Mor",
    image: "BUS_ROUTE_STD-4.png",
    start: "BUP",
    stops_in_order: ["Khamar Bari Mor"],
    end: "Khamar Bari Mor",
  ),
  route6(
    title: "BUP-Asad Gate",
    image: "BUS_ROUTE_STD-5.png",
    start: "BUP",
    stops_in_order: ["Asad Gate"],
    end: "Asad Gate",
  ),
  route7(
    title: "BUP-City College",
    image: "BUS_ROUTE_STD-6.png",
    start: "BUP",
    stops_in_order: ["City College"],
    end: "City College",
  );

  const RouteModel({
    required this.title,
    required this.image,
    required this.start,
    required this.stops_in_order,
    required this.end,
  });

  final String title;
  final String image;
  final String start;
  final List<String> stops_in_order; // Changed this to a List of Strings
  final String end;
}
