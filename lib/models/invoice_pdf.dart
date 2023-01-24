class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;
  final List<List<Object>> dataChart;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
    required this.dataChart,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final String dueDate;
  final String credito;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.credito,
  });
}

class InvoiceItem {
  final String nombre;
  final String cedula;
  final int hrsAsig;
  final String vinculacio;
  final double unitPrice;

  const InvoiceItem({
    required this.nombre,
    required this.cedula,
    required this.hrsAsig,
    required this.vinculacio,
    required this.unitPrice,
  });
}

class Customer {
  final String name;
  final String address;

  const Customer({
    required this.name,
    required this.address,
  });
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  const Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}
