import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/http_exception.dart';
import '../../model/order_item.dart';
import './order_manager.dart';
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
            child: SizedBox(
              child: Column(
              children: [
                buildStatusOrder2(),
                const Divider(color: Colors.black,),
                buildStatusOrder1(),
              ],)
            ),
          ),
          buildOrderSummary(),
          buildOrderDetails()
        ],
      ),
    );
  }

  Widget buildStatusOrder2() {
    late OrderItem _order;
    return Container(
      child: ListTile(
        leading: ElevatedButton(
          child: Text("Xác nhận"),
          onPressed: () {
            print("BBBBBBBBBBBBBB");
            setState(() {
              final a = widget.order.orderStatus = 2;
              print(a);
            });
            _order = OrderItem(
                id: widget.order.id,
                amount: widget.order.amount,
                products: widget.order.products,
                totalQuantity: widget.order.totalQuantity,
                name: widget.order.name,
                phone: widget.order.phone,
                address: widget.order.address,
                payResult: widget.order.payResult,
                customerId: widget.order.customerId,
                orderStatus: 2);
            _submit(_order);
            setState(() {
              context.read<OrdersManagerAdmin>().removeItem(_order.id!);
              // Navigator.of(context).pushNamed(OrdersScreenAdmin.routeName);
            });
          },
        ),
      ),
    );
  }

  Widget buildStatusOrder1() {
    late OrderItem _order;
    return Container(
      child: ListTile(
        leading: ElevatedButton(
          child: Text("Hủy đơn hàng"),
          onPressed: () {
            print("BBBBBBBBBBBBBB");
            setState(() {
              final a = widget.order.orderStatus = 1;
              print(a);
            });
            _order = OrderItem(
                id: widget.order.id,
                amount: widget.order.amount,
                products: widget.order.products,
                totalQuantity: widget.order.totalQuantity,
                name: widget.order.name,
                phone: widget.order.phone,
                address: widget.order.address,
                payResult: widget.order.payResult,
                customerId: widget.order.customerId,
                orderStatus: 1);
            _submit(_order);
            context.read<OrdersManagerAdmin>().removeItem(_order.id!);
            // Navigator.of(context).pushNamed(OrdersScreenAdmin.routeName);
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
