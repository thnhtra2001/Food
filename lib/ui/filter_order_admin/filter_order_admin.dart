import 'package:flutter/material.dart';
import 'package:foodapp/ui/shared/app_drawer_admin.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/order_item.dart';
import 'filter_admin_manager.dart';

class FilterOrderAdmin extends StatefulWidget {
  static const routeName = '/filter-order-admin';
  const FilterOrderAdmin({super.key});

  @override
  State<FilterOrderAdmin> createState() => _FilterOrderAdminState();
}

class _FilterOrderAdminState extends State<FilterOrderAdmin> {
  late Future<List<OrderItem>> _fetchOrders;
  @override
  void initState() {
    super.initState();
    _fetchOrders = context.read<FilterOrderAdminManager>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN');
    int a = 0;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thống kê doanh thu theo quý'),
        ),
        drawer: const AdminAppDrawer(),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: _fetchOrders,
                builder: (contex, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // return Center(child: Text(snapshot.data!.first.amount.toString()),);
                    return Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          Container(
                            child: Center(
                                child: Text(
                                    'Tổng số đơn hàng giao thành công: ${snapshot.data!.length}')),
                          ),

                          // buildTotal(context, snapshot),
                          // Container(child: ord = snapshot.data!.map((OrderItem e) => ListTile(title: e.dateTime,)).toList()),
                          // Container(child: Center(child: Text(snapshot.data!.length.))),
                          SizedBox(
                              height: 500,
                              child: ListView.builder(
                                itemCount: snapshot.data!.length.toInt(),
                                itemBuilder: (context, index) {
                                  // OrderItemCard(snapshot.data![index]);
                                  return Container(
                                    child: Column(children: [
                                      // Container(child: Text("AAAA"),),
                                      ListTile(
                                        leading: Text('Hóa đơn ${index + 1}'),
                                        subtitle: Text(
                                            'Ngày: ${snapshot.data![index].dateTime.day}/${snapshot.data![index].dateTime.month}/${snapshot.data![index].dateTime.year} - Tổng tiền: ${formatCurrency.format(snapshot.data![index].amount)}'),
                                        title: Text(
                                            'Tiền gốc: ${formatCurrency.format(snapshot.data![index].amount0)}'),
                                        trailing: Text(
                                            'Lợi nhuận: ${formatCurrency.format(snapshot.data![index].amount - snapshot.data![index].amount0)}'),
                                      ),
                                      const Divider(),
                                    ]),
                                  );
                                },
                              )),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                })
            //     child: ListView.builder(
            //   itemCount: orderFilter.length,
            //   itemBuilder: (context, index) {
            //     var i = orderFilter[index];
            //     return ListTile(
            //       title: Text('Hoa don ${i.id}'),
            //       subtitle: Text(
            //           'Ngay: ${i.dateTime.day}/${i.dateTime.month}/${i.dateTime.year} - Tong tien: ${i.amount}'),
            //     );
            //   },
            // )
            ));
  }

  // Widget buildTotal(BuildContext context, snapshot) {
  //   return Container(
  //       height: 50,
  //       color: Colors.grey,
  //       child:
  //           Center(child: snapshot.data.map((e) => Text(e.toString()))));
  ///////////////
  //   return Card(
  //     margin: const EdgeInsets.all(15),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           const Text(
  //             'Tổng doanh thu',
  //             style: TextStyle(fontSize: 20),
  //           ),
  //           const Spacer(),
  //           Chip(
  //             label: Text(
  //               data.toString(),
  //               style: TextStyle(
  //                 color: Theme.of(context).primaryTextTheme.titleLarge?.color,
  //               ),
  //             ),
  //             backgroundColor: Theme.of(context).primaryColor,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
