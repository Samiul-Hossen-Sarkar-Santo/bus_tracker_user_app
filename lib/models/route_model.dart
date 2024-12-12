import 'package:google_maps_flutter/google_maps_flutter.dart';

enum RouteModel {
  route1(
    title: "BUP-Uttara",
    busId: "busID1",
    image: "BUS_ROUTE_STD-0.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "Kalshi",
      "ECB",
      "Shewra",
      "Khilkhet",
      "Kawla",
      "Airport",
      "Jashimuddin",
      "Rajlakkhi",
      "Ajamper",
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.822955316790996, 90.37755673952572), // Kalshi
      LatLng(23.824020884508187, 90.3934177383597), // ECB
      LatLng(23.819216029533838, 90.41540465404796), // Shewra
      LatLng(23.82969007919262, 90.41997879904667), // Khilkhet
      LatLng(23.846703288899867, 90.41617172418385), // Kawla
      LatLng(23.84551477473964, 90.40292519850567), // Airport
      LatLng(23.861448009381977, 90.39564033767748), // Jashimuddin
      LatLng(23.861448009381977, 90.39564033767748), // Rajlakkhi
      LatLng(23.864479143183488, 90.40807594932116), // Ajamper
    ],
    end: "House Building",
    endLat: 23.87465207023296,
    endLong: 90.40045914907554,
  ),
  route2(
    title: "BUP-JFP-Kakrail",
    busId: "busID2",
    image: "BUS_ROUTE_STD-1.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "DOHS",
      "ECB Canteen",
      "ECB Chattar",
      "Shewra",
      "Bisso Road",
      "JFP",
      "Shahjadpur",
      "Uttar Badda",
      "Gulshan Link Road",
      "Middle Badda",
      "Rampura Bridge",
      "Rampura Bazar",
      "Abul Hotel",
      "Malibag Railgate",
      "Mouchak",
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.837389437055908, 90.36608061180581), // DOHS
      LatLng(23.830155835473633, 90.3765058676261), // ECB Canteen
      LatLng(23.823096030062512, 90.39419963167853), // ECB Chattar
      LatLng(23.819216029533838, 90.41540465404796), // Shewra
      LatLng(23.740172619169247, 90.42824003767369), // Bisso Road
      LatLng(23.81364710547437, 90.42424175326649), // JFP
      LatLng(23.79188797241111, 90.42462051549465), // Shahjadpur
      LatLng(23.784674140333053, 90.42587637237216), // Uttar Badda
      LatLng(23.780917472495172, 90.42112326651055), // Gulshan Link Road
      LatLng(23.779824706540822, 90.4237139117577), // Middle Badda
      LatLng(23.7682103049537, 90.42317510883893), // Rampura Bridge
      LatLng(23.760886627098355, 90.41898212254007), // Rampura Bazar
      LatLng(23.755544078400266, 90.41524848363444), // Abul Hotel
      LatLng(23.75029851837673, 90.41302899137293), // Malibag Railgate
      LatLng(23.74641911751909, 90.41187020831205), // Mouchak
    ],
    end: "Kakrail",
    endLat: 23.737308754695302,
    endLong: 90.4041336775186,
  ),
  route3(
    title: "BUP-Maghbazar-Kakrail",
    busId: "busID3",
    image: "BUS_ROUTE_STD-2.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "DOHS",
      "ECB Canteen",
      "ECB Chattar",
      "Navy HQ",
      "Kakali",
      "Chairman Bari",
      "Mahakhali",
      "Nabisco",
      "Sat Rasta",
      "Hatirjheel",
      "Maghbazar",
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.837389437055908, 90.36608061180581),
      LatLng(23.830155835473633, 90.3765058676261),
      LatLng(23.823096030062512, 90.39419963167853),
      LatLng(23.80376570930915, 90.40601671648612),
      LatLng(23.79599072491251, 90.40082388793944),
      LatLng(23.78870725753446, 90.4000011953465),
      LatLng(23.77192105584532, 90.40106537815393),
      LatLng(23.769802002618185, 90.40119855136194),
      LatLng(23.75759124323348, 90.39889324931787),
      LatLng(23.76525318132423, 90.4123214448155),
      LatLng(23.748450754938496, 90.40268778138497),
    ],
    end: "Maghbazar",
    endLat: 23.748872039981663,
    endLong: 90.4036745273261,
  ),
  route4(
    title: "BUP-Shahbagh",
    busId: "busID4",
    image: "BUS_ROUTE_STD-3.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "DOHS",
      "ECB Canteen",
      "Khalsi",
      "ECB Chattar",
      "Matikata",
      "Zia Colony",
      "CMH",
      "Army HQ",
      "CSD",
      "Post Office",
      "Adamji",
      "Workshop",
      "Shahid Jahangir Gate",
      "Bijoy Sarani",
      "Farmgate",
      "Karwan Bazar",
      "Bangla Motor",
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.837389437055908, 90.36608061180581),
      LatLng(23.830155835473633, 90.3765058676261),
      LatLng(23.82192970465969, 90.37771935440745),
      LatLng(23.823096030062512, 90.39419963167853),
      LatLng(23.820662421299698, 90.39046703767615),
      LatLng(23.816228021404065, 90.40415301621678),
      LatLng(23.813558341007067, 90.39829575116906),
      LatLng(23.83000242486954, 90.38837215176032),
      LatLng(23.805100330760137, 90.39609684779039),
      LatLng(23.80353248503173, 90.39343611295945),
      LatLng(23.7947677651623, 90.3932439953467),
      LatLng(23.7784944847623, 90.4057266145954),
      LatLng(23.775427509019135, 90.38967272260565),
      LatLng(23.765064279726612, 90.38612573767449),
      LatLng(23.75886383790603, 90.3898063953456),
      LatLng(23.751133197438225, 90.39270588000275),
      LatLng(23.745943114445428, 90.39481449904414),
    ],
    end: "Shahbagh",
    endLat: 23.738106930210062,
    endLong: 90.39587882926317,
  ),
  route5(
    title: "BUP-Khamar Bari Mor",
    busId: "busID5",
    image: "BUS_ROUTE_STD-4.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "Mirpur 12",
      "Mirpur 11.5",
      "Mirpur 11",
      "Mirpur 10",
      "Kazipara",
      "Shewrapara",
      "Taltola",
      "Agargaon",
      "Krishi University",
      "Chandrima Uddan"
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.828898622365294, 90.36433534898919), // Mirpur 12
      LatLng(23.82450543703228, 90.36437900329229), // Mirpur 11.5
      LatLng(23.81860252691158, 90.36697822674736), // Mirpur 11
      LatLng(23.804599549010902, 90.37380241139809), // Mirpur 10
      LatLng(23.80001142428453, 90.37176789534682), // Kazipara
      LatLng(23.791012472863233, 90.37567151068914), // Shewrapara
      LatLng(23.785246586805254, 90.37788032644607), // Taltola
      LatLng(23.777566693348877, 90.38026955069353), // Agargaon
      LatLng(23.76561996438381, 90.38311613720279), // Chandrima Uddan
    ],
    end: "Khamar Bari Mor",
    endLat: 23.758880509925685,
    endLong: 90.38369216231428,
  ),

  route6(
    title: "BUP-Asad Gate",
    busId: "busID6",
    image: "BUS_ROUTE_STD-5.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "Mirpur 12",
      "Mirpur 11.5",
      "Mirpur 11",
      "Proshika",
      "Commerce College",
      "Sony Hall",
      "Mirpur 01",
      "Ansar Camp",
      "Bangla College",
      "Technical",
      "Kallyanpur",
      "Shamoli",
      "RMS&C",
      "College Gate",
      "Shia Moshjid",
      "Shuchona Center",
      "Adabor Thana"
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.82450543703228, 90.36437900329229), // Mirpur 11.5
      LatLng(23.81575733203357, 90.36609331950163), // Mirpur 11/Milk-vita Road
      LatLng(23.81497659913363, 90.36272507856626), // Spartan Fitness
      LatLng(23.811432855624155, 90.36078667427861), // Nishat Bike Zone
      LatLng(23.809448679628332, 90.36116408985072), // Proshika
      LatLng(23.806011086470996, 90.35154979834113), // Commerce College
      LatLng(23.805125077616925, 90.35166838227215), // Commerce College mor
      LatLng(23.79997655599662, 90.3552123423596), // Sony Hall
      LatLng(23.798556103428073, 90.35323394679146), // Mirpur 01
      LatLng(23.785152440899125, 90.35384335041337), // Bangla College
      LatLng(23.781608038156982, 90.35178387650694), // Technical
      LatLng(23.7791332296404, 90.35649725740001), // Khalek Pump
      LatLng(23.778578290239505, 90.35995456599186), // Kallyanpur
      LatLng(23.773371725590795, 90.36720947907511), // Shishu Mela
      LatLng(23.76805928059568, 90.36928405313525), // College Gate
      LatLng(23.766592534981903, 90.36471550634664), // Camp
      LatLng(23.764297102547562, 90.36547849220003), // Tajmohol Road
      LatLng(23.762417539817875, 90.3588409967391), // Shia Moshjid
      LatLng(23.767450168551715, 90.35840866000913), // Shuchona Center
      LatLng(23.76931748386433, 90.3585873725444), // Shahabuddin Plaza
      LatLng(23.770513773002293, 90.35908612170924), // Adabor Thana
      LatLng(23.773386289116733, 90.36109877221789), // Shompa Market
      LatLng(23.774885890029985, 90.3655158643938), // Shamoli
    ],
    end: "Shia Moshjid",
    endLat: 23.762417539817875,
    endLong: 90.3588409967391,
  ),

  route7(
    title: "BUP-City College",
    busId: "busID7",
    image: "BUS_ROUTE_STD-6.png",
    start: "BUP",
    startLat: 23.83944781693273,
    startLong: 90.35820879403578,
    stopsInOrder: [
      "Mirpur 12",
      "Mirpur 11.5",
      "Mirpur 11",
      "Proshika",
      "Commerce College",
      "Sony Hall",
      "Mirpur 01",
      "Ansar Camp",
      "Bangla College",
      "Technical",
      "Kallyanpur",
      "Shamoli",
      "Asad Gate",
      "College Gate",
      "Genetic Plaza",
      "Agora",
      "Sankar",
      "Dhanmondi 15 No Road",
      "Dhanmondi 8 No Road",
      "BGB 4 No Gate"
    ],
    routeCoordinatesInOrder: [
      LatLng(23.83944781693273, 90.35820879403578), // BUP In Gate
      LatLng(23.834961899131887, 90.35881453781377), // DSCSC
      LatLng(23.831960189009205, 90.36158785487743), // DSCSC Mosque
      LatLng(23.831993428090584, 90.3636712000425), // NDC
      LatLng(23.828898622365294, 90.36433534898919), // Mirpur 12
      LatLng(23.82450543703228, 90.36437900329229), // Mirpur 11.5
      LatLng(23.81860252691158, 90.36697822674736), // Mirpur 11
      LatLng(23.80976090880386, 90.36061568000457), // Proshika
      LatLng(23.807290912726415, 90.35464526651138), // Commerce College
      LatLng(23.79998987037693, 90.35487926859835), // Sony Hall
      LatLng(23.79566184237608, 90.35325756194035), // Mirpur 01
      LatLng(23.791327706565657, 90.35422983767526), // Ansar Camp
      LatLng(23.784842683585428, 90.35251449534634), // Bangla College
      LatLng(23.781494797176006, 90.35247157974737), // Technical
      LatLng(23.77831238547684, 90.36117189534615), // Kallyanpur
      LatLng(23.774820158262894, 90.36546078767482), // Shamoli
      LatLng(23.760756495511984, 90.37292744206489), // Asad Gate
      LatLng(23.76824603842149, 90.36916972597055), // College Gate
      LatLng(23.755751893538253, 90.37312448000291), // Genetic Plaza
      LatLng(23.740042506398567, 90.37501625540348), // Agora
      LatLng(23.75101940282221, 90.36819696466021), // Sankar
      LatLng(23.744744029380264, 90.37252198000262), // Dhanmondi 15 No Road
      LatLng(23.746025727736527, 90.38097265116696), // Dhanmondi 8 No Road
      LatLng(23.739122866135798, 90.37636304528047), // RGB & No Gate
    ],
    end: "City College",
    endLat: 23.739079042145477,
    endLong: 90.38338455092443,
  );

  const RouteModel({
    required this.title,
    required this.busId,
    required this.image,
    required this.start,
    required this.startLat,
    required this.startLong,
    required this.stopsInOrder,
    required this.routeCoordinatesInOrder,
    required this.end,
    required this.endLat,
    required this.endLong,
  });

  final String title;
  final String busId;
  final String image;
  final String start;
  final double startLat;
  final double startLong;
  final List<String> stopsInOrder;
  final List<LatLng> routeCoordinatesInOrder;
  final String end;
  final double endLat;
  final double endLong;
}
