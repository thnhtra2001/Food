import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/http_exception.dart';
import '../../model/order_item.dart';
import '../../services/order_service.dart';
import '../shared/dialog_utils.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;
  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  Future<void> _submit(order) async {
    try {
      await OrderService().updateOrder(order);
    } catch (error) {
      showErrorDialog(context,
          (error is HttpException) ? error.toString() : 'Có lỗi xảy ra');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.grey,
            child: Column(
              children: [buildStatusOrder3()],
            ),
          ),
          buildOrderSummary(),
          buildOrderDetails()
        ],
      ),
    );
  }

  Widget buildStatusOrder3() {
    late OrderItem _order;
    return Container(
      child: ListTile(
        title: Text('Vận chuyển thành công!'),
        trailing: ElevatedButton(
          child: Text("Đã nhận"),
          onPressed: () {
            print("Nhận được hàng rồi còn click gì nữa mèn ơi");
            // setState(() {
            //   final a = widget.order.orderStatus = 3;
            //   print(a);
            // });
            // _order = OrderItem(
            //     id: widget.order.id,
            //     amount: widget.order.amount,
            //     products: widget.order.products,
            //     totalQuantity: widget.order.totalQuantity,
            //     name: widget.order.name,
            //     phone: widget.order.phone,
            //     address: widget.order.address,
            //     payResult: widget.order.payResult,
            //     customerId: widget.order.customerId,
            //     orderStatus: 3);
            // _submit(_order);
          },
        ),
      ),
    );
  }

  Widget buildOrderDetails() {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN');
    return SizedBox(
      height: widget.order.productCount * 32,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListView(
          children: widget.order.products
              .map(
                (prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      prod.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${prod.quantity}x${formatCurrency.format(prod.price)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget buildOrderSummary() {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN');
    return ListTile(
      title: Text('${formatCurrency.format(widget.order.amount)}'),
      subtitle: Text(
        DateFormat('dd/MM/yyyy HH:mm').format(widget.order.dateTime),
      ),
    );
  }
}
