import 'package:flutter/material.dart';

class TableView extends StatelessWidget {
  const TableView({super.key, required this.headers, required this.data});

  final List<String> headers;
  final List<List<String>> data;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        for (var i = 0; i < headers.length; i++)
          i: FlexColumnWidth(i == headers.length - 1 ? 2 : 1),
      },
      children: [
        TableRow(
          children: List.generate(
            headers.length,
            (index) => TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(headers[index]),
              ),
            ),
          ),
        ),
        ...data.map(
          (row) => TableRow(
            children: List.generate(
              row.length,
              (index) => TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(row[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
